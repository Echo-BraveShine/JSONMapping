//
//  TextView.swift
//  JSONMapping
//
//  Created by BraveShine on 2021/1/9.
//

import SwiftUI
import Highlightr3
import Combine
import SwiftyUserDefaults

enum TextViewTheme: String,DefaultsSerializable,CaseIterable,Identifiable {
    case atom_one_dark = "atom-one-dark"
    case darcula = "darcula"
    case dracula = "dracula"
    case github = "github"
    case solarized_dark = "solarized-dark"
    case solarized_light = "solarized-light"
    
    var id: String{
        return self.rawValue
    }
}
enum TextViewLanguage : String{
    case json
    case swift
    case objc = "objectivec"
}


struct EditorTextView: NSViewRepresentable {
    @Binding var text: String
    var isEditable: Bool = true
    var font: NSFont?    = .systemFont(ofSize: 14, weight: .regular)
    
    var onEditingChanged: () -> Void       = {}
    var onCommit        : () -> Void       = {}
    var onTextChange    : (String) -> Void = { _ in }
    
    var language: TextViewLanguage = .json

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> CustomTextView {
        let textView = CustomTextView(
            text: text,
            isEditable: isEditable,
            font: font
        )
        textView.delegate = context.coordinator
        
        return textView
    }
    
    func updateNSView(_ view: CustomTextView, context: Context) {
        view.text = text
        view.selectedRanges = context.coordinator.selectedRanges
        view.language = language
    }
}


// MARK: - Coordinator
extension EditorTextView {
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: EditorTextView
        var selectedRanges: [NSValue] = []
        
        init(_ parent: EditorTextView) {
            self.parent = parent
        }
        
        func textDidBeginEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            
            self.parent.text = textView.string
            self.parent.onEditingChanged()
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            
            self.parent.text = textView.string
            self.selectedRanges = textView.selectedRanges
            
//            textView.textStorage?.setAttributes([NSAttributedString.Key.backgroundColor : NSColor.clear], range: NSRange.init(location: 0, length: textView.string.count))
        }
        
        func textDidEndEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            
            self.parent.text = textView.string
            self.parent.onCommit()
        }
    }
}

// MARK: - CustomTextView
final class CustomTextView: NSView {
    private var isEditable: Bool
    private var font: NSFont?
    
    weak var delegate: NSTextViewDelegate?
    
    var text: String {
        didSet {
            textView.string = text
        }
    }
    
    var theme: TextViewTheme = .solarized_light{
        didSet{
           let _ = highlightr.setTheme(to: theme.rawValue)
        }
    }
    
    var language: TextViewLanguage = .json{
        didSet{
            textStorage.language = language.rawValue
        }
    }
    
    var selectedRanges: [NSValue] = [] {
        didSet {
            guard selectedRanges.count > 0 else {
                return
            }
            
            textView.selectedRanges = selectedRanges
        }
    }
    
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = true
        scrollView.borderType = .bezelBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalRuler = false
        scrollView.autoresizingMask = [.width, .height]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var textView: NSTextView = {
        let contentSize = scrollView.contentSize
        
        
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(containerSize: scrollView.frame.size)
        textContainer.widthTracksTextView = true
        textContainer.containerSize = NSSize(
            width: contentSize.width,
            height: CGFloat.greatestFiniteMagnitude
        )
        
        layoutManager.addTextContainer(textContainer)
        
        
        let textView                     = NSTextView(frame: .zero, textContainer: textContainer)
        textView.autoresizingMask        = .width
        textView.backgroundColor         = NSColor.gridColor
        textView.delegate                = self.delegate
        textView.drawsBackground         = false
        textView.font                    = self.font
        textView.isEditable              = self.isEditable
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable   = true
        textView.maxSize                 = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.minSize                 = NSSize(width: 0, height: contentSize.height)
        textView.textColor               = NSColor.labelColor
        textView.allowsUndo              = true
        textView.allowsDocumentBackgroundColorChange = false

//        textView.
        
        return textView
    }()
    
    lazy var highlightr: Highlightr = {
        let h = Highlightr()!
        let _ = h.setTheme(to: theme.rawValue)
        return h
    }()
    
    lazy var textStorage: HighlightTextStorage = {
        let textStorage = HighlightTextStorage.init(highlightr: highlightr)
        textStorage.language = language.rawValue
        textStorage.foregroundColor = .clear
        return textStorage
    }()
    
    // MARK: - Init
    init(text: String, isEditable: Bool, font: NSFont?) {
        self.font       = font
        self.isEditable = isEditable
        self.text       = text
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    var dispose: DefaultsDisposable?
    
    override func viewWillDraw() {
        super.viewWillDraw()
        
        setupScrollViewConstraints()
        setupTextView()
        
        dispose =  Defaults.observe(\.textViewTheme, options: [.new,.old]) { (update) in
            guard let new = update.newValue,let old = update.oldValue else{return}
            if old != new{
                self.theme = new
            }
        }

        
    }
    
    deinit {
        dispose?.dispose()
    }
    
    func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    
    func setupTextView() {
        scrollView.documentView = textView
    }
}

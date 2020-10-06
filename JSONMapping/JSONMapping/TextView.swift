//
//  TextView.swift
//  JSONMapping
//
//  Created by BraveShine on 2020/10/5.
//

import AppKit
import SwiftUI


class TextInputView: NSScrollView,NSTextStorageDelegate {
    
    
    var textDidChangeBlock: ((String)->())?
    
    lazy var textView: NSTextView = {
        let v = NSTextView()
        v.backgroundColor = .clear
        v.textStorage?.delegate = self
        v.textColor = .red
        v.font = NSFont.systemFont(ofSize: 15)
        v.typingAttributes = [.font:NSFont.systemFont(ofSize: 15),.foregroundColor:NSColor.red]
        v.isIncrementalSearchingEnabled = true
        v.isEditable = true
        v.isSelectable = true
        v.isAutomaticSpellingCorrectionEnabled = true
        v.smartInsertDeleteEnabled = true
        v.drawsBackground = true
        return v
    }()
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.hasVerticalScroller = true
        self.addSubview(textView)
        self.documentView = textView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        textView.frame = self.bounds
    }
    
    
    
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        guard let str = self.textView.textStorage?.string else{return}
        var text : String = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        text = text .replacingOccurrences(of: "”", with: "\"")
        text = text .replacingOccurrences(of: "，", with: ",")
        textDidChangeBlock?(text)
    }
    
}


struct TextView: NSViewRepresentable {
    
    @Binding var text: String
    
    var isEditable: Bool = true
    
    func makeNSView(context: Context) -> TextInputView {
        let s = TextInputView()
        s.textView.isEditable = isEditable
        s.textDidChangeBlock = { string in
            if self.text != string{
                self.text = string
            }
        }
        return s
    }
    
    func updateNSView(_ nsView: TextInputView, context: Context) {
    }
    
    typealias NSViewType = TextInputView
    
    
}

struct OutputTextView: NSViewRepresentable {
    
    @Binding var text: String
    
    var isEditable: Bool = true
    
    func makeNSView(context: Context) -> TextInputView {
        let s = TextInputView()
        s.textView.isEditable = isEditable
        return s
    }
    
    func updateNSView(_ nsView: TextInputView, context: Context) {
        nsView.textView.string = text
    }
    
    typealias NSViewType = TextInputView
    
    
}


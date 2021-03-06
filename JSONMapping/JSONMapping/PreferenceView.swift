//
//  PreferenceView.swift
//  JSONMapping
//
//  Created by BraveShine on 2021/1/10.
//

import SwiftUI
import SwiftyUserDefaults


enum SwiftAttribute: String, CaseIterable,Identifiable ,DefaultsSerializable{
    case `var`,`let`
    
    var id: String{
        return self.rawValue
    }
}

enum SwiftModelType: String, CaseIterable,Identifiable,DefaultsSerializable {
    case `struct`,`class`
    var id: String{
        return self.rawValue
    }
}

enum SwiftOptional: String, CaseIterable,Identifiable,DefaultsSerializable {
    var id: String{
        self.rawValue
    }
    
    
    case `default`
    case `optional`
    
    var desc: String{
        switch self {
        case .default:
            return NSLocalizedString("Some", comment: "")
        case .optional:
            return NSLocalizedString("None", comment: "")
        }
    }
}


extension DefaultsKeys{
    var textViewTheme: DefaultsKey<TextViewTheme> { .init("TextViewTheme", defaultValue: TextViewTheme.solarized_light) }
    
    var swiftAttribute: DefaultsKey<SwiftAttribute> { .init("SwiftAttribute", defaultValue: SwiftAttribute.let) }
    
    var swiftModelType: DefaultsKey<SwiftModelType> { .init("SwiftModelType", defaultValue: SwiftModelType.struct) }
    
    var swiftOptional: DefaultsKey<SwiftOptional> { .init("SwiftOptional", defaultValue: SwiftOptional.default) }
    
    var defaultLanguage: DefaultsKey<MappingLanguage> { .init("MappingLanguage", defaultValue: MappingLanguage.swift) }
    
}

class PreferenceManager: ObservableObject {
    
    
    
    @Published var theme: TextViewTheme{
        didSet{
            Defaults[\.textViewTheme] = theme
        }
    }
    
    @Published var swiftAttribute: SwiftAttribute{
        didSet{
            Defaults[\.swiftAttribute] = swiftAttribute
        }
    }
    
    @Published var swiftModelType: SwiftModelType{
        didSet{
            Defaults[\.swiftModelType] = swiftModelType
        }
    }
    
    @Published var swiftOptional: SwiftOptional{
        didSet{
            Defaults[\.swiftOptional] = swiftOptional
        }
    }
    
    
    init() {
        self.theme = Defaults[\.textViewTheme]
        self.swiftAttribute = Defaults[\.swiftAttribute]
        self.swiftModelType = Defaults[\.swiftModelType]
        self.swiftOptional = Defaults[\.swiftOptional]
        
    }
}

struct PreferenceView: View {
    
    @StateObject var viewModel = PreferenceManager()
    
    
    var body: some View {
        
        //        VStack.init(alignment: .trailing, spacing: 10) {
        
    
        TabView.init  {
                        VStack.init(alignment: .center, spacing: 0, content: {
                            HStack.init(alignment: .center, spacing: 10) {
                                Spacer()
                                Text(NSLocalizedString("Text highlighted:", comment: ""))
                                MenuButton.init(label: Text(self.viewModel.theme.rawValue)) {
                                    ForEach(TextViewTheme.allCases){ item in
                                        Button.init(action: {
                                            self.viewModel.theme = item
                                        }, label: {
                                            Text("\(item.rawValue)")
                                        })
                                    }
                                }
                                .frame(width: 150, height: 30, alignment: .center)
                                Spacer()
                            }
                        })
                        
                        .tabItem { Text(NSLocalizedString("general", comment: "")) }
                        .tag(1)
                        
                        
                        VStack.init(alignment: .center, spacing: 10, content: {
                           
                            HStack.init(alignment: .center, spacing: 10) {
                                Spacer()
                                Text(NSLocalizedString("Swift Attribute:", comment: ""))
                                MenuButton.init(label: Text(self.viewModel.swiftAttribute.rawValue)) {
                                    
                                    ForEach(SwiftAttribute.allCases){ item in
                                        Button.init(action: {
                                            self.viewModel.swiftAttribute = item
                                        }, label: {
                                            Text("\(item.rawValue)")
                                        })
                                    }
                                }
                                .frame(width: 150, height: 30, alignment: .center)

                                Spacer()
                            }
                            
                            HStack.init(alignment: .center, spacing: 10) {
                                Spacer()
                                Text(NSLocalizedString("Swift Type:", comment: ""))
                                MenuButton.init(label: Text(self.viewModel.swiftModelType.rawValue)) {
                                    ForEach(SwiftModelType.allCases){ item in
                                        Button.init(action: {
                                            self.viewModel.swiftModelType = item
                                        }, label: {
                                            Text("\(item.rawValue)")
                                        })
                                    }
                                }
                                .frame(width: 150, height: 30, alignment: .center)

                                Spacer()
                            }
                            
                            HStack.init(alignment: .center, spacing: 10) {
                                Spacer()
                                Text(NSLocalizedString("Swift Optional:", comment: ""))
                                MenuButton.init(label: Text(self.viewModel.swiftOptional.rawValue)) {
                                    ForEach(SwiftOptional.allCases){ item in
                                        Button.init(action: {
                                            self.viewModel.swiftOptional = item
                                        }, label: {
                                            Text("\(item.rawValue)")
                                        })
                                    }
                                }
                                .frame(width: 150, height: 30, alignment: .center)

                                Spacer()
                            }
                        })
                        .tabItem { Text("Swift") }
                        .tag(2)
                     }
            
            //        }
            .padding(.all, 20)
        
    }
}

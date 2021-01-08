//
//  ContentView.swift
//  JSONMapping
//
//  Created by BraveShine on 2020/10/5.
//

import SwiftUI
enum SwiftMappingType: String, CaseIterable,Identifiable {
    var id: String{
        self.rawValue
    }
    
    
    case `default`
    case `optional`
    
    var desc: String{
        switch self {
        case .default:
            return "默认"
        case .optional:
            return "可选"
        }
    }
}

enum MappingLanguage: String, CaseIterable,Identifiable {
    var id: String{
        self.rawValue
    }
    
    case swift
    case objc
    
    var desc: String{
        switch self {
        case .swift:
            return "Swift"
        case .objc:
            return "ObjC"
        }
    }
}


class ContentViewModel: ObservableObject {
    @Published var inputText: String = ""
    
    @Published var outputText: String = ""
    @Published var type: SwiftMappingType = .default
    
    @Published var language : MappingLanguage = .swift
    
    
    func format() {
        var errors: [JSONParseError] = []
        if let s = inputText.pretifyJSONv2(format: 4, spaces: true, allowWeakJSON: true, errors: &errors){
            inputText = s
        }
    }
    
    func conversion(){
        if language == .swift{
            let c = SwiftConversion()
            c.type = type
            let s = c.conversion(inputText)
            outputText = s
        }
        
        if language == .objc {
            let c = ObjcConversion()
            let s = c.conversion(inputText)
            outputText = s
        }
    }
}

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    
    
    var body: some View {
        VStack {
            GeometryReader.init { proxy in
                let centerWidth : CGFloat = 200
                let leftWidth : CGFloat = (proxy.size.width - centerWidth) / 2
                let rightWidth : CGFloat = leftWidth
                
                HStack.init(alignment: .top, spacing: 0, content: {
                    VStack.init(alignment: .center, spacing: 0, content: {
                        Text("请输入JSON")
                            .padding(.all, 10)
                        
                        TextEditor.init(text: self.$viewModel.inputText)
                    }).frame(width: leftWidth, height: proxy.size.height, alignment: .top)
                    
                    
                    VStack.init(alignment: .center, spacing: 0) {
                        MenuButton(label: Text("\(self.viewModel.language.desc)")) {
                            
                            ForEach(MappingLanguage.allCases){ item in
                                Button.init(action: {
                                    self.viewModel.language = item
                                }, label: {
                                    Text("\(item.desc)")
                                })
                            }
                            
                            
                            
                        }
                        .padding(.top, 30)
                        .padding(.all, 5)
                        
                        if viewModel.language == .swift{
                            
                            MenuButton(label: Text("\(self.viewModel.type.desc)")) {
                                ForEach(SwiftMappingType.allCases){ item in
                                    Button.init(action: {
                                        self.viewModel.type = item
                                    }, label: {
                                        Text("\(item.desc)")
                                    })
                                }
                            }
                            .padding(.top, 30)
                                .padding(.all, 5)
                        }
                        
                        
                        
                        Spacer()
                        
                        HStack.init(alignment: .center, spacing: 10) {
                            Button.init(action: {
                                self.viewModel.format()
                            }, label: {
                                Text("格式化")
                            })
                            Button.init(action: {
                                self.viewModel.conversion()
                            }, label: {
                                Text("转换")
                            })
                            Button.init(action: {
                                let pboard = NSPasteboard.general
                                pboard.declareTypes([.string], owner: nil)
                                pboard.setString(viewModel.outputText, forType: .string)
                            }, label: {
                                Text("复制")
                            })
                        }
                        .padding(.bottom, 10)
                        
                    }.frame(width: centerWidth, height: proxy.size.height, alignment: .top)
                    
                    VStack.init(alignment: .center, spacing: 0, content: {
                        Text("转换后")
                            .padding(.all, 10)
                        VStack.init {
                            TextEditor.init(text: self.$viewModel.outputText)
                        }
                        .background(Color.white)
                        .frame(width: nil, height: nil, alignment: .top)
                        
                    })
                    .frame(width: rightWidth, height: proxy.size.height, alignment: .top)
                    
                })
            }.padding([.leading,.trailing,.bottom], 20)
            
        }
    }
    
    
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




/*
 {
 "items": [
 {
 "id": 3,
 "name": "音乐",
 "img_url": "https://img.sumeme.com/18/2/1586055853842.png",
 "order": 6
 },
 {
 "id": 4,
 "name": "女神",
 "img_url": "https://img.sumeme.com/39/7/1586055840679.png",
 "order": 5
 },
 {
 "id": 5,
 "name": "舞蹈",
 "img_url": "https://img.sumeme.com/53/5/1586055830325.png",
 "order": 4
 },
 {
 "id": 7,
 "name": "脱口秀",
 "img_url": "https://img.sumeme.com/35/3/1586055819939.png",
 "order": 3
 },
 {
 "id": 9,
 "name": "新人",
 "img_url": "https://img.sumeme.com/34/2/1588056053090.png",
 "order": 2
 }
 ]
 }
 */
/*
 {"video":{"id":"29BA6ACE7A9427489C33DC5901307461","title":"体验课01","desp":"","tags":" ","duration":503,"category":"07AD1E11DBE6FDFC","image":"http://2.img.bokecc.com/comimage/0DD1F081022C163E/2016-03-09/29BA6ACE7A9427489C33DC5901307461-0.jpg","imageindex":0,"image-alternate":[{"index":0,"url":"http://2.img.bokecc.com/comimage/0DD1F081022C163E/2016-03-09/29BA6ACE7A9427489C33DC5901307461-0/0.jpg"},{"index":1,"url":"http://2.img.bokecc.com/comimage/0DD1F081022C163E/2016-03-09/29BA6ACE7A9427489C33DC5901307461-0/1.jpg"},{"index":2,"url":"http://2.img.bokecc.com/comimage/0DD1F081022C163E/2016-03-09/29BA6ACE7A9427489C33DC5901307461-0/2.jpg"},{"index":3,"url":"http://2.img.bokecc.com/comimage/0DD1F081022C163E/2016-03-09/29BA6ACE7A9427489C33DC5901307461-0/3.jpg"}]}}
 */

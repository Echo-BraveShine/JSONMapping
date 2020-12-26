//
//  ContentView.swift
//  JSONMapping
//
//  Created by BraveShine on 2020/10/5.
//

import SwiftUI
enum MappingType: CaseIterable {
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

struct ContentView: View {
    
    @State var type: MappingType = .default
    
    @State var inputText: String = ""
    
    @State var outputText: String = ""
    
    var body: some View {
        VStack {
            GeometryReader.init { proxy in
                HStack.init(alignment: .top, spacing: 0, content: {
                    VStack.init(alignment: .center, spacing: 0, content: {
                        Text("请输入JSON")
                            .padding(.all, 10)
                        TextEditor.init(text: $inputText)
                    }).frame(width: proxy.size.width * 0.4, height: proxy.size.height, alignment: .top)
                    
                    
                    VStack.init(alignment: .center, spacing: 0) {
                        MenuButton(label: Text("\(type.desc)")) {
                            Button.init(action: {
                                self.type = MappingType.default
                            }, label: {
                                Text("\(MappingType.default.desc)")
                            })
                            Button.init(action: {
                                self.type = MappingType.optional
                            }, label: {
                                Text("\(MappingType.optional.desc)")
                            })
                        }
                        .padding(.top, 30)
                        .padding(.all, 5)
                        
                        Spacer()
                        
                        HStack.init(alignment: .center, spacing: 10) {
                            Button.init(action: {
                                self.conversion(self.inputText)
                            }, label: {
                                Text("转换")
                            })
                            Button.init(action: {
                                let pboard = NSPasteboard.general
                                pboard.declareTypes([.string], owner: nil)
                                pboard.setString(outputText, forType: .string)
                            }, label: {
                                Text("复制")
                            })
                        }
                        .padding(.bottom, 10)
                        
                    }.frame(width: proxy.size.width * 0.2, height: proxy.size.height, alignment: .top)
                    
                    VStack.init(alignment: .center, spacing: 0, content: {
                        Text("转换后")
                            .padding(.all, 10)
                        VStack.init {
                            TextEditor.init(text: $outputText)
                        }
                        .background(Color.white)
                        .frame(width: nil, height: nil, alignment: .top)
                        
                    }).frame(width: proxy.size.width * 0.4, height: proxy.size.height, alignment: .top)
                    
                })
            }
            
        }
    }
    
    func conversion(_ string: String){
        let c = Conversion.init(type: type, time: 0)
        let s = c.conversion(string)
        print(s)
        outputText = s
    }
}

class Conversion {
    
    var type : MappingType = .default
    var time:Int = 0
    
    
    init(type : MappingType,time:Int = 0) {
        self.type = type
        self.time = time
    }
    
    func conversion(_ string: String) -> String{
        guard let jsonData = string.data(using: .utf8) else{ return "" }
        
        if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers){
            
            if let dict : [String : Any] = json as? [String : Any] {
                let s = conversionDictionary(dict)
                
                return s
            }
            
            if let array : [Any] = json as? [Any]{
                
                let s =  conversionArray(array)
                
                return s
            }
        }
        return "JSON格式不能解析"
    }
    
    
    func conversionDictionary(_ dict: [String : Any]) -> String{
        var result : String = "\(String(repeating: "    ", count: time))struct Object\(time) {"
        let tmpTime = time
        time += 1
        dict.keys.forEach { (str) in
            if let value = dict[str]{
                var s : String = "Any"
                if let string : String = value as? String{
                    s =  conversionstring(string)
                }else if let int : Int = value as? Int{
                    s =  conversionInt(int)
                }else if let float : Float = value as? Float{
                    s =  conversionFloat(float)
                }else if let double : Double = value as? Double{
                    s = conversionDouble(double)
                }else if let bool: Bool = value as? Bool{
                    s = conversionBool(bool)
                }else if let array : [Any] = value as? [Any]{
                    s = conversionArray(array)
                }else if let dict : [String : Any] = value as? [String : Any]{
                    let c = Conversion.init(type: type, time: time)
                    s =  "Object\(time)?" + "\n\n" + c.conversionDictionary(dict)
                }
                
                result += "\n\n\(String(repeating: "    ", count: time))var " + str.replacingOccurrences(of: "-", with: "_") + " : " + "\(s)"
                
            }
        }
        result += "\n\n\(String(repeating: "    ", count: tmpTime))}"
        
        return result
    }
    
    func conversionArray(_ array: [Any]) -> String{
        if let list: [[String: Any]] = array as?  [[String: Any]],let obj = list.first{
            let c = Conversion.init(type: type, time: time)
            return  "[Object\(time)]" + "\(type == .`default` ? " = []" : "?")" + "\n\n" +  c.conversionDictionary(obj)
        }else{
            return "[Any]"
        }
    }
    
    func conversionstring(_ string: String) -> String{
        return "String" + (type == .`default` ? " = \"\"" : "?")
    }
    
    func conversionInt(_ int : Int) -> String{
        return "Int" + (type == .`default` ? " = 0" : "?")
    }
    
    func conversionFloat(_ float: Float) -> String{
        return "Float" + (type == .`default` ? " = 0.0" : "?")
    }
    
    func conversionDouble(_ double : Double) -> String{
        return "Double" + (type == .`default` ? " = 0.0" : "?")
    }
    func conversionBool(_ bool : Bool) -> String{
        return "Bool" + (type == .`default` ? " = false" : "?")
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

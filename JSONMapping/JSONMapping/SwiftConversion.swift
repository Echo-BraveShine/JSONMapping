//
//  SwiftConversion.swift
//  JSONMapping
//
//  Created by BraveShine on 2020/12/29.
//

import Foundation

class SwiftConversion {
    
    var type : SwiftMappingType = .default
    var objects: [String] = []
    
    func conversion(_ string: String) -> String{
        guard let jsonData = string.data(using: .utf8) else{ return "" }
        
        if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers){
            
            var s = conversionAny(json)
            
            s +=    objects.joined(separator: "\n\n")
            
            return s
            
        }
        return "JSON格式不能解析"
    }

    
    func conversionAny(_ any: Any,_ name: String? = nil) -> String{
        var s : String = ""
        if let string : String = any as? String{
            s =  conversionstring(string,name ?? "")
        }else if let int : Int = any as? Int{
            s =  conversionInt(int,name ?? "")
        }else if let float : Float = any as? Float{
            s =  conversionFloat(float,name ?? "")
        }else if let double : Double = any as? Double{
            s = conversionDouble(double,name ?? "")
        }else if let bool: Bool = any as? Bool{
            s = conversionBool(bool,name ?? "")
        }else if let array : [Any] = any as? [Any]{
            s = conversionArray(array,name)
    
        }else if let dict : [String : Any] = any as? [String : Any]{
            s = conversionDictionary(dict,name)
           
        }
        return s
    }
    
    func conversionDictionary(_ dict: [String : Any],_ name: String? = nil) -> String{
        
        var p : String = ""
        if let n = name{
            let clsName = n.capitalized
            p = "   let \(n) : \(clsName)" + (type == .`default` ? " = \(clsName)()" : "?")
        }
        self.conversionDictionarySubProperty(dict: dict,name)
        
        return p
    }
    
    func conversionDictionarySubProperty(dict: [String : Any],_ name: String? = nil)  {
        
        let clsName: String = name?.capitalized ?? "Object"

        
        var result : String = "struct \(clsName) { \n"//"@interface \(name?.capitalized ?? "Object") : NSObject \n"
      
        dict.keys.forEach { (str) in
            if let value = dict[str]{
                result += "\n"
                result += conversionAny(value,str)
                result += "\n"
            }
        }
        
        result += "\n}\n"
        
        objects.append(result)
        
    }
    
    
    func conversionArray(_ array: [Any],_ name: String? = nil) -> String{
        
        guard let first = array.first else{return ""}
        
        var p : String = ""
        
       
        
        if let dict = first as? [String: Any]{
            if let n = name{
                p = "   let \(n) : [\(n.capitalized)]" + (type == .`default` ? " = []" : "?")
            }
            conversionDictionarySubProperty(dict: dict,name?.capitalized)
        }else{
            if let n = name{
                p = "   let \(n) : [Any]" + (type == .`default` ? " = []" : "?")
            }
        }
        
//        if let list = first as? [Any] {
//
//        }
      
        
        return p
        
    }
    
    
    
    
    
    func conversionstring(_ string: String,_ name: String) -> String{
        return "    let \(name) : String" + (type == .`default` ? " = \"\"" : "?")
    }
    
    func conversionInt(_ int : Int,_ name: String) -> String{
        return "    let \(name) : Int" + (type == .`default` ? " = 0" : "?")
    }
    
    func conversionFloat(_ float: Float,_ name: String) -> String{
        return "    let \(name) : Float" + (type == .`default` ? " = 0.0" : "?")
    }
    
    func conversionDouble(_ double : Double,_ name: String) -> String{
        return "    let \(name) : Double" + (type == .`default` ? " = 0.0" : "?")
    }
    func conversionBool(_ bool : Bool,_ name: String) -> String{
        return "    let \(name) : Bool" + (type == .`default` ? " = false" : "?")
    }
}

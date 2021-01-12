//
//  ObjcConversion.swift
//  JSONMapping
//
//  Created by BraveShine on 2020/12/29.
//

import Foundation

class ObjcConversion {
    
    
    var objects: [String] = []
    
    func conversion(_ string: String) -> String{
        guard let jsonData = string.data(using: .utf8) else{ return "" }
        
        if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers){
            
            var s = conversionAny(json)
            
            s +=    objects.joined(separator: "\n\n")
            
            return s
            
        }
        return NSLocalizedString("The json text cannot be parsed", comment: "")
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
            p = "@property (nonatomic,copy) \(n.capitalized) * \(n);"
        }
        self.conversionDictionarySubProperty(dict: dict,name)
        
        return p
    }
    
    func conversionDictionarySubProperty(dict: [String : Any],_ name: String? = nil)  {
        var result : String = "@interface \(name?.capitalized ?? "Object") : NSObject \n"
        dict.keys.forEach { (str) in
            if let value = dict[str]{
                result += "\n"
                result += conversionAny(value,str)
                result += "\n"
            }
        }
        
        result += "\n@end\n"
        
        objects.append(result)
        
    }
    
    func combine(_ list: [[String : Any]]) -> [String : Any]{
        var r : [String : Any] = [:]
        list.forEach { (item) in
            item.forEach { (k,v) in
                r[k] = v
            }
        }
        return r
    }
    
    
    func conversionArray(_ array: [Any],_ name: String? = nil) -> String{
        
//        guard let first = array.first else{return ""}
//
//        var p : String = ""
//
//        if let n = name{
//            p = "@property (nonatomic,copy) NSArray * \(n.capitalized);"
//        }
//
//        if let dict = first as? [String: Any]{
//            conversionDictionarySubProperty(dict: dict,name?.capitalized)
//        }
        
        guard let _ = array.first else{return ""}
        
        var p : String = ""
        
       
        
        if let list = array as? [[String : Any]] {
            let dict = combine(list)
            if let n = name{
                p = "@property (nonatomic,copy) NSArray * \(n.capitalized);"
                conversionDictionarySubProperty(dict: dict,n.capitalized)
            }
        }else{
            if let n = name{
                p = "@property (nonatomic,copy) NSArray * \(n.capitalized);"
            }
        }
        
        
        
//        if let list = first as? [Any] {
//
//        }
      
        
        return p
        
    }
    
    func conversionstring(_ string: String,_ name: String) -> String{
        return "@property (nonatomic,copy) NSString * \(name);"
    }
    
    func conversionInt(_ int : Int,_ name: String) -> String{
        return "@property (nonatomic,assign) NSInteger \(name);"
    }
    
    func conversionFloat(_ float: Float,_ name: String) -> String{
        return "@property (nonatomic,assign) float \(name);"
    }
    
    func conversionDouble(_ double : Double,_ name: String) -> String{
        return "@property (nonatomic,assign) double \(name);"
    }
    func conversionBool(_ bool : Bool,_ name: String) -> String{
        return "@property (nonatomic,assign) BOOL \(name);"
    }
}
/**
 
 
 
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
 
 
 {
     "name": "a",
     "age": 10,
     "children": [
         {
             "name": "c1",
             "age": 1,
             "sss": {
                 "a": 10,
                 "b": false,
                 "c": 3.5
             },
 "xx": [1,2,3,4]
         },
         {
             "name": "c1",
             "age": 1
         }
     ]
 }
 
 
 */

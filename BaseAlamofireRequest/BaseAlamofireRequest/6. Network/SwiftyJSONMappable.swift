//
//  SwiftyJSONMappable.swift
//  FunRing
//
//  Created by Dang Duy Cuong on 10/20/20.
//  Copyright © 2020 Son Nguyen. All rights reserved.
//

import SwiftyJSON

protocol SwiftyJSONMappable {
    init?(byJSON json: JSON)
    //    init?(byString string: String, key: String)
}

extension Array where Element: SwiftyJSONMappable {
    
    init(byJSON json: JSON) {
        self.init()
        if json.type == .null { return }
        
        for item in json.arrayValue {
            if let object = Element.init(byJSON: item) {
                self.append(object)
            }
        }
    }
    
    init(byString string: String, key: String = "") {
        self.init()
        var json = string.toJSON()
        if !key.isEmpty { json = json[key] }
        if json.type == .null { return }
        
        for item in json.arrayValue {
            if let object = Element.init(byJSON: item) {
                self.append(object)
            }
        }
    }
}

extension String {
    
    func toJSON() -> JSON {
        return self.data(using: String.Encoding.utf8).flatMap({JSON(data: $0)}) ?? JSON(NSNull())
    }
    
//    func toJSON() -> JSON {
//        let json = self.data(using: String.Encoding.utf8).flatMap({try? JSON(data: $0)}) ?? JSON(NSNull())
//        return json
//    }
}


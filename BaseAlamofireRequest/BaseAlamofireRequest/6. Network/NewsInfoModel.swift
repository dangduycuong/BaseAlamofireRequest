//
//  NewsInfoModel.swift
//  FunRing
//
//  Created by Dang Duy Cuong on 10/20/20.
//  Copyright © 2020 Son Nguyen. All rights reserved.
//

import SwiftyJSON

enum NewsInfoImportantType: NSInteger {
    case Normal = 1
    case Important
}

enum NewsInfoState: NSInteger {
    case UnRead = 1
    case Read
}

class NewsInfoModel: BaseDataModel {
    
    var importantLevel: NewsInfoImportantType?
    var title: String?
    var createDateStr: String?
    var createDate: String?
    var updateTime: String?
    var content: String?
    var userCreate: String?
    var fullname: String?
    var isRead: NewsInfoState?
    var id: String?
    
    override func mapping(json: JSON) {
        super.mapping(json: json)
        if json["title"].exists() {
            title = json["title"].stringValue
        }
        if json["content"].exists() {
            content = json["content"].stringValue
        }
        
        if json["userCreate"].exists() {
            userCreate = json["userCreate"].stringValue
        }
        
        if json["createDateStr"].exists() {
            createDateStr = json["createDateStr"].stringValue
        }
        
        if json["createDate"].exists() {
            createDate = json["createDate"].stringValue
        }
        
        if json["updateTime"].exists() {
            updateTime = json["updateTime"].stringValue
        }
        
        if json["fullname"].exists() {
            fullname = json["fullname"].stringValue
        }
        
        if json["importantLevel"].exists() {
            importantLevel = NewsInfoImportantType(rawValue: json["importantLevel"].intValue)
        }
        
        if json["isRead"].exists() {
            isRead = NewsInfoState(rawValue: json["isRead"].intValue)
        }
        
        if json["id"].exists() {
            objectId  =  json["id"].stringValue
            id = json["id"].stringValue
        }
    }
}


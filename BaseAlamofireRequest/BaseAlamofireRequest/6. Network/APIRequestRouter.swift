//
//  APIRequestRouter.swift
//  FunRing
//
//  Created by Dang Duy Cuong on 10/20/20.
//  Copyright © 2020 Son Nguyen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


enum APIRequestRouterEndpoint {
    case login(params: Dictionary<String, Any>)
}

class APIRequestRouter: BaseRouter {
    static var ItemPerPage = 10
    var endpoint: APIRequestRouterEndpoint

    init(endpoint: APIRequestRouterEndpoint) {
        self.endpoint = endpoint
    }

    //MARK: Path
    override var path: String {
        switch endpoint {
        case .login(_):
            return "RbtServices/val"
        }
    }

    override var method: HTTPMethod {
        switch endpoint {
        case .login(_):
            return .get
        }
    }

    override var parameters: [String: Any]? {
        var params: [String: Any]?
        switch endpoint {
        case .login(let addParams):
            params = addParams
            break
        }

        return params
    }

    override var multipartBody: [MultipartFormData]? {
        return nil
    }

    override var parameterEncoding: ParameterEncoding {
        switch endpoint {
        case .login(_):
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }

    override var headerFields: [String: String]? {
        return nil
//        guard let currentUser = LocalUser.shared.currentUser else {
//            return nil
//        }
//
//        let token = currentUser.token ?? "token"
//        let username = currentUser.username ?? "username"
//        var headers = [String: String]()
//        headers["token"] = token
//        headers["username"] = username
//
//        //Update
//        let timeNow = Int64(Date().timeIntervalSince1970 * 1000)
//        //            "_"+ Common.imeiId + "_" + time
//        let requestClientId = String(timeNow)
//        var userNameString = UserRouter.userName
//        if (userNameString == nil){
//            userNameString = ""
//        }
//        let stringRequestClientId = userNameString! + "_null_" + requestClientId
//        var loc: String = "vi"
//        if (UserDefaults.standard.integer(forKey: "languageInt") == 1){
//            loc = "es"
//        } else if (UserDefaults.standard.integer(forKey: "languageInt") == 2){
//            loc = "en"
//        } else if (UserDefaults.standard.integer(forKey: "languageInt") == 4){
//            loc = "my"
//        } else if (UserDefaults.standard.integer(forKey: "languageInt") == 5){
//            loc = "lo"
//        } else if (UserDefaults.standard.integer(forKey: "languageInt") == 6) {
//            loc = "po"
//        } else {
//            loc = "vi"
//        }
//        headers["locale"] = loc
//        headers["requestClientId"] = stringRequestClientId as String
//        headers["Authen"] = "VSMART"
//        return headers
    }

    override var uploadFiles : [UploadFile]? {
        return nil
    }

    override func response(json: JSON) -> Any? {
        switch endpoint {
        default:
            return json
        }
    }

    override func otherResponse(json: JSON) -> Any? {
        return nil
    }

    override func errorResponse(json: JSON) -> Any? {
        return BaseDataModel(byJSON: json)
    }
}




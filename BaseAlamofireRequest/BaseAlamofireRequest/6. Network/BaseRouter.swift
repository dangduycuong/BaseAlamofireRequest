//
//  BaseRouter.swift
//  FunRing
//
//  Created by Dang Duy Cuong on 10/20/20.
//  Copyright © 2020 Son Nguyen. All rights reserved.
//


import Alamofire
import SwiftyJSON
//import KVLoading

enum Server_NEO: NSInteger {
    case Server_Real
    case Server_Test
}

enum APIResult {
    case success(Any?, Any?)
    case failure(Any?)
    case timedOut
    case networkError
}

struct UploadFile {
    var data: Data!
    var name:String!
    var fileName:String!
    var mineType:String!
}

var isTest = true

class BaseRouter {
    static let URL_DOMAIN: String = "http://171.255.192.160:8199/QLCTKT"
    static var SERVER: Server_NEO = Server_NEO.Server_Real
    static var enableAutomaticShowErrorOnVC = true
    public var showMessage : Bool = true
    public var typePending : Int = 0
    var isNoLimitImage = false
    
    var fullURL: URLConvertible {
        switch(BaseRouter.SERVER)
        {
        case .Server_Real:
            return URL.init(string:"\(baseURLString)\(contextPathString)\(path)")!
        //                URL.init(string:"\(baseURLString):\(basePORTString)\(contextPathString)\(path)")!URL.init(string:"\(baseURLString):\(basePORTString)\(contextPathString)\(path)")!
        case .Server_Test:
            //            return URL.init(string:"\(baseURLString):\(contextPathString)\(path)")!
            return URL.init(string:"\(baseURLString):\(basePORTString)\(contextPathString)\(path)")!
        }
    }
    
    var serverURL: URLConvertible {
        switch(BaseRouter.SERVER) {
        case .Server_Real:
            return URL.init(string:"\(baseURLString)\(contextPathString)")!
        case .Server_Test:
            return URL.init(string:"\(baseURLString):\(basePORTString)\(contextPathString)")!
            //            return URL.init(string:"\(baseURLString):\(basePORTString)\(contextPathString)\(path)")!
        }
    }
    
    var baseURLString: String {
        switch(BaseRouter.SERVER) {
        case .Server_Real:
            return "http://funring.vn"
        case .Server_Test:
            return "http://funring.vn"
        }
    }
    
    var contextPathString: String {
        switch(BaseRouter.SERVER) {
        case .Server_Real:
            return "/a/services/"
        case .Server_Test:
            return "/a/services/"
        }
    }
    
    var basePORTString: UInt16 {
        switch(BaseRouter.SERVER) {
        case .Server_Real:
            return 9154
        case .Server_Test:
            return 9998
        }
    }
    
    var page: Int = 0
    var skip: Int = 0
    var limit: Int = 10
    
    // MARK: - Public methods
    func request(completed: ((APIResult) -> Void)?) {
        var response: APIResult = .networkError {
            didSet {
                completed?(response)
            }
        }
        
        if (WIFI.isInternetAvailable() == false) {
            response = .networkError
            self.showNotConnect()
            completed?(response)
            return
        }
        
        var isTimedOut: Bool = true
        DispatchQueue.main.asyncAfter(deadline: .now() + BaseRouter.timeOut) {
            if isTimedOut {
                response = .timedOut
                if(BaseRouter.enableAutomaticShowErrorOnVC && !BroadCastNewInfoModel.sharedInstance.isAddErrorMessage)
                {
                    BroadCastNewInfoModel.sharedInstance.isAddErrorMessage = false
                }
            }
        }
        
        print("Request: \(fullURL)")
        print("Params: \(String(describing: parameters))")
        print("Headers: \(String(describing: headerFields))")
        
        if let _ = uploadFiles {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            sessionManager.upload(multipartFormData: { (form) in
                
                // Add images with multipartBody
                if var dataImages = self.uploadFiles {
                    if !self.isNoLimitImage {
                        if dataImages.count < 5 {
                            let count = dataImages.count
                            for i in 1...(5 - count) {
                                let newIndex : Int = count + i
                                var file = UploadFile()
                                file.data = Data()
                                if (self.typePending == 1){
                                    file.name = "image" + newIndex.toString() + "bb"
                                }else {
                                    file.name = "image" + newIndex.toString()
                                }
                                file.fileName = file.name + ".jpeg"
                                file.mineType = "image/jpeg"
                                dataImages.append(file)
                            }
                        }
                    }
                    print("mutilpart data: \(dataImages)")
                    dataImages.forEach({ (file) in
                        if file.data != nil {
                            form.append(file.data, withName: file.name, fileName: file.fileName, mimeType: file.mineType)
                        }
                    })
                }
                
                if let parameters = self.parameters {
                    for (key, value) in parameters {
                        if let valueString = value as? String {
                            form.append(valueString.data(using: .utf8)!, withName: key)
                        }
                        if let valueData = value as? Data{
                            form.append(valueData, withName: key)
                        }
                    }
                }
            },usingThreshold:UInt64.init() , to: fullURL, method: method, headers: headerFields, encodingCompletion: { (result) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch result {
                case .success(let request, _, _):
                    request.responseJSON(completionHandler: { (responseObject) in
                        if let resultResponse = responseObject.response {
                            
                            if let data = responseObject.data {
                                guard let json = try? JSON(data: data) else {
                                    return
                                }
                                print("Status code: \(resultResponse.statusCode)")
                                print("Response json: ", json)
                                
                                switch resultResponse.statusCode {
                                case 200, 201, 202, 203, 204:
                                    if let entity = self.response(json: json) {
                                        if let otherEntity = self.otherResponse(json: json) {
                                            response = .success(entity, otherEntity)
                                        } else {
                                            response = .success(entity, nil)
                                        }
                                    } else {
                                        response = .failure(responseObject.result.error)
                                    }
                                    
                                default:
                                    response = .failure(responseObject.result.error)
                                }
                                
                                
                            } else {
                                response = .failure(responseObject.result.error)
                            }
                        } else {
                            response = .networkError
                            self.showNotConnect()
                        }
                    })
                    
                case.failure(_):
                    response = .networkError
                    self.showNotConnect()
                }
            })
            
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            sessionManager.request(fullURL, method: method, parameters: parameters, encoding: parameterEncoding, headers: headerFields).response { (result) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                isTimedOut = false
                
                if let resultResponse = result.response {
                    if let data = result.data {
                        guard let json = try? JSON(data: data) else {
                            return
                        }
                        print("Status code: \(resultResponse.statusCode)")
                        print("Response json: \(json)")
                        
                        switch resultResponse.statusCode {
                        case 200, 201, 202, 203, 204:
                            if let entity = self.response(json: json) {
                                if let otherEntity = self.otherResponse(json: json) {
                                    response = .success(entity, otherEntity)
                                } else {
                                    response = .success(entity, nil)
                                }
                            } else {
                                
                                if json != JSON.null {
                                    response = .success(json, nil)
                                } else {
                                    response = .failure(result.error)
                                }
                            }
                            
                        default:
                            response = .failure(result.error)
                        }
                    } else {
                        response = .failure(result.error)
                    }
                } else {
                    response = .networkError
                    self.showNotConnect()
                }
            }
        }
    }
    
    private let sessionManager: SessionManager = {
        var serverTrustPolicies: [String: ServerTrustPolicy]!
        switch(BaseRouter.SERVER)
        {
        case .Server_Real:
            serverTrustPolicies = [
                "http://10.60.7.189": .disableEvaluation,
                "10.60.7.189": .disableEvaluation
            ]
            break
        case .Server_Test:
            break
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = timeOut
        configuration.timeoutIntervalForResource = timeOut
        //        return SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        return SessionManager()
    }()
    
    let sessionLongTaskManager: SessionManager = {
        var serverTrustPolicies: [String: ServerTrustPolicy]!
        switch(BaseRouter.SERVER)
        {
        case .Server_Real:
            serverTrustPolicies = [
                "http://10.60.7.189": .disableEvaluation,
                "10.60.7.189": .disableEvaluation
            ]
            break
        case .Server_Test:
            break
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10 * timeOut
        configuration.timeoutIntervalForResource = 10 * timeOut
        //        return SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        return SessionManager()
    }()
    
    static var timeOut: TimeInterval {
        get {
            switch(BaseRouter.SERVER)
            {
            default:
                return 120
            }
        }
    }
    
    var path: String {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    var method: HTTPMethod {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    var parameters: [String: Any]? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    var multipartBody: [MultipartFormData]? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    var parameterEncoding: ParameterEncoding {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    var headerFields: [String: String]? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    var uploadFiles: [UploadFile]? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    func response(json: JSON) -> Any? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    func otherResponse(json: JSON) -> Any? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    func errorResponse(json: JSON) -> Any? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
}

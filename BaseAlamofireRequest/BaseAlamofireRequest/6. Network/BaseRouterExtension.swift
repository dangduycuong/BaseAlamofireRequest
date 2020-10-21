//
//  BaseRouterExtension.swift
//  FunRing
//
//  Created by Dang Duy Cuong on 10/20/20.
//  Copyright © 2020 Son Nguyen. All rights reserved.
//

import Alamofire
import SwiftyJSON
//import KVLoading
import UIKit

extension BaseRouter {
    func showNotConnect() {
        DispatchQueue.main.async {
            if(BaseRouter.enableAutomaticShowErrorOnVC && !BroadCastNewInfoModel.sharedInstance.isAddErrorMessage) {
                if let vc = self.getTopVC() {
                    BroadCastNewInfoModel.sharedInstance.isAddErrorMessage = true
                    vc.showAlertControllerFromExtension(title: "Thông báo", message: "Không có kết nối", okAction: {
                        BroadCastNewInfoModel.sharedInstance.isAddErrorMessage = false
                    })
                    //                    vc.showAlertControllerFromExtension(title: VTLocalizedString.localized(key: "notification"), message: VTLocalizedString.localized(key: "Không có kết nối"), okAction:{
                    //                        BroadCastNewInfoModel.sharedInstance.isAddErrorMessage = false
                    //                    })
                }
            }
        }
    }
}

extension BaseRouter {
    func getTopVC() -> UIViewController? {
        //        if var keyWindow = UIApplication.shared.connectedScenes
        //        .filter({$0.activationState == .foregroundActive})
        //        .map({$0 as? UIWindowScene})
        //        .compactMap({$0})
        //        .first?.windows
        //            .filter({$0.isKeyWindow}).first {
        //            keyWindow.endEditing(true)
        //        }
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
//    func defaultHeader() -> [String: String]?{
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
//        }else if (UserDefaults.standard.integer(forKey: "languageInt") == 2){
//            loc = "en"
//        }else if (UserDefaults.standard.integer(forKey: "languageInt") == 4){
//            loc = "my"
//        }else if (UserDefaults.standard.integer(forKey: "languageInt") == 5){
//            loc = "lo"
//        }else if (UserDefaults.standard.integer(forKey: "languageInt") == 6) {
//            loc = "po"
//        } else {
//            loc = "vi"
//        }
//        headers["locale"] = loc
//        headers["requestClientId"] = stringRequestClientId as String
//        headers["Authen"] = "VSMART"
//        return headers
//    }
}

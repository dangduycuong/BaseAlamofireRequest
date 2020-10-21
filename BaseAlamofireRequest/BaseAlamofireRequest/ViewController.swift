//
//  ViewController.swift
//  BaseAlamofireRequest
//
//  Created by Dang Duy Cuong on 10/21/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    func login() {
        var p = "84099990888"
        if p.first == "0" {
            p.remove(at: p.startIndex)
        } else {
            if p.hasPrefix("84") {
                p.remove(at: p.startIndex)
                p.remove(at: p.startIndex)
            }
        }
        print(p)
        var params = Dictionary<String, Any>()
        params["P1"] = "3"
        params["P2"] = "904862074"
        params["P3"] = "880577"
        params["response"] = "application/json"
        
        params["ParamSize"] = "3"
        params["Service"] = "LOGIN"
        APIRequestRouter.init(endpoint: .login(params: params)).request { response in
            switch response {
            case .success(let response, _):
                if let data = response as? JSON {
                    if let returnCode = data["return"].string {
                        print(returnCode)
                    }
                }
            default:
                break
            }
        }
    }
    
    
    
    @IBAction func taoLogin(_ sender: Any) {
        login()
    }
    
}


//
//  UIViewController.swift
//  FunRing
//
//  Created by Dang Duy Cuong on 10/20/20.
//  Copyright © 2020 Son Nguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertControllerFromExtension(title: String, message: String, okTitle: String = "OK", okAction: (() -> Void)?) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: okTitle.uppercased(), style: .cancel) { (okButton) in
            okAction?()
        })
        self.present(alertController, animated: true, completion: nil)
    }
//    func showAlertControllerFromExtension(title: String, message: String, okTitle: String = VTLocalizedString.localized(key: "OK").uppercased(), okAction: (() -> Void)?) {
//        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        alertController.addAction(UIAlertAction(title: okTitle.uppercased(), style: .cancel) { (okButton) in
//            okAction?()
//        })
//        self.present(alertController, animated: true, completion: nil)
//    }
}

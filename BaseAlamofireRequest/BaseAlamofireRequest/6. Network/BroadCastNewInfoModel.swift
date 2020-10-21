//
//  BroadCastNewInfoModel.swift
//  FunRing
//
//  Created by Dang Duy Cuong on 10/20/20.
//  Copyright © 2020 Son Nguyen. All rights reserved.
//

import SwiftyJSON
import MarqueeLabel

class BroadCastNewInfoModel: BaseDataModel {
    var isAddErrorMessage = false;
    var height: CGFloat = 40
    var isAdded = false
    var lstNewsInfo = [NewsInfoModel]()
    let broadCastLabel = MarqueeLabel()
    var bottomLayer = CALayer()
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    static let sharedInstance : BroadCastNewInfoModel = {
        let instance = BroadCastNewInfoModel()
        return instance
    }()
    
    init(array : [NewsInfoModel]) {
        super.init()
        lstNewsInfo = array
    }
    
    convenience override init() {
        self.init(array : [])
    }
    
    required init?(byString string: String, key: String) {
        fatalError("init(byString:key:) has not been implemented")
    }
    
    required init?(byJSON json: JSON) {
        fatalError("init(byJSON:) has not been implemented")
    }
    
    func convertToDisplayString(completion: @escaping ((NSMutableAttributedString) -> ())){
        
        DispatchQueue.global(qos: .background).async {
            let content = NSMutableAttributedString()
            let normalAttribute: [NSAttributedString.Key:AnyObject] =
                [NSAttributedString.Key.font : Constant.font.robotoRegular(ofSize: 15) ,
                 NSAttributedString.Key.foregroundColor : UIColor.blue]
            let importantAttribute: [NSAttributedString.Key:AnyObject] =
                [NSAttributedString.Key.font : Constant.font.robotoRegular(ofSize: 15) ,
                 NSAttributedString.Key.foregroundColor : UIColor.red]
            for model in BroadCastNewInfoModel.sharedInstance.lstNewsInfo {
                let contentToShow = "[\(String(describing: (model.title?.htmlString.stringByRemovingWhitespaceAndNewlineCharacterSet ?? "")))]" + " " + "\(String(describing: (model.content?.htmlString.stringByRemovingWhitespaceAndNewlineCharacterSet ?? "")))" + "     "
                var tmpAttributeString = NSAttributedString()
                if model.importantLevel == .Normal {
                    tmpAttributeString = NSAttributedString(string: contentToShow, attributes: normalAttribute)
                } else {
                    tmpAttributeString = NSAttributedString(string: contentToShow, attributes: importantAttribute)
                }
                content.append(tmpAttributeString)
            }
            completion(content)
        }
    }
}


//
//  String.swift
//  FunRing
//
//  Created by Dang Duy Cuong on 10/20/20.
//  Copyright © 2020 Son Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func toDictionary() -> [String: AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func toInt() -> Int {
        if let value = Int(self) {
            return value
        }
        return 0
    }
    
    func toFloat() -> Float {
        if let value = Float(self) {
            return value
        }
        return 0
    }
    
    func toDouble() -> Double {
        if let value = Double(self) {
            return value
        }
        return 0.0
    }
    
    func toBool() -> Bool {
        switch self.lowercased() {
        case "success", "true", "yes", "1":
            return true
        default:
            return false
        }
    }
    
    func toDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(atof(self)/1000))
    }
    
    func toDateWithFormat(_ format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func fromBase64String() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64String() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func isValidEmail() -> Bool {
        let characters = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let email = NSPredicate(format:"SELF MATCHES %@", characters)
        return email.evaluate(with: self)
    }
    
    func isValidIPAddress() -> Bool {
        let parts = self.components(separatedBy: ".")
        let nums = parts.compactMap { Int($0) }
        return parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256}.count == 4
    }
    
    //MARK: - trim Trailing and leading whitespace
    func stringByTrimmingLeadingAndTrailingWhitespace() -> String {
        let leadingAndTrailingWhitespacePattern = "(?:^\\s+)|(?:\\s+$)"
        return self.replacingOccurrences(of: leadingAndTrailingWhitespacePattern, with: "", options: .regularExpression)
    }
    
    func language() -> String{
        return VTLocalizedString.localized(key: self)
    }
    
    func toGroupSeparatorFormat(separator: String) -> String {
        if let intValue = Int(self){
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.groupingSeparator = separator
            return numberFormatter.string(from: NSNumber(value: intValue)) ?? self
        }
        return self
    }
}

//Random string
extension String {
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
extension String {
    var htmlAttributedString: NSAttributedString? {
            do {
                let data = try NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
                return data
            } catch {
                print("error:", error)
                return nil
            }
    }
    var htmlString: String {
        return htmlAttributedString?.string ?? ""
    }
    var stringByRemovingWhitespaceAndNewlineCharacterSet: String {
        return components(separatedBy: .whitespacesAndNewlines).joined(separator: "")
    }
    var stringByRemovingWhitespace: String {
        return components(separatedBy: " ").joined(separator: "")
    }
    
    func toCurrentTimeZoneDateWithFormat(_ format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: self)
    }
}
extension String {
    func localizedString() -> String {
        return ""
    }
    
    func isValidString() -> Bool
    {
        if(components(separatedBy: .whitespacesAndNewlines).joined() == "")
        {
            return false
        }
        return true
    }
}

extension String
{
    func length() -> Int
    {
        let newString : String? = self
        if newString != nil {
            return newString!.count
        }
        return 0
    }
}

extension String
{
    func sTrimString() -> String
    {
        var string = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.first == " " {
          string = string.sTrimString()
        }
        
        return string
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    // check validate email
    func isEmail()->Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
}

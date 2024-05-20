//
//  String.swift
//  UITableViewTest
//
//  Created by 온석태 on 5/17/24.
//

import Foundation
import UIKit

extension String {
    func toUIColor(withAlpha alpha: CGFloat = 1.0) -> UIColor? {
           var hexString = self.trimmingCharacters(in: .whitespacesAndNewlines)
           hexString = hexString.replacingOccurrences(of: "#", with: "")

           var rgbValue: UInt64 = 0
           Scanner(string: hexString).scanHexInt64(&rgbValue)

           let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
           let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
           let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

           return UIColor(red: red, green: green, blue: blue, alpha: alpha)
       }
    
    
    /// 문자열 길이(width) 구하기
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    /// 문자열 높이(height) 구하기
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}

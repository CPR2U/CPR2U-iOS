//
//  UIColor+.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/02.
//

import UIKit

extension UIColor {
    convenience init(rgb: Int) {
           self.init(
            red: CGFloat((rgb >> 16) & 0xFF),
            green: CGFloat((rgb >> 8) & 0xFF),
            blue: CGFloat(rgb & 0xFF), alpha: 1
           )
    }
    
    static let white = UIColor(rgb: 0xFFF6F6)
    
    static let black = UIColor(rgb: 0x19191B)
    static let darkGray = UIColor(rgb: 0x595959)
    static let lightGray = UIColor(rgb: 0xD9D9D9)
    
    static let mainDarkRed = UIColor(rgb: 0xB50000)
    static let mainRed = UIColor(rgb: 0xF74346)
    static let mainLightRed = UIColor(rgb: 0xFBA1A2)
    
    static let subOrange = UIColor(rgb: 0xFC7037)
    static let subPink = UIColor(rgb: 0xFF0050)
}

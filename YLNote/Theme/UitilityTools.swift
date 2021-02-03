//
//  Uitility.swift
//  YLNote
//
//  Created by tangh on 2021/1/29.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(),
                       green: .random(),
                       blue: .random(),
                       alpha: 1.0)
    }
}

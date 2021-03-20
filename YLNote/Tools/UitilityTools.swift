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


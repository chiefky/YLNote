//
//  CAlayer+Tools.swift
//  YLNote
//
//  Created by tangh on 2021/1/22.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

extension CAShapeLayer{
    static func cleanLayer() -> CAShapeLayer{
        let layer = self.init()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.clear.cgColor
        return layer
    }
}

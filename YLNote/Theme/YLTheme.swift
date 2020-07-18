//
//  YLTheme.swift
//  TestDemo
//
//  Created by tangh on 2020/7/19.
//  Copyright © 2020 tangh. All rights reserved.
//

import Foundation
import UIKit

let str:String = "hrllo"

@objc class A: NSObject {
    
}

@objc class YLTheme: NSObject {
    @objc let shared = YLTheme()
    
    let themeColor:UIColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)

}

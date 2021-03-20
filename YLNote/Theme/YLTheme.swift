//
//  YLTheme.swift
//  TestDemo
//
//  Created by tangh on 2020/7/19.
//  Copyright © 2020 tangh. All rights reserved.
//

import Foundation
import UIKit

let YLScreenSize = UIScreen.main.bounds.size

class YLTheme: NSObject {
    
    private static let defaultInstance: YLTheme = {
        let instance = YLTheme()
        // 可以做一些其他的配置
        // ...
        return instance
    }()
    
    @objc var themeColor: UIColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1) {
        didSet {
            NotificationCenter.default.post(name: .skinChanged, object: nil)
        }
    }
    @objc let subColor:UIColor = #colorLiteral(red: 0.5382906199, green: 0.2054870129, blue: 0.1187047735, alpha: 0.6)


    @objc let tabTintColor:UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    @objc let naviTintColor:UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    @objc let backColor:UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)


    @objc let textColor = #colorLiteral(red: 0.07648678869, green: 0.07650760561, blue: 0.07648406178, alpha: 1)
    @objc let subTextColor = #colorLiteral(red: 0.2944204807, green: 0.3198619187, blue: 0.3539443612, alpha: 1)
    
    @objc let mainFont = UIFont.boldSystemFont(ofSize: 18)
    @objc let titleFont = UIFont.systemFont(ofSize: 16)
    @objc let textFont = UIFont.systemFont(ofSize: 14)

    @objc class func main() -> YLTheme {
        return defaultInstance
    }
}

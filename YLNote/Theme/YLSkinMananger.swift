//
//  YLSkinMananger.swift
//  YLNote
//
//  Created by tangh on 2021/2/25.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLSkinMananger: NSObject {
    private static let defaultInstance: YLSkinMananger = {
        let instance = YLSkinMananger()
        // 可以做一些其他的配置
        // ...
        return instance
    }()
    @objc class func defaultManager() -> YLSkinMananger {
        return defaultInstance
    }
    
    @objc var skinMap: NSDictionary = [:] {
        didSet {
            print("skinmap changed")
            NotificationCenter.default.post(name: .skinChanged, object: nil)
        }
    }
    
    @objc func test() {
        
    }
    
    var tintColor: UIColor {
        let name = skinMap["tintColor"] as? String
        return UIColor(hex: name ?? "ffffff")
    }
    var bgColor: UIColor {
        let name = skinMap["bgColor"] as? String
        return UIColor(hex: name ?? "ffffff")
    }
    var titleColor: UIColor {
        let name = skinMap["titleColor"] as? String
        return UIColor(hex: name ?? "ffffff")
    }
    var subTitleColor: UIColor {
        let name = skinMap["subTitleColor"] as? String
        return UIColor(hex: name ?? "ffffff")
    }
    var normalColor: UIColor {
        let name = skinMap["normalColor"] as? String
        return UIColor(hex: name ?? "ffffff")
    }
    var selectColor: UIColor {
        let name = skinMap["selectColor"] as? String
        return UIColor(hex: name ?? "ffffff")
    }
    var highlightColor: UIColor {
        let name = skinMap["highlightColor"] as? String
        return UIColor(hex: name ?? "ffffff")
    }
    var disabledColor: UIColor {
        let name = skinMap["disabledColor"] as? String
        return UIColor(hex: name ?? "ffffff")
    }
    
    var normalImage: UIImage? {
        let name = skinMap["normalImage"] as? String
        return UIImage(named: name ?? "placeholder")
    }
    var selectImage: UIImage? {
        let name = skinMap["selectImage"] as? String
        return UIImage(named: name ?? "placeholder")
    }
    var highlightImage: UIImage? {
        let name = skinMap["highlightImage"] as? String
        return UIImage(named: name ?? "placeholder")
    }

    var disabledImage: UIImage? {
        let name = skinMap["disabledImage"] as? String
        return UIImage(named: name ?? "placeholder")
    }

    @objc func checkAndUpdateSkinSetting(completeBlock: ((NSDictionary) -> (Void))?) -> Void {
        let cachePath = YLFileManager.sandboxDoucumentPath().appending("Skin.plist")
        var dict = NSDictionary()
        if !FileManager.default.fileExists(atPath: cachePath) {
            //            let path = Bundle.main.path(forResource: "Skin", ofType: "plist")
            let doucmentPath = YLFileManager.sandboxDoucumentPath()
            let filePath = doucmentPath.appending("Skin.plist")
            dict = ["tintColor":"FF00F0",
                    "bgColor":"DC143C",
                    
                    "titleColor":"DC143C",
                    "subTitleColor":"DC143C",
                    
                    "normalColor":"DC143C",
                    "selectColor":"DC143C",
                    "highlightColor":"DC143C",
                    "disabledColor":"DC143C",
                    
                    "normalImage":"DC143C",
                    "selectImage":"DC143C",
                    "highlightImage":"DC143C",
                    "disabledImage":"DC143C",

            ]
            dict.write(toFile: filePath, atomically: true)
        } else {
            dict = YLFileManager.dictionary(withLocalFilePath: cachePath) as NSDictionary
        }
        self.skinMap = dict;
        guard let comp = completeBlock else { return }
        comp(dict)
    }
    
}

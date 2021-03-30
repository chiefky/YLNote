//
//  UITabbarItem+Theme.swift
//  YLNote
//
//  Created by tangh on 2021/2/17.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation

///  * 设置图片
let kTabBarItemKeyImageName = "kTabBarItemKeyImageName"
///  * 设置选中图片
let kTabBarItemKeySelectedImageName = "kTabBarItemKeySelectedImageName"
///  * 设置文字颜色
let kTabBarItemKeyColorName = "kTabBarItemKeyColorName"
///  * 设置选中文字颜色
let kTabBarItemKeySelectedColorName = "kTabBarItemKeySelectedColorName"

//struct UITabBarItemAssociateKey {
//    static let deallocObj = "UITabBarItemAssociateKey.deallocObj"
//
//}

struct UITabBarItemAssociateKeys {
    static var skinMap: String = "UITabBarItem.skinMap" // 皮肤属性映射map标识
    static var deallocExecutor : String = "UITabBarItem.deallocExecutor" // 销毁者对象标识
    static var executorArray: String = "UITabBarItem.executorArray" // 销毁者数组标识
}


extension UITabBarItem {
    
    @objc func addSkinObserver() {
        if (objc_getAssociatedObject(self, &UITabBarItemAssociateKeys.deallocExecutor) == nil) {
            
            let executor = self.addDeallocExecutor(tag: UITabBarItemAssociateKeys.deallocExecutor) { [unowned self] () -> () in
                // __unsafe_unretained typeof(self) weakSelf = self; // NOTE: need to be __unsafe_unretained because __weak var will be reset to nil in dealloc

                NotificationCenter.default.removeObserver(self)
            }
            objc_setAssociatedObject(self, &UITabBarItemAssociateKeys.deallocExecutor, executor, .OBJC_ASSOCIATION_ASSIGN);
        }
        
        NotificationCenter.default.removeObserver(self, name: .skinChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(skinMapChanged), name: .skinChanged, object: nil)
    }
    
    @objc func removeSkinObserver() {
        NotificationCenter.default.removeObserver(self, name: .skinChanged, object: nil)
    }
    
    
    @objc var skinMap: NSDictionary? {
        set(newValue) {
            objc_setAssociatedObject(self, &UITabBarItemAssociateKeys.skinMap, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)

            let oldValue = objc_getAssociatedObject(self, &UITabBarItemAssociateKeys.skinMap)
            if newValue != nil {
                if let oldValue = oldValue as? NSDictionary,oldValue.isEqual(to: newValue as! [AnyHashable : AnyObject]) {
                    print("no changed, do nothing")
                } else {
                    removeSkinObserver()
                    addSkinObserver()
                    skinMapChanged()
                }
            } else {
                removeSkinObserver()
            }
        }
        get {
            return  objc_getAssociatedObject(self, &UITabBarItemAssociateKeys.skinMap) as? NSDictionary
        }
    }
    
    @objc func skinMapChanged() {
        print("\(#function)")
        DispatchQueue.main.async {
            self.updateSkin()
        }
    }
    
    func updateSkin() {
        guard let map = self.skinMap else { return }
        
        if let name = map[kTabBarItemKeyImageName] as? String {
            self.image = UIImage.getSkinImageFromSkinPlist(str: name)
            print(name)
        }
        if let name = map[kTabBarItemKeySelectedColorName] as? String {
            self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: name)], for: .selected)
            print("修改选中颜色\(name)")
        }
        if let name = map[kTabBarItemKeyImageName] as? String {
            self.image = UIImage.getSkinImageFromSkinPlist(str: name)
            print(name)
        }
        if let name = map[kTabBarItemKeyImageName] as? String {
            self.image = UIImage.getSkinImageFromSkinPlist(str: name)
            print(name)
        }
    }
    
}

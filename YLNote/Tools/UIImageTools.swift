//
//  UIImageTools.swift
//  YLNote
//
//  Created by tangh on 2021/1/30.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation
extension UIImage {
    
    /// image 裁剪圆角
    /// - Parameters:
    ///   - corners: 待设圆角的集合
    ///   - radius: 圆角大小
    @objc func addCorner(_ corners: UIRectCorner,radius: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        let context = UIGraphicsGetCurrentContext();
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        context?.addPath(path.cgPath);
        context?.clip();
        self.draw(in: rect)
        context?.drawPath(using: .fillStroke)
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
}

//MARK: Skin (一键换肤)
extension UIImage {
    static func getSkinImageFromSkinPlist(str: String) -> UIImage? {
        let dict = YLSkinMananger.defaultManager().skinMap
        guard let selectColor = dict["selectColor"] as? String else { return nil }
        return UIImage(named: "\(str)_\(selectColor)")
    }
}

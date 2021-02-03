//
//  UIViewTools.swift
//  YLNote
//
//  Created by tangh on 2021/2/1.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation

typealias CornerSetting = (topLeft: CGFloat,topRight: CGFloat,bottomLeft: CGFloat,bottomRight: CGFloat)

extension UIView {
    
    /// 为UIView、含有子视图、UIImageView设置圆角
    /// - Parameters:
    ///   - corners: 圆角位置
    ///   - radius: 圆角大小
    ///   - fillColor: 圆角填充色
    func addCorner(_ corners:UIRectCorner, radius: CGFloat,fillColor: UIColor = .white) {
        guard let image = drawCircleImageWithBezierPath(corners, rectSize: self.bounds.size, radius: radius, fillColor: fillColor) else { return  }
        if self.isKind(of: UIImageView.self) {
            let imageView:UIImageView = self as! UIImageView
            imageView.image = image
        } else {            
            let imageView:UIImageView = UIImageView(frame: self.bounds)
            imageView.image = image
            self.insertSubview(imageView, at: 0)
        }
    }
    
    func drawCircleImageWithBezierPath(_ corners:UIRectCorner,rectSize: CGSize,radius: CGFloat, fillColor:UIColor) -> UIImage? {
        var setting:CornerSetting = CornerSetting(0,0,0,0)
        
        switch corners {
        case .allCorners: setting = (radius,radius,radius,radius)
        case .topLeft:  setting = (radius,0,0,0)
        case .topRight:  setting = (0,radius,0,0)
        case .bottomLeft:  setting = (0,0,radius,0)
        case .bottomRight:  setting = (0,0,0,radius)
        default:
            break
        }
        UIGraphicsBeginImageContextWithOptions(rectSize, false, UIScreen.main.scale)
        
        let contextRef = UIGraphicsGetCurrentContext();
        //2.描述路径
        let bezierPath = UIBezierPath()
        
        let hLeftUpPoint = CGPoint(x: setting.topLeft, y: 0);
        let hRightUpPoint = CGPoint(x: rectSize.width - setting.topRight, y: 0);
        let hLeftDownPoint = CGPoint(x: setting.bottomLeft, y: rectSize.height);
        
        let vLeftUpPoint = CGPoint(x: 0, y: setting.topLeft);
        let vRightDownPoint = CGPoint(x: rectSize.width, y: rectSize.height - radius);
        
        let centerLeftUp = CGPoint(x: setting.topLeft, y: setting.topLeft);
        let centerRightUp = CGPoint(x: rectSize.width - setting.topRight, y: setting.topRight);
        let centerLeftDown = CGPoint(x: setting.bottomLeft, y: rectSize.height - setting.bottomLeft);
        let centerRightDown = CGPoint(x: rectSize.width - setting.bottomRight, y: rectSize.height - setting.bottomRight);
        bezierPath.move(to: hLeftUpPoint)
        bezierPath.addLine(to: hRightUpPoint)
        bezierPath.addArc(withCenter: centerRightUp, radius: radius, startAngle: CGFloat( Double.pi * 3 / 2), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        bezierPath.addLine(to: vRightDownPoint)
        bezierPath.addArc(withCenter: centerRightDown, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
        bezierPath.addLine(to: hLeftDownPoint)
        bezierPath.addArc(withCenter: centerLeftDown, radius: radius, startAngle: CGFloat( Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
        bezierPath.addLine(to: vLeftUpPoint)
        bezierPath.addArc(withCenter: centerLeftUp, radius: radius, startAngle: CGFloat( Double.pi), endAngle: CGFloat(Double.pi * 3 / 2 ), clockwise: true)
        bezierPath.addLine(to: hLeftUpPoint)
        bezierPath.close()
        
        
        //If draw drection of outer path is same with inner path, final result is just outer path.
        bezierPath.move(to: .zero)
        bezierPath.addLine(to: CGPoint(x: 0, y: rectSize.height))
        bezierPath.addLine(to: CGPoint(x: rectSize.width, y: rectSize.height))
        bezierPath.addLine(to: CGPoint(x: rectSize.width, y: 0))
        bezierPath.addLine(to: .zero)
        bezierPath.close()
        
        fillColor.setFill()
        bezierPath.fill()
        contextRef?.strokePath()
        
        let antiRoundedCornerImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        return antiRoundedCornerImage
    }
    
    
}

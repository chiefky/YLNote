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

//MARK: SKin

struct UIViewAssociatedKeys {
    static var deallocObjc:String = "UIView.deallocObjc"
    static var skinMap:String = "UIView.skinMap"
}

struct UIViewSkinProperties {
    static let imageName = "UIViewSkinProperties.imageName" // 设置图片
    static let highlightedImageName = "UIViewSkinProperties.highlightedImageName" // 高亮图片
    static let  selectedImageName = "UIViewSkinProperties.selectedImageName" // 选中图片
    static let  disabledImageName = "UIViewSkinProperties.disabledImageName" // 未选中图片
    static let  colorTitle = "UIViewSkinProperties.colorTitle" // 标题颜色
    static let  highlightColorName = "UIViewSkinProperties.highlightColorName" // 标题高亮颜色
    static let  selectedColorName = "UIViewSkinProperties.selectedColorName" // 设置标题选中颜色
    static let  disabledColorName = "UIViewSkinProperties.disabledColorName" // 设置标题未选中颜色
    static let  bgColorName = "UIViewSkinProperties.bgColorName" // 设置背景颜色
    
}

extension UIView:NamespaceWrappable {
    
    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = YLSkinMananger.defaultManager().bgColor
    }
    
    var skinMap: NSDictionary? {
        get {
            return  objc_getAssociatedObject(self, &UIViewAssociatedKeys.skinMap) as? NSDictionary
        }
        set {
            objc_setAssociatedObject(self, &UIViewAssociatedKeys.skinMap, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC);
            if newValue != nil {
                removeSkinObserver()
                addSkinObserver()
                skinChanged()
            } else {
                removeSkinObserver()
            }
        }
    }
    /// 将UIView注册到NotificationCenter中,并给UIView绑定一个弱持有的销毁者对象（用来在view销毁前将view从NotificationCenter中移除）
    func addSkinObserver() {
        
        if objc_getAssociatedObject(self, &UIViewAssociatedKeys.deallocObjc) == nil {
            let obj = DeallocExecutor(id: UIViewAssociatedKeys.deallocObjc) { [unowned self] in
                NotificationCenter.default.removeObserver(self)
            }
            objc_setAssociatedObject(self, &UIViewAssociatedKeys.deallocObjc, obj, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        NotificationCenter.default.removeObserver(self, name: .skinChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(skinChanged), name: .skinChanged, object: nil)
        
    }
    
    func removeSkinObserver() {
        NotificationCenter.default.removeObserver(self, name: .skinChanged, object: nil)
    }
    
    @objc func skinChanged() {
        print("\(#function)")
        DispatchQueue.main.async {
            self.updateSkin()
        }
    }
    
    func updateSkin() {
        guard let map = skinMap else { return }
        if let obj = self as? UILabel {
            if let name = map[UIViewSkinProperties.colorTitle] as? String {
                obj.textColor = UIColor(hex: name)
            }
            if let name = map[UIViewSkinProperties.highlightColorName] as? String {
                obj.highlightedTextColor = UIColor(hex: name)
            }
            if let name = map[UIViewSkinProperties.bgColorName] as? String {
                obj.backgroundColor = UIColor(hex: name)
            }
            
        }
        else if let obj = self as? UIButton {
            if let name = map[UIViewSkinProperties.colorTitle] as? String {
                obj.setTitleColor(UIColor(hex: name), for: .normal)
            }
            
            if let name = map[UIViewSkinProperties.highlightColorName] as? String {
                obj.setTitleColor(UIColor(hex: name), for: .highlighted)
            }
            if let name = map[UIViewSkinProperties.selectedColorName] as? String {
                obj.setTitleColor(UIColor(hex: name), for: .selected)
            }
            if let name = map[UIViewSkinProperties.disabledColorName] as? String {
                obj.setTitleColor(UIColor(hex: name), for: .disabled)
            }
            if let name = map[UIViewSkinProperties.imageName] as? String {
                obj.setImage(UIImage(named: name), for: .normal)
            }
            if let name = map[UIViewSkinProperties.highlightedImageName] as? String {
                obj.setImage(UIImage(named: name), for: .highlighted)
            }
            if let name = map[UIViewSkinProperties.selectedImageName] as? String {
                obj.setImage(UIImage(named: name), for: .selected)
            }
            if let name = map[UIViewSkinProperties.disabledImageName] as? String {
                obj.setImage(UIImage(named: name), for: .disabled)
            }
            if let name = map[UIViewSkinProperties.bgColorName] as? String {
                obj.backgroundColor = UIColor(hex: name)
            }
        }
        else if let obj = self as? UIImageView {
            if let name = map[UIViewSkinProperties.imageName] as? String {
                obj.image = UIImage(named: name)
            }
            
            if let name = map[UIViewSkinProperties.highlightedImageName] as? String {
                obj.highlightedImage = UIImage(named: name)
            }
            
            if let name = map[UIViewSkinProperties.bgColorName] as? String {
                obj.backgroundColor = UIColor(hex: name)
            }

        }
        else if let obj = self as? UISlider {
            
        }
        else if let obj = self as? UITextField {
            if let name = map[UIViewSkinProperties.colorTitle] as? String {
                obj.textColor = UIColor(hex: name)
            }
        }
        else if let obj = self as? UITextView {
            if let name = map[UIViewSkinProperties.colorTitle] as? String {
                obj.textColor = UIColor(hex: name)
            }
        }
        else {
            if let name = map[UIViewSkinProperties.bgColorName] as? String {
                self.backgroundColor = UIColor(hex: name)
            }
            
        }
    }
}

//
//  YLBasicAnimateViewController.swift
//  YLNote
//
//  Created by tangh on 2021/1/29.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
/**
 let animation = CABasicAnimation(keyPath: "position.x")
 animation.toValue = 200;
 animation.duration = 0.8;
 animation.repeatCount = 5;
 animation.beginTime = CACurrentMediaTime() + 0.5;
 animation.fillMode = CAMediaTimingFillMode.removed;
 self.aView.layer.add(animation, forKey: nil)
 
 keypath:
 这里我们使用了 animationWithKeyPath 这个方法来改变 layer 的属性，可以使用的属性有很多，具体可以参考这里和这里。其中很多属性在前面介绍的 UIView 动画部分我们也看到过，进一步验证了 UIView 的动画方法是对底层 CALayer 的一种封装。

 需要注意的一点是，上面我们使用了 position 属性， layer 的这个 position 属性和 View 的 frame 以及 bounds 属性都不相同，而是和 Layer 的 anchorPoint 有关，可以由下面的公式计算得到：

 position.x = frame.origin.x + 0.5 * bounds.size.width；
 position.y = frame.origin.y + 0.5 * bounds.size.height；
 关于 anchorPoint 和 position 属性的以及具体计算的原理可以参考这篇文章。

 属性
 CABasicAnimation 的属性有下面几个：
 
     beginTime
     duration
     fromValue
     toValue
     byValue
     repeatCount
     autoreverses
     timingFunction
 
 可以看到，其中 beginTime，duration，repeatCount 等属性和上面在 UIView 中使用到的 duration，UIViewAnimationOptionRepeat 等选项是相对应的，不过这里的选项能够提供更多的扩展性。

 需要注意的是 fromValue，toValue，byValue 这几个选项，支持的设置模式有下面几种：

 设置 fromValue 和 toValue：从 fromValue 变化到 toValue
 设置 fromValue 和 byValue：从 fromValue 变化到 fromValue + byValue
 设置 byValue 和 toValue：从 toValue - byValue 变化到 toValue
 设置 fromValue： 从 fromValue 变化到属性当前值
 设置 toValue：从属性当前值变化到 toValue
 设置 byValue：从属性当前值变化到属性当前值 + toValue
 看起来挺复杂，其实概括起来基本就是，如果某个值不设置，就是用这个属性当前的值。

 另外，可以看到上面我们使用的:

 animation.toValue = @200;
 而不是直接使用 200，因为 toValue 之类的属性为 id 类型，或者像这样使用 @ 符号，或者使用：

 animation.toValue = [NSNumber numberWithInt:200];
 最后一个比较有意思的是 timingFunction 属性，使用这个属性可以自定义动画的运动曲线（节奏，pacing），系统提供了五种值可以选择：

     kCAMediaTimingFunctionLinear 线性动画
     kCAMediaTimingFunctionEaseIn 先快后慢
     kCAMediaTimingFunctionEaseOut 先慢后快
     kCAMediaTimingFunctionEaseInEaseOut 先慢后快再慢
     kCAMediaTimingFunctionDefault 默认，也属于中间比较快
 此外，我们还可以使用 [CAMediaTimingFunction functionWithControlPoints] 方法来自定义运动曲线，这个网站提供了一个将参数调节可视化的效果，关于动画时间系统的具体介绍可以参考这篇文章。
 */
class YLBasicAnimateViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    // MARK: - func
    func setupUI() {
        view.backgroundColor = YLTheme.main().backColor
        title = "CABasicAnimation"
        self.edgesForExtendedLayout = [] // 从导航栏底下开始布局
        view.addSubview(self.aView)
        
        self.butn.addTarget(self, action: #selector(testAnimation), for: .touchUpInside)
        view.addSubview(self.butn)
        butn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-30)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }
        
    }
    
    @objc func testAnimation() {
        let animation = CABasicAnimation(keyPath: "position.x")
           animation.toValue = 200;
           animation.duration = 0.8;
           animation.repeatCount = 5;
           animation.beginTime = CACurrentMediaTime() + 0.5;
           animation.fillMode = CAMediaTimingFillMode.removed;
           self.aView.layer.add(animation, forKey: nil)
    }
    
    lazy var aView: YLTestView = {
        let view = YLTestView(frame: CGRect(x: 10, y: 10, width: 150, height: 150))
        view.backgroundColor = .systemPink
        view.text = "a"
        return view
    }()
    
    lazy var butn: UIButton = {
        let butnn = UIButton(type: .custom)
        butnn.setTitle("显示动画", for: .normal)
        butnn.setTitleColor(.systemPink, for: .normal)
        return butnn
    }()
    
}

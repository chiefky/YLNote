//
//  YLOffsetScreenViewController.swift
//  YLNote
//
//  Created by tangh on 2021/1/30.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
/**
 以下离屏渲染操作，按对性能影响等级从高到低进行排序:

 1. shadows（阴影）
 方案：在设置完layer的shadow属性之后，设置layer.shadowPath = [UIBezierPath pathWithCGRect:view.bounds].CGPath;

 2.圆角（前边已解决过）
 3.mask遮罩
 方案：不用mask（哈哈）

 4. allowsGroupOpacity（组不透明）
 开启CALayer的 allowsGroupOpacity 属性后，子 layer 在视觉上的透明度的上限是其父 layer 的 opacity (对应UIView的 alpha )，并且从 iOS 7 以后默认全局开启了这个功能，这样做是为了让子视图与其容器视图保持同样的透明度。
 方案：关闭 allowsGroupOpacity 属性，按产品需求自己控制layer透明度。

 5. edge antialiasing（抗锯齿）
 方案：不设置 allowsEdgeAntialiasing 属性为YES(默认为NO)

 6. shouldRasterize(光栅化)
 当视图内容是静态不变时，设置 shouldRasterize(光栅化)为YES，此方案最为实用方便。

 view.layer.shouldRasterize = true;
 view.layer.rasterizationScale = view.layer.contentsScale;
 但当视图内容是动态变化(如后台下载图片完毕后切换到主线程设置)时，使用此方案反而为增加系统负荷。

 7.Core Graphics API(核心绘图)
 Core Graphics API(核心绘图)的绘制操作会导致CPU的离屏渲染。
 方案：放到后台线程中进行。

 */
class YLOffsetScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}

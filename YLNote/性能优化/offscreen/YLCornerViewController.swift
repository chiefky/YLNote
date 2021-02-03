//
//  YLCornerViewController.swift
//  YLNote
//
//  Created by tangh on 2021/2/3.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLCornerViewController: UIViewController {
    @IBOutlet weak var aView: YLTestView!
    @IBOutlet weak var bView: YLTestView!
    @IBOutlet weak var cView: YLTestView!
    
    @IBOutlet weak var dView: YLTestView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addcorner()
    }

    func addcorner() {
        self.edgesForExtendedLayout = []
        addCornerA()
        addCornerB()
        addCornerC()
        addCornerD()
    }
    
    func setupUI() {
        aView.centerText = "iOS9之后优先推荐"
        bView.centerText = "mask离屏渲染"
        cView.centerText = "CPU、内存开销，不太推荐"
        dView.centerText = "推荐，但有局限性"

    }
    
    /// 不含content的可以只用cornerRadius，含有content需要搭配masksToBounds（iOS9之后系统优化不会触发离屏渲染，优先推荐）
    func addCornerA() {
        aView.layer.cornerRadius = aView.bounds.height / 2;
        aView.contentView.image = #imageLiteral(resourceName: "mmco")
        aView.layer.masksToBounds = true
    }
    
    /// 使用mask裁剪遮罩区域（两种方式：A,B 均产生离屏渲染，不推荐）
    func addCornerB() {
        // A.通过图片生成遮罩，
        bView.contentView.image = #imageLiteral(resourceName: "mmco")
        let maskImage = #imageLiteral(resourceName: "cover");
        let  mask = CALayer()
        mask.frame = CGRect(x: 0, y: 0, width: maskImage.size.width, height: maskImage.size.height);
        mask.contents = maskImage.cgImage;
        bView.layer.mask = mask;

        //B.通过贝塞尔曲线生成
//        let mask1 = CAShapeLayer()
//        mask1.path = UIBezierPath(ovalIn: bView.bounds).cgPath
//        bView.layer.mask = mask1;
    }

    
    /// 在子线程绘制一张圆形图片，切到主线程赋值 (增加CPU的负担,多增加一份内存开销，不是很推荐)
    /**通过CPU重新绘制一份带圆角的视图来实现圆角效果，会大大增加CPU的负担，而且相当于多了一份视图拷贝会增加内存开销。但是就显示性能而言，由于没有触发离屏渲染，所以能保持较高帧率。重新绘制的过程可以交由后台线程来处理。
     */
    func addCornerC() {
        DispatchQueue.global().async {//并行、异步
            let oldImage = #imageLiteral(resourceName: "mmco")
            let image = oldImage.addCorner(.allCorners, radius: oldImage.size.height/2)
            DispatchQueue.main.async {//串行、异步'
                self.cView.contentView.image = image
            }
        }
    }
    
    /// 此方法就是在要添加圆角的视图上再叠加一个部分透明的视图，只对圆角部分进行遮挡。图层混合的透明度处理方式与mask正好相反。此方法虽然是最优解，没有离屏渲染，没有额外的CPU计算，但是应用范围有限。（除有局限性，推荐）
    ///     //背景色和cover图片的圆角颜色相同
    func addCornerD() {
        dView.contentView.image = #imageLiteral(resourceName: "mmco")
        let coverImg = #imageLiteral(resourceName: "cover")
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: dView.frame.size.width, height: dView.frame.size.height)
        maskLayer.contents = coverImg.cgImage
        dView.layer.addSublayer(maskLayer)
    }
}

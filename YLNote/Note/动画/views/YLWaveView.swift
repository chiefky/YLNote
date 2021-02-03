//
//  YLWaveView.swift
//  YLNote
//
//  Created by tangh on 2021/2/1.
//  Copyright © 2021 tangh. All rights reserved.
//
import UIKit
/**
 　　正弦函数

 y=Asin(ωx+φ)+k //正弦函数
 y=Acos(ωx+φ)+k //余弦函数
 其中

 A——振幅，当物体作轨迹符合正弦曲线的直线往复运动时，其值为行程的1/2。
 (ωx+φ)——相位，反映变量y所处的状态。
 φ——初相，x=0时的相位；反映在坐标系上则为图像的左右移动。
 k——偏距，反映在坐标系上则为图像的上移或下移。
 ω——角速度， 控制正弦周期(单位角度内震动的次数)。
 */
class YLWaveView: UIView {
    
    var amplitude = 1.0 //振幅
    var waveW = 1.0 //周期
    var waveOffset = 1.0 // 波动偏移
    override init(frame: CGRect) {
        super.init(frame: frame)
        amplitude = 20;
        waveW = 3 / 100.0;
        waveOffset = 10;
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor.clear
        self.layer.addSublayer(shapeLayer)
        self.displayLink.add(to: RunLoop.main, forMode: .common)
    }
    
    func invalide()  {
        self.displayLink.invalidate()
    }

    @objc func waveAnimation(_ sender: CADisplayLink) {
        waveOffset += 0.1
        waveAnimationWithShapeLayer()
//        waveAnimationWithDrawRect()
    }
    
    /// 使用shapeLayer.path绘制动画
    func waveAnimationWithShapeLayer()  {
         self.bezierPath.removeAllPoints()
        bezierPath.move(to: CGPoint(x: self.frame.width, y: self.frame.height/2))
         bezierPath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
         bezierPath.addLine(to: CGPoint(x: 0, y:self.frame.height))
         bezierPath.addLine(to: CGPoint(x: 0, y: self.frame.height/2))
        var y:CGFloat = 5
        for x in Int(0.0)...Int(self.frame.width) {
                        
            y = CGFloat(amplitude * sin(waveW * Double(x) + waveOffset) + 50)
             bezierPath.addLine(to: CGPoint(x: CGFloat(x), y: y))
         }
         bezierPath.close()
         shapeLayer.path = bezierPath.cgPath
    }
    
    /// 重写draw(rect:)方法，绘制动画（CPU使用率暴涨）
    func waveAnimationWithDrawRect() {
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
        
//    override func draw(_ rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext()
//        let sinPath = UIBezierPath()
//        var y: CGFloat
//        let amplitude: CGFloat = 10 //振幅
//        let palstance: CGFloat = .pi / bounds.size.width //角速度
//
//        let startPoint = CGPoint(x: 0, y: rect.height)
//        sinPath.move(to: startPoint)
//        //正弦曲线
//        for x in Int(0.0)...Int(rect.size.width) {
//            y = amplitude * sin(palstance * CGFloat(x) + CGFloat(waveOffset)) - 50.0
//            let point = CGPoint(x: CGFloat(x), y: y + rect.height - amplitude)
//            sinPath.addLine(to: point)
//        }
//
//        let endPoint = CGPoint(x: rect.width, y: rect.height)
//        sinPath.addLine(to: endPoint)
//        #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).setFill()
//
//        context?.addPath(sinPath.cgPath)
//        context?.drawPath(using: .fill)
//    }

    //MARK:-lazy
    lazy var displayLink: CADisplayLink = {
        let dis = CADisplayLink(target: self, selector: #selector(waveAnimation(_:)))
        return dis
    }()
    
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
        return layer
    }()
    
    lazy var bezierPath: UIBezierPath = {
        let bezier = UIBezierPath()
        return bezier
    }()
    
    
}

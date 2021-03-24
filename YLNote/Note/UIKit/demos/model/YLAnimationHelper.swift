//
//  YLAnimationHelper.swift
//  YLNote
//
//  Created by tangh on 2021/1/22.
//  Copyright © 2021 tangh. All rights reserved.
//
import UIKit;

class YLAnimationHelper: NSObject {
    
    static var universalTimingFunction:CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    
    static func resetTimingFunction(){
        self.universalTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    }
    
    
    static func animation(keyPath:String ,from:Any? ,to:Any? ,duration :TimeInterval,removeOnCompletion:Bool = true) -> CABasicAnimation{
        let anim = CABasicAnimation(keyPath:keyPath)
        anim.duration = duration
        anim.fromValue = from
        anim.toValue = to
        anim.timingFunction = universalTimingFunction
        if !removeOnCompletion{
            anim.isRemovedOnCompletion = false
            anim.fillMode = CAMediaTimingFillMode.forwards
        }
        
        return anim
    }
    
    static func keyframeAnimation(keyPath:String ,values:[Any]? ,keyTimes:[NSNumber]? ,duration :TimeInterval,removeOnCompletion:Bool = true) -> CAKeyframeAnimation{
        let anim = CAKeyframeAnimation(keyPath: keyPath)
        anim.values = values
        anim.keyTimes = keyTimes
        anim.duration = duration
        anim.timingFunction = universalTimingFunction
        if !removeOnCompletion{
            anim.isRemovedOnCompletion = false
            anim.fillMode = CAMediaTimingFillMode.forwards
        }
        
        return anim
    }
    
    static func bezierPathAnimation(from:UIBezierPath ,to:UIBezierPath ,duration:TimeInterval) -> CABasicAnimation{
        
        return self.animation(keyPath: "path", from: from.cgPath, to: to.cgPath, duration: duration ,removeOnCompletion: true)
    }
    
    
    static func bezierPathAnimation(from:UIBezierPath ,to:UIBezierPath ,duration:TimeInterval ,removeOnCompletion:Bool = true) -> CABasicAnimation{
        
        return self.animation(keyPath: "path", from: from.cgPath, to: to.cgPath, duration: duration ,removeOnCompletion: removeOnCompletion)
    }
    
    static func generateAnimationSequence(_ animations:CABasicAnimation ...) -> [CABasicAnimation]?{
        var begin : CFTimeInterval = 0
        for anim in animations {
            anim.beginTime = begin
            begin += anim.duration
        }
        
        return animations
    }
    
    static func generateAnimationGroup(_ animations:CABasicAnimation ... , removeOnCompletion:Bool = true) -> CAAnimationGroup{
        
        var begin : CFTimeInterval = 0
        for anim in animations {
            anim.beginTime = begin
            begin += anim.duration
        }
        
        let group = CAAnimationGroup()
        group.animations = animations
        group.duration = animations.last!.beginTime + animations.last!.duration
        
        if !removeOnCompletion {
            group.isRemovedOnCompletion = false
            group.fillMode = CAMediaTimingFillMode.forwards
        }
        
        return group
        
    }
}

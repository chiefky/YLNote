//
//  YLCornerList.m
//  YLNote
//
//  Created by tangh on 2021/2/1.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLCornerList.h"
#import "YLNote-Swift.h"

/// 设置圆角的方式
@implementation YLCornerList

#pragma mark - 方法一：裁剪圆角 （cornerRadius + masksToBounds)
//方法一： 裁剪圆角 （cornerRadius + masksToBounds ）这种方法最简洁，代码量最少，但是性能最低，因为会触发离屏渲染。对性能要求不是很高的场合可以使用。
- (void)addCornerWithCornerRadiusAndMaskToBounds:(CGFloat)cornerRadius forView:(UIView *)view {
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
}

#pragma mark - 方法一：文本视图类上实现圆角 （cornerRadius)
//方法二： 文本视图类上实现圆角（UILabel、UITextField、UITextView）
/// UILabel: UILabel设置圆角时，只需要设置cornerRadius的值即可，不会触发离屏渲染。
/// UITextField: UITextField设置圆角时，只需要设置cornerRadius的值即可，不会触发离屏渲染
/// UITextView: UITextView设置圆角时，只需要设置cornerRadius的值即可，不会触发离屏渲染。
- (void)addCornerWithCornerRadius:(CGFloat)cornerRadius forView:(UIView *)view {
        view.layer.cornerRadius = cornerRadius;
}

#pragma mark - 方法三：混合图层:
//方法三：混合图层:
///  这种方法是通过上面添加一层裁剪成圆形图片蒙层达到欺骗用户的效果，这种方法不会造成离屏渲染，性能较高。
- (void)addCornerWithCorners:(UIRectCorner)corners adius:(CGFloat)radius forView:(UIView *)view {
    UIImage *newImage = [self addRounderCornerWithCorners:corners radius:radius size:view.bounds.size fillColor:[UIColor whiteColor]];
    // [view addRounderCornerByBezierWithRadius:radius rectSize:view.bounds.size fillColor:[UIColor whiteColor]];
    if ([view isKindOfClass:[UIImageView class]]) {
        ((UIImageView *)view).image = newImage;
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
          [imageView setImage:newImage];
          [view insertSubview:imageView atIndex:0];
    }
    
}

/**
 绘制裁剪圆角后图片

 @param radius 圆角
 @param rectSize 视图尺寸
 @param fillColor 填充色 （被裁去的四个角的颜色）
 @return 图片
 */
- (UIImage *)addRounderCornerByBezierWithRadius:(float)radius rectSize:(CGSize)rectSize fillColor:(UIColor *)fillColor {
    UIGraphicsBeginImageContextWithOptions(rectSize, false, [UIScreen mainScreen].scale);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //2.描述路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    CGPoint hLeftUpPoint = CGPointMake(radius, 0);
    CGPoint hRightUpPoint = CGPointMake(rectSize.width - radius, 0);
    CGPoint hLeftDownPoint = CGPointMake(radius, rectSize.height);
    
    CGPoint vLeftUpPoint = CGPointMake(0, radius);
    CGPoint vRightDownPoint = CGPointMake(rectSize.width, rectSize.height - radius);
    
    CGPoint centerLeftUp = CGPointMake(radius, radius);
    CGPoint centerRightUp = CGPointMake(rectSize.width - radius, radius);
    CGPoint centerLeftDown = CGPointMake(radius, rectSize.height - radius);
    CGPoint centerRightDown = CGPointMake(rectSize.width - radius, rectSize.height - radius);
    
    [bezierPath moveToPoint:hLeftUpPoint];
    [bezierPath addLineToPoint:hRightUpPoint];
    [bezierPath addArcWithCenter:centerRightUp radius:radius startAngle:(CGFloat)(M_PI * 3 / 2) endAngle:(CGFloat)(M_PI * 2) clockwise: true];
    [bezierPath addLineToPoint:vRightDownPoint];
    [bezierPath addArcWithCenter:centerRightDown radius: radius startAngle: 0 endAngle: (CGFloat)(M_PI / 2) clockwise: true];
    [bezierPath addLineToPoint:hLeftDownPoint];
    [bezierPath addArcWithCenter:centerLeftDown radius: radius startAngle: (CGFloat)(M_PI / 2) endAngle: (CGFloat)(M_PI) clockwise: true];
    [bezierPath addLineToPoint:vLeftUpPoint];
    [bezierPath addArcWithCenter:centerLeftUp radius: radius startAngle: (CGFloat)(M_PI) endAngle: (CGFloat)(M_PI * 3 / 2) clockwise: true];
    [bezierPath addLineToPoint:hLeftUpPoint];
    [bezierPath closePath];
    
    //If draw drection of outer path is same with inner path, final result is just outer path.
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(0, rectSize.height)];
    [bezierPath addLineToPoint:CGPointMake(rectSize.width, rectSize.height)];
    [bezierPath addLineToPoint:CGPointMake(rectSize.width, 0)];
    [bezierPath addLineToPoint:CGPointZero];
    [bezierPath closePath];
    
    [fillColor setFill];
    [bezierPath fill];
    
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    UIImage *antiRoundedCornerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return antiRoundedCornerImage;
}


/// 与上面方法一样，只是一个用贝塞尔曲线减去四角，一个是context填充
/// 生成一张带圆角的图片（用fillcolor 代替view的背景色）
/// @param radius 圆角
/// @param size 图片尺寸
- (UIImage *)addRounderCornerWithCorners:(UIRectCorner)corners radius:(CGFloat)radius size:(CGSize)size fillColor:(UIColor *)fillColor {
    CGFloat topLeft = 0,topRight = 0,bottomLeft = 0, bottomRight = 0;
    
    switch (corners) {
        case UIRectCornerAllCorners: {
            topLeft = radius;
            topRight = radius;
            bottomLeft = radius;
            bottomRight = radius;
        }
            break;
            case UIRectCornerTopLeft: topLeft = radius; break;
            case UIRectCornerTopRight: topRight = radius; break;
            case UIRectCornerBottomLeft: bottomLeft = radius; break;
            case UIRectCornerBottomRight: bottomRight = radius; default:
            break;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(cxt, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(cxt, fillColor.CGColor);
    
    CGContextMoveToPoint(cxt, size.width, size.height-radius);
    CGContextAddArcToPoint(cxt, size.width, size.height, size.width-bottomRight, size.height, bottomRight);//右下角
    CGContextAddArcToPoint(cxt, 0, size.height, 0, size.height-bottomLeft, bottomLeft);//左下角
    CGContextAddArcToPoint(cxt, 0, 0, topLeft, 0, topLeft);//左上角
    CGContextAddArcToPoint(cxt, size.width, 0, size.width, topRight, topRight);//右上角
    CGContextClosePath(cxt);
    CGContextDrawPath(cxt, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - 方法四： Quartz2D
/// 方法四：Quartz2D（这种方法性能也较高，只是局限性比较大，只能针对图片进行裁剪。我们一般可以将该方法添加到 UIImage 的分类中）
/// 通过Quartz2D将图形绘制出一张圆形图片来进行显示。
- (void)drawRoundedCornerWithCircleImage:(UIImage *)image forView:(UIView *)view {
    if ([view isKindOfClass:[UIImageView class]]) {
        ((UIImageView *)view).image = [image addCorner:UIRectCornerAllCorners radius:view.bounds.size.height/2];
    }

}

#pragma mark - 方法五： Mask（使用 Mask 裁剪圆角会造成离屏渲染，掉帧，卡顿。）
/// 方法五：Mask 效果与混合图层的效果非常相似，只是使用同一个遮罩图像时，mask 与混合图层的效果是相反的，在 Demo 里使用反向内容的遮罩来实现圆角。实现 mask 效果使用 CALayer 的layer属性，在 iOS 8 以上可以使用 UIView 的maskView属性。
- (void)drawRoundedCornerWithMask:(UIImage *)maskImage forView:(UIView *)view {
    // a.使用图片设置Mask (缺一张蒙版图)
    if (@available(iOS 8.0, *)) {
        view.maskView = [[UIImageView alloc] initWithImage: maskImage];
    } else {
        CALayer *maskLayer = [[CALayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.contents = (__bridge id _Nullable)([maskImage CGImage]);
        view.layer.mask = maskLayer;
    }
    
    // b.使用CAShapeLayer设置Mask
#warning bezierPathWithRoundedRect:使用view.bouns为0；如何解决？
//    UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 60, 60) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(60, 60)];
//    CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
//    shapLayer.path = roundedRectPath.CGPath;
//    iconImgV.layer.mask = shapLayer;
}




@end

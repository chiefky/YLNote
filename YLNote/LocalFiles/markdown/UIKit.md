# UIKit 部分问题

### "setNeedsDisplay 和 setNeedsLayout 两者是什么关系"
答：UIView的setNeedsDisplay和setNeedsLayout方法。首先两个方法都是异步执行的。
setNeedsDisplay会调用自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了。
而setNeedsLayout会默认调用layoutSubViews，就可以处理子视图中的一些数据。
综上两个方法都是异步执行的，layoutSubviews方便数据计算，drawRect方便视图重绘。

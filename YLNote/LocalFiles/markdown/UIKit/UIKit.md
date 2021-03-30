# UIKit 部分问题

### 1. "setNeedsDisplay 和 setNeedsLayout 两者是什么关系"
答：UIView的setNeedsDisplay和setNeedsLayout方法。首先两个方法都是异步执行的。
setNeedsDisplay会调用自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了。
而setNeedsLayout会默认调用layoutSubViews，就可以处理子视图中的一些数据。
综上两个方法都是异步执行的，layoutSubviews方便数据计算，drawRect方便视图重绘。

### 2. aVC.navigationController pushViewController:bVC 造成卡顿的原因有哪些

答：

* 这是因为从iOS7开始， `UIViewController`的`根view`的背景颜色默认为透明色(即`clearColor`)，所谓“卡顿”其实就是由于透明色重叠后，造成视觉上的错觉，所以这并不是真正的“卡顿”，但这种“卡顿”现象还是让人觉得极其不舒服的，还是务必得解决的！

  > 解决方案：
  >
  >  ``` bVC.view.backgroundColor = [UIColor whiteColor]; ```

* 当处在导航控制器的的根控制器时候, 做一个侧滑pop的操作, 看起来没任何变化, 但是再次push时，动画就失效了

  > 原因：这种情况是会出现在我们自定义的导航控制器中，因为继承自UINavigationController后，原先的右划手势被禁掉了，而我们通常会打开手势，比如：
  >
  > ```swift
  > self.interactivePopGestureRecognizer?.delegate = self
  > ```
  >
  > 这时候如果在根视图里面执行右划手势，相当于执行了一个pop。（只是我们没有看到效果而已），然后接着去执行push，自然就push不到下一级页面了，
  >
  > 解决方法：
  > 判断当前页面是不是根视图，如果是就禁止掉右划手势，如果不是就打开：
  >
  > ```swift
  > class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
  > 
  >     override func viewDidLoad() {
  >         super.viewDidLoad()
  >     
  >         setupNavBarAppearence()
  >         
  >         self.delegate = self
  >         self.interactivePopGestureRecognizer?.delegate = self
  >     }
  > 
  > }
  > extension BaseNavigationController: UINavigationControllerDelegate {
  >     func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
  >         self.interactivePopGestureRecognizer?.isEnabled = self.viewControllers.count > 1
  >     }
  > 
  > }
  > ```

* 我们一般在做简单动画时，可以用UIView 提供的[UIView animateWithDuration: animations:]等方法，来设置一些简单的动画。但是有时候动画效果会失效。
  某个项目中在tableViewCell上使用此方法设置动画时，第一次加载cell时会出现动画失效问题，就会出现所有动画效果duration=0的效果；也就是没有动画效果直接显示设置的值。
  WTF ! ! 代码都是常规操作啊，为什么会失效呢？于是各种尝试，把UIView关于动画的属性和方法试了很多。终于发现问题，原来系统不知什么时候把UIView的areAnimationsEnabled值给设置成了NO,这个值在view创建处理默认是YES;

  > 推测原因：多个nsthread同时处理并在thread中改界面是会造成动画丢失的
  >
  > 解决方法：
  >
  > 解决方法一：
  >  调用UIView的  setAnimationsEnabled方法。
  >
  > ```objc
  >    [UIView setAnimationsEnabled:YES];
  > ```
  >
  > 解决方法二：
  >  将动画代码显式的放在主线程中
  >
  > ```objc
  >     dispatch_async(dispatch_get_main_queue(), ^{
  >         NSLog(@"线程 %@",[NSThread currentThread]);
  >         [UIView animateWithDuration:4 animations:^{ 
  >             NSLog(@"UIView.areAnimationsEnabled==%d",UIView.areAnimationsEnabled); 
  >             self.blockView.tyu_width = blockW;
  >         } ];
  >     });
  > ```
  >
  > 

  
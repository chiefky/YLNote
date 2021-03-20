##__1. unsafe_unretained & __weak

**1.1 两者区别联系**

unsafe_unretained 和 weak一样，表示的是对象的一种弱引用关系。

唯一的区别是：weak修饰的对象被释放后，指向对象的指针会置空，也就是指向nil,不会产生野指针；

而unsafe_unretained修饰的对象被释放后，指针不会置空，而是变成一个野指针，那么此时如果访问这个对象的话，程序就会Crash，抛出BAD_ACCESS的异常。

**1.2 那么这时候通常就会有疑问，那为什么有weak还要用unsafe_unretained呢？**

1.__weak只支持iOS 5.0和OS X Mountain Lion作为部署版本（当然对于现在，这个原因已经可以无视了）

2.__weak对性能会有一定的消耗，使用__weak,需要检查对象是否被释放，在追踪是否被释放的时候当然需要追踪一些信息，那么此时__unsafe_unretained比__weak快，而且一个对象有大量的__weak引用对象的时候，当对象被废弃，那么此时就要遍历weak表，把表里所有的指针置空，消耗cpu资源。

**1.3 那么什么时候使用__unsafe_unretained呢？**

当你明确对象的生命周期的时候，可以使用__unsafe_unretained替代__weak,可以稍微提高一些性能，虽然这点性能微乎其微。

举个例子，当A拥有B对象，A消亡B也消亡，这样当B存在，A也一定会存在的时候，此时B要调用A的接口，就可以通过__unsafe_unretained 保持对A的引用关系。

比如 MyViewController 拥有 MyView, MyView 需要调用 MyViewController 的接口。MyView 中就可以通过 __unsafe_unretained 保持对MyViewController的引用。

__unsafe_unretained MyViewController * myVC;

![缺例子]()

> 一键换肤如何实现？（运营换肤）
>
> 1. 网络获取最新的skin配置文件，
> 2. 判断本地版本与网络版本号，更新本地plist
> 3. 调用changeSkin接口，读取最新的plist配置信息，修改相关配置项并发送`Notification.skinChanged`通知；
> 4. 注册了`Notification.skinChanged`的view 接收通知后，调用相关函数修改控件对应属性
> 5. view销毁前将observer从`NotificationCenter` 中移除
>
> ```objc
> // 添加、移除observer的逻辑实现：
> a. 构造UIView+Skin 的category，给view动态绑定一个销毁者对象（object）；
> 
>     objc_setAssociatedObject(self, &kUIView_DeallocObjc, deallocObjc, OBJC_ASSOCIATION_ASSIGN); // 注意OBJC_ASSOCIATION_ASSIGN
> 
> b.  view销毁之前先销毁关联的associate对象（object），销毁此对象时将observer从NotificationCenter中移除；
> 
> 注意：object对象弱持有view变量时，必须使用unsafe_unretained使用weak会造成removeObserver之前UIView已经置为nil了。
> 
>  
> ```




### 基础问题

1. **Swift中struct和class有什么区别？**
  答：struct是值引用，更轻量，存放于栈区，class是类型引用，存放于堆区。struct无法继承，class可继承。

2. **Swift中的方法调用有哪些形式？**
  答：直接派发、函数表派发、消息机制派发。派发方式受声明位置，引用类型，特定行为的影响。为什么Swift有这么多派发形式？为了效率。

3. **Swift和OC有什么区别？**

  答：Swift和OC的区别有很多，这里简要总结这几条：

|                    | Swift                               | Objective-C          |
| :----------------- | :---------------------------------- | :------------------- |
| 语言特性           | 静态语言，更加安全                  | 动态语言，不那么安全 |
| 语法               | 更精简                              | 冗长                 |
| 命名空间           | 有                                  | 无                   |
| 方法调用           | 直接调用，函数表调用，消息转发      | 消息转发             |
| 泛型/元组/高阶函数 | 有                                  | 无                   |
| 语言效率           | 性能更高，速度更快                  | 略低                 |
| 文件特性           | .swift 单文件                       | .h/.m包含头文件      |
| 编程特性           | 可以更好的实现函数式编程/响应式编程 | 面向对象编程         |

4. **Swift与OC使用中的注意点**

   > **<font color=red>Property(属性)</font>** 
   >
   > Swift没有`property`，也没有`copy`，`nonatomic`等属性修饰词，只有表示属性是否可变的`let`和`var`。
   >
   > **注意点:**
   >
   > | OC（.h表示用于暴露给外接的方法，变量;<br />.m仅供内部使用的方法变量。） | Swift                                                        |
   > | ------------------------------------------------------------ | ------------------------------------------------------------ |
   > | h中声明的property                                            | `internal`(默认)变量                                         |
   > | m中声明的property                                            | `private`变量                                                |
   > | .h中的只读属性<br />`@property (nonatomic,assign,readonly) BOOL hidden;` | `private(set) var hidden: bool`<br />就是只对`hidden`的`set`方法就行`private`标记 |
   > | OC中通过在`nullable`和`nonnull`表示该种属性，方法参数或者返回值是否可以空。如：<br />`@property (nonatomic,assign,readonly,nullable) BOOL hidden;`或者如下🔽 | Swift中针对空类型有个专门的符号`?`，对应OC中的`nil`。        |
   >
   > >如果OC中没有声明一个属性是否可以为空，那就去默认值`nonnull`。
   > >
   > >如果我们想让一个类的所有属性，函数返回值都是`nonnull`，除了手动一个个添加之外还有一个宏命令。
   > >
   > >```swift
   > >NS_ASSUME_NONNULL_BEGIN
   > >/* code */
   > >@property (nonatomic,assign,readonly) BOOL hidden;
   > >NS_ASSUME_NONNULL_END
   > >```
   >
   > **<font color=red>enum（枚举）</font>** 
   >
   > ```objective-c
   > OC中的枚举：
   > typedef NS_ENUM(NSInteger, PlayerState) {
   >     PlayerStateNone = 0,
   >     PlayerStatePlaying,
   >     PlayerStatePause,
   >     PlayerStateBuffer,
   >     PlayerStateFailed,
   > };
   > 
   > typedef NS_OPTIONS(NSUInteger, XXViewAnimationOptions) {
   >     XXViewAnimationOptionNone            = 1 <<  0,
   >     XXViewAnimationOptionSelcted1      	 = 1 <<  1,
   >     XXViewAnimationOptionSelcted2      	 = 1 <<  2,
   > }
   > 
   > ```
   >
   > ```swift
   > Swift中的枚举：（Swift没有NS_OPTIONS的概念，取而代之的是为了满足OptionSet协议的struct类型。）
   > 
   > enum PlayerState: Int {
   >     case none = 0
   >     case playing
   >     case pause
   >     case buffer
   >     case failed
   > }
   > struct ViewAnimationOptions: OptionSet {
   >     let rawValue: UInt
   >     static let None = ViewAnimationOptions(rawValue: 1<<0)
   >     static let Selected1 = ViewAnimationOptions(rawValue: 1<<0)
   >     static let Selected2 = ViewAnimationOptions(rawValue: 1 << 2)
   >     //...
   > }
   > 
   > ```
   >
   > **<font color=red>lazy(懒加载)</font>**
   >
   > ```objective-c
   > OC代码：
   > - (MTObject *)object {
   >     if (!_object) {
   >         _object = [MTObject new];
   >     }
   >     return _object;
   > }
   > ```
   >
   > ```swift
   > Swift代码：
   > lazy var object: MTObject = {
   >     let object = MTObject()
   >     return imagobjecteView
   > }()
   > ```
   >
   > **<font color=red>闭包</font>**
   >
   > OC代码：
   >
   > ```objc
   > typedef void (^DownloadStateBlock)(BOOL isComplete);
   > ```
   >
   > Swift代码：
   >
   > ```swift
   > typealias DownloadStateBlock = ((_ isComplete: Bool) -> Void)
   > 
   > ```
   >
   > **<font color=red>单例</font>**
   >
   >  **使用单例的弊端**：
   >
   > 1.  单例状态的混乱
   >
   >  由于单例是共享的，所以当使用单例时，程序员无法清楚的知道单例当前的状态。
   >
   >  当用户登录，由一个实例负责当前用户的各项操作。但是由于共享，当前用户的状态很可能已经被其他实例改变，而原来的实例仍然不知道这项改变。如果想要解决这个问题，实例就必须对单例的状态进行监控。Notifications 是一种方式，但是这样会使程序过于复杂，同时产生很多无谓的通知。
   >
   > 2. 测试困难
   >
   >  测试困难主要是由于单例状态的混乱而造成的。因为单例的状态可以被其他共享的实例所修改，所以进行需要依赖单例的测试时，很难从一个干净、清晰的状态开始每一个 test case
   >
   > 3. 单例访问的混乱
   >
   >  由于单例时全局的，所以无法对访问权限作出限定。程序任何位置、任何实例都可以对单例进行访问，这将容易造成管理上的混乱。
   >
   > OC代码：
   >
   > ```objc
   > + (XXManager *)shareInstance {
   >     static dispatch_once_t onceToken;
   >     dispatch_once(&onceToken, ^{
   >         instance = [[self alloc] init];
   >     });
   >     return instance;
   > }
   > ```
   >
   > swift代码：
   >
   > ```swift
   > // 第一种:
   > let shared = XXManager()// 声明在全局命名区（global namespace）
   > Class XXManager { 
   > }
   > ```
   >
   > ```swift
   > // 第二种:
   > Class XXManager {
   > 		static let shared = XXManager()
   >   	private override init() {
   >    		// do something 
   >     }
   > }
   > 
   > ```
   >
   > **<font color=red>初始化方法和析构函数</font>**
   >
   > 对于初始化方法OC先调用父类的初始化方法，然后初始自己的成员变量。Swift先初始化自己的成员变量，然后在调用父类的初始化方法。
   >
   > OC代码：
   >
   > ```objc
   > // 初始化方法
   > @interface MainView : UIView
   > @property (nonatomic, strong) NSString *title;
   > - (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title NS_DESIGNATED_INITIALIZER;
   > @end
   > 
   > @implementation MainView
   > - (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
   >     if (self = [super initWithFrame:frame]) {
   >         self.title = title;
   >     }
   >     return self;
   > }
   > @end
   > // 析构函数
   > - (void)dealloc {
   >     //dealloc
   > }
   > 
   > ```
   >
   > 上面类在调用时
   >
   > Swift代码：
   >
   > ```swift
   > class MainViewSwift: UIView {
   >     let title: String
   >     init(frame: CGRect, title: String) {
   >         self.title = title
   >         super.init(frame: frame)
   >     }
   >     required init?(coder: NSCoder) {
   >         fatalError("init(coder:) has not been implemented")
   >     }
   > 		deinit {
   >       //deinit
   >     }
   > }
   > ```
   >
   > **<font color=red>方法访问权限</font>**
   >
   > OC可以通过是否将方法声明在`.h`文件表明该方法是否为私有方法。Swift中没有了`.h`文件，对于方法的权限控制是通过权限关键词进行的，各关键词权限大小为： `private < fileprivate < internal < public < open`
   >
   > 其中`internal`为默认权限，可以在同一`module`下访问。
   >
   > ```objective-c
   > // 实例函数（共有方法）
   > - (void)configModelWith:(XXModel *)model {}
   > // 实例函数（私有方法）
   > - (void)calculateProgress {}
   > // 类函数
   > + (void)configModelWith:(XXModel *)model {}
   > 
   > ```
   >
   > ```swift
   > // 实例函数（共有方法）
   > func configModel(with model: XXModel) {}
   > // 实例函数（私有方法）
   > private func calculateProgress() {}
   > // 类函数（不可以被子类重写）
   > static func configModel(with model: XXModel) {}
   > // 类函数（可以被子类重写）
   > class func configModel(with model: XXModel) {}
   > // 类函数（不可以被子类重写）
   > class final func configModel(with model: XXModel) {}
   > 
   > ```
   >
   > <font color= red >**NSNotification(通知)**</font>
   >
   > OC代码：
   >
   > ```objc
   > // add observer
   > [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(method) name:@"NotificationName" object:nil];
   > // post
   > [NSNotificationCenter.defaultCenter postNotificationName:@"NotificationName" object:nil];
   > 
   > ```
   >
   > Swift代码：
   >
   > ```swift
   > // add observer
   > NotificationCenter.default.addObserver(self, selector: #selector(method), name: NSNotification.Name(rawValue: "NotificationName"), object: nil)
   > // post
   > NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationName"), object: self)
   > 
   > ```
   >
   > 可以注意到，Swift中通知中心`NotificationCenter`不带`NS`前缀，通知名由字符串变成了`NSNotification.Name`的结构体。
   >
   > 改成结构体的目的就是为了便于管理字符串，原本的字符串类型变成了指定的`NSNotification.Name`类型。上面的Swift代码可以修改为：
   >
   > ```swift
   > extension NSNotification.Name {
   > 	static let NotificationName = NSNotification.Name("NotificationName")
   > }
   > // add observer
   > NotificationCenter.default.addObserver(self, selector: #selector(method), name: .NotificationName, object: nil)
   > // post
   > NotificationCenter.default.post(name: .NotificationName, object: self)
   > 
   > ```
   >
   > <font color=red>**protocol(协议/代理)**</font>
   >
   > OC代码：
   >
   > ```objc
   > @protocol XXManagerDelegate <NSObject>
   > - (void)downloadFileFailed:(NSError *)error;
   > @optional
   > - (void)downloadFileComplete;
   > @end
   >   
   > @interface XXManager: NSObject
   > @property (nonatomic, weak) id<XXManagerDelegate> delegate;  
   > @end
   > 复制代码
   > ```
   >
   > Swift中对`protocol`的使用拓宽了许多，不光是`class`对象，`struct`和`enum`也都可以实现协议。需要注意的是`struct`和`enum`为指引用类型，不能使用`weak`修饰。只有指定当前代理只支持类对象，才能使用`weak`。将上面的代码转成对应的Swift代码，就是：
   >
   > ```swift
   > @objc protocol XXManagerDelegate {
   >     func downloadFailFailed(error: Error)
   >     @objc optional func downloadFileComplete() // 可选协议的实现
   > }
   > class XXManager: NSObject {
   > 	weak var delegate: XXManagerDelegate?  
   > }
   > 复制代码
   > ```
   >
   > `@objc`是表明当前代码是针对`NSObject`对象，也就是`class`对象，就可以正常使用weak了。
   >
   > 如果不是针对NSObject对象的delegate，仅仅是普通的class对象可以这样设置代理：
   >
   > ```swift
   > protocol XXManagerDelegate: class {
   >     func downloadFailFailed(error: Error)
   > }
   > class XXManager {
   > 	weak var delegate: XXManagerDelegate?
   > }
   > 复制代码
   > ```
   >
   > 值得注意的是，仅`@objc`标记的`protocol`可以使用`@optional`。
   >
   > 
   >
   > 

5. ### swift中使用类名初始化实例变量

   > 1. 获取类名
   >
   >    ```swift
   >     let vcName = String(describing: YLDemoLifeCycleViewController.self)
   >    ```
   >
   > 2. 通过类名得到类型
   >
   >    ```swift
   >    var vcClass: AnyClass? = NSClassFromString(name)
   >    if isSwift { // 如果是swift类，类名前需要带上包名
   >        vcClass = NSClassFromString("包名" + "." + name) //VCName:表示试图控制器的类名
   >    }
   >    // 然后判断类型
   >    guard let typeClass = vcClass as? UIViewController.Type else {
   >         print("vcClass不能当做UIViewController")
   >         return
   >     }
   >    
   >    ```
   >
   > 3. 得到实例
   >
   >    ```swift
   >    var myVC = typeClass.init() // 没有xib
   >    if useXib { 
   >      //如果有xib，通过xib初始化
   >        myVC = typeClass.init(nibName: name, bundle: nil)
   >    }
   >    ```
   >
   >    

   6. ### 函数自省

   ```swift
      /// 第一种
   
       let function = Selector(functionName)
   
       guard self.responds(to: function) else { return }
   
       self.perform(function)
   
        
   
       return;
   
       // 第二种： 带参数🌰
   
       if functionName.contains(":") {
   
         let funcc = NSSelectorFromString("selectorArg1:Arg2:")
   
         self.perform(funcc, with: "1", with: "2")
   
       }
   
   ```

   

   

6. id类型和Any类型的区别？

7. **从OC向Swift迁移的时候遇到过什么问题？**

8. **字符串分割：`component(separatdBy:) ` vs `.split(separator: )`区别：**

9. **怎么理解面向协议编程？**

10. 
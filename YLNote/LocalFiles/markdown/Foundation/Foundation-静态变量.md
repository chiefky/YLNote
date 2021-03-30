## 静态变量

当我们希望一个变量的作用域不仅仅是作用域某个类的某个对象，而是作用域整个类的时候，这时候就可以使用静态变量。

**static**
 `static`修饰的变量，是一个私有的全局变量。
 `C`或者`Java`中`static`关键字修饰的变量，可以使用类名直接拿到这个变量对象，在其他类中可以进行修改。但是在`OC`中`static`修饰的变量是不能通过类名直接访问的，它只作用于它声明所在的.m文件中。
 `static`修饰的变量必须放在`@implementation`外面或方法中，它只在程序启动初始化一次。



```dart
static int num;
```

## 静态常量

**const**
 `const`修饰的变量是不可变的，如果需要定义一个时间间隔的静态常量，就可以使用`const`修饰。



```objectivec
static const NSTimeInterval LMJTimeDuration = 0.5;
```

如果试图修改`TimeDuration`编译器则会报错。

如果我们定义一个字符串类型的静态常量就要注意了，这两种写法是一样的，而且**是可以修改的**。



```objectivec
static NSString const * LMJName = @"iOS开发者公会";
static const NSString * LMJName = @"iOS开发者公会";
```

这两种写法`cons`修饰的是`* LMJName`,`*`是指针指向符，也就是说此时指向内存地址是不可变的，而内存保存的内容时可变的。
 所以我们应该这样写：



```objectivec
static NSString * const LMJName = @"iOS开发者公会";
```

当我们定义一个对象类型常量的时候，要将`const`修饰符放到`*`指针指向符后面。

## 全局变量

**extern**
 extern修饰的变量，是一个全局变量。



```csharp
extern NSString * LMJName = @"iOS开发者公会;
```

`extern`修饰的变量也可以添加`const`进行修饰：



```csharp
extern NSString * const LMJName = @"iOS开发者公会;
```

此时全局变量只能被初始化一次
 `extern`定义的全局常量的用法和宏定义类似，但是还是有本质上的不同的。 `extern`定义的全局常量更不容易在程序中被无意窜改。


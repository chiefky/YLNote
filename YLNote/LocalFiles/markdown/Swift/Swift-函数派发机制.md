## 派发机制

在探究Swift函数派发机制之前，我们应该先了解一下函数派发的基本知识。函数派发就是程序判断使用哪种途径去调用一个函数的机制，也就是CPU在内存中找到该函数地址并调用的过程。每次函数被调用时都会被触发, 但你又不会太留意的一个东西. 了解函数派发机制对于写出高性能的代码来说很有必要, 而且也能够解释很多 Swift 里"奇怪"的行为。

编译型语言有三种基础的函数派发方式:

- **直接派发(Direct Dispatch，有人也称为静态派发，下文中我们统一叫直接派发)**
- **函数表派发(Table Dispatch)**
- **消息机制派发(Message Dispatch)。**

大多数语言都会支持一到两种, Java 默认使用函数表派发, 但你可以通过 final 修饰符修改成直接派发。 C++ 默认使用直接派发, 但可以通过加上 virtual 修饰符来改成函数表派发。 而 Objective-C 则总是使用消息机制派发, 但允许开发者使用 C 直接派发来获取性能的提高。

### 直接派发 (Direct Dispatch)

直接派发是三种派发方式中最快的。CPU直接按照函数地址调用，使用最少的指令集，办最快的事情。当编译器对程序进行优化的时候，也常常将函数内联，使之成为直接派发方式，优化执行速度。我们熟知的C++默认使用直接派发方式，在Swift中给函数加上final关键字，该函数也会变成直接派发的方式。当然，有利就有弊，直接派发最大的弊病就是没有动态性，不支持继承。

### 函数表派发 (Table Dispatch)

这种方式是编译型语言最常见的派发方式，他既保证了动态性也兼顾了执行效率。函数所在的类会维护一个”函数表”，也就是我们熟知的虚函数表，Swift 里称为 "witness table"。该函数表存取了每个函数实现的指针。每个类的vtable在编译时就会被构建，所以与直接派发相比只多出了两个读取的工作: 读取该类的vtable和该函数的指针。理论上说，函数表派发也是一种高效的方式。不过和直接派发相比，编译器对某些含有副作用的函数却无法优化，也是导致函数表派发变慢的原因之一。而且Swift类扩展里面的方法无法动态加入该类的函数表中，只能使用静态派发的方式，这也是函数表派发的缺陷之一。

我们来看如下代码:

```
class ParentClass {
    func method1() {}
    func method2() {}
}
class ChildClass: ParentClass {
    override func method2() {}
    func method3() {}
}

复制代码
```

当前情景下，编译器会创建两个函数表: 一个属于 ParentClass 类，另一个属于 ChildClass 类，内存布局如下:



<img src="./images/函数派发1.png" alt="img" style="zoom:50%;" />



```
let obj = ChildClass()
obj.method2()

复制代码
```

当调用函数 method2() 时，过程如下:

```
读取该对象(0XB00)的vtable.
读取method2函数指针0x222.
跳转到地址0X222，读取函数实现.
复制代码
```

查表是一种简单, 易实现, 而且性能可预知的方式. 然而, 这种派发方式比起直接派发还是慢一点. 从字节码角度来看, 多了两次读和一次跳转, 由此带来了性能的损耗. 另一个慢的原因是我们开头也说了，编译器对某些含有副作用的函数却无法优化，也是导致函数表派发变慢的原因之一。 这种基于数组的实现, 缺陷在于函数表无法拓展. 子类会在虚数函数表的最后插入新的函数, 没有位置可以让 extension 安全地插入函数。

### 消息机制派发 (Message Dispatch)

消息机制是调用函数最动态的方式. 也是 Cocoa 的基石, 这样的机制催生了 KVO, UIAppearence 和 CoreData 等功能. 这种运作方式的关键在于开发者可以在运行时改变函数的行为. 不止可以通过 swizzling 来改变, 甚至可以用 isa-swizzling 修改对象的继承关系, 可以在面向对象的基础上实现自定义派发。

由于Swfit使用的依旧是Objc的运行时系统，所以这里的消息派发其实也就是Objc的Message Passing(消息传递)。

```
id returnValue = [someObject messageName:parameter];
复制代码
```

someObject就是接收者，messageName就是选择器，选择器和参数一起被称为 “消息“。 当编译时，编译器会将该消息转换成一条标准的C语言调用：

```
id returnValue = objc_msgSend(someObject, @selector(messageName:), parameter);

复制代码
```

objc_msgSend函数回一句接收者和选择器的类型来调用适当的方法，它会去接收者所属类中搜索其方法列表，如果能找到，则跳转到对应实现；若找不到，则沿着继承体系继续向上查找，若能找到，则跳转；如果最终还是找不到，那就执行边界情况的操作，例如 Message forwarding(消息转发)。 看看下面的代码：

Swift 会用树来构建这种继承关系:

```
class ParentClass {
    dynamic func method1() {}
    dynamic func method2() {}
}
class ChildClass: ParentClass {
    override func method2() {}
    dynamic func method3() {}
}

复制代码
```



<img src="./images/函数派发2.png" alt="img" style="zoom:50%;" />

这种派发方式的流程步骤似乎很多，所幸的是objc_msgSend会将匹配的结果缓存到fast map(快速映射表)中，而且每个类都有这样一块缓存；若是之后发送相同的消息，执行速率会很快，会把性能提高到和函数表派发一样快。

## Swift 的派发机制如何派发函数

了解了函数派发的基本知识，我们来看看Swift如何处理函数派发以及如何证明该种派发。我们先来看一张总结表:



<img src="./images/函数派发3.png" alt="img" style="zoom:50%;" />

从上表中我们可以直观的总结出：函数的派发方式和以下两点相关联:

```
对象类型; 值类型总是使用直接派发(静态派发，因为他们没有继承体系)
函数声明的位置; 直接在定义中声明和在扩展中(extension)声明
复制代码
```

除此之外，显式的指定派发方式也会改变函数其原有的派发方式，例如添加final或者@objc关键字等等；以及编译器对特定函数的优化，例如将从未被重写的私有函数优化成静态派发。

下面我们就这四个方面来分析和探讨Swift的派发方式，以及证明其派发方式。

### 对象类型

如上文所述，值类型，也就是struct的对象总是使用静态派发; class对象使用函数表派发(非extension)。请看如下代码示例:

```
class MyClass {
    func testOfClass() {}
   
}

struct MyStruct{
    func testOfStruct() {}
}

复制代码
```

现在我们使用如下命令将swift代码转换为SIL(中间码)以便查看其函数派发方式:

```
swiftc -emit-silgen -O main.swift
复制代码
```

输出结果如下:

```
...

class MyClass {
  func testOfClass()
  @objc deinit ///新增
  init() //新增
}

struct MyStruct {
  func testOfStruct()
  init() //新增
}



/// sil_vtable
sil_vtable MyClass {
  #MyClass.testOfClass!1: (MyClass) -> () -> () : @$s4main7MyClassC06testOfC0yyF	// MyClass.testOfClass()
  #MyClass.init!allocator.1: (MyClass.Type) -> () -> MyClass : @$s4main7MyClassCACycfC	// MyClass.__allocating_init()
  #MyClass.deinit!deallocator.1: @$s4main7MyClassCfD	// MyClass.__deallocating_deinit
}

复制代码
```

首先swift会为class添加init和@objc deinit方法，为struct添加init方法。在文件的结尾处就会显示如上代码，它展示了哪些函数是函数表派发的，以及它们的标识符。由于struct类型仅使用静态派发，所以不会显示sil_vtable字样。

### 函数声明位置

函数声明位置的不同也会导致派发方式的不同。在Swift中，我们常常在extension里面添加扩展方法。根据我们之前总结的表格，通常extension中声明的函数都默认使用静态派发。

```
protocol MyProtocol {
    func testOfProtocol()
}

extension MyProtocol {
    func testOfProtocolInExtension() {}
}

class MyClass: MyProtocol {
    func testOfClass() {}
    func testOfProtocol() {}
}

extension MyClass {
    func testOfClassInExtension() {}
}

复制代码
```

我们分别在protocol和class中声明一个函数，再在其extension中声明一个函数; 最后让类实现协议的一个方法，转换成SIL代码后如下:

```
protocol MyProtocol {
  func testOfProtocol()
}

extension MyProtocol {
  func testOfProtocolInExtension()
}

class MyClass : MyProtocol {
  func testOfClass()
  func testOfProtocol()
  @objc deinit
  init()
}

extension MyClass {
  func testOfClassInExtension()
}

...

///sil_vtable
sil_vtable MyClass {
  #MyClass.testOfClass!1: (MyClass) -> () -> () : @$s4main7MyClassC06testOfC0yyF	// MyClass.testOfClass()
  #MyClass.testOfProtocol!1: (MyClass) -> () -> () : @$s4main7MyClassC14testOfProtocolyyF	// MyClass.testOfProtocol()
  #MyClass.init!allocator.1: (MyClass.Type) -> () -> MyClass : @$s4main7MyClassCACycfC	// MyClass.__allocating_init()
  #MyClass.deinit!deallocator.1: @$s4main7MyClassCfD	// MyClass.__deallocating_deinit
}

///sil_witness_table
sil_witness_table hidden MyClass: MyProtocol module main {
  method #MyProtocol.testOfProtocol!1: <Self where Self : MyProtocol> (Self) -> () -> () : @$s4main7MyClassCAA0B8ProtocolA2aDP06testOfD0yyFTW	// protocol witness for MyProtocol.testOfProtocol() in conformance MyClass
}


复制代码
```

我们可以很直观的看到，声明在协议或者类主体中的函数是使用函数表派发的; 而声明在扩展中的函数则是静态派发。

**值得注意的是: 当我们在protocol中声明一个函数，并且在protocol的extension中实现了它，而且没有其他类型重写该函数，那么在这种情况下，该函数就是直接派发，算是通用函数。**

### 指定派发

给函数添加关键字的修饰也能改变其派发方式。

#### final

添加了final关键字的函数无法被重写，使用直接派发，不会在vtable中出现。并且对Objc runtime不可见

#### dynamic

值类型和引用类型的函数均可添加dynamic关键字。在Swift5中，给函数添加dynamic的作用是为了赋予非objc类和值类型(struct和enum)动态性。我们来看如下代码:

```
struct Test {
    dynamic func test() {}
}

复制代码
```

我们赋予了test函数动态性。将其转换成SIL中间码后如下:

```
// Test.test()
sil hidden [dynamically_replacable] [ossa] @$s4main4TestV4testyyF : $@convention(method) (Test) -> () {
// %0                                             // user: %1
bb0(%0 : $Test):
  debug_value %0 : $Test, let, name "self", argno 1 // id: %1
  %2 = tuple ()                                   // user: %3
  return %2 : $()                                 // id: %3
} // end sil function '$s4main4TestV4testyyF'

复制代码
```

我们在第二行可以看到test函数多了一个“属性”: dynamically_replacable, 也就是说添加dynamic关键字就是赋予函数动态替换的能力。那什么是动态替换呢? 简而言之就是提供一种途径，比方说，可以将Module A中定义的方法，在Module B中动态替换，如下所示:

```
struct ModuleAStruct {

    dynamic func testModuleAStruct(){
        print("struct-testModuleAStruct")
    }
}



extension ModuleAStruct{
    @_dynamicReplacement(for: testModuleAStruct())
    func testModuleAStructReplacement() {
        print("extension-testModuleAStructReplacement")
    }

}

let foo = ModuleAStruct()
foo.testModuleAStruct()

///通过调用测试打印出来的是
extension-testModuleAStructReplacement


复制代码
```

**注意： 添加dynamic关键字并不代表对Objc可见。**

#### @objc

该关键字可以将Swift函数暴露给Objc运行时，但并不会改变其派发方式，依旧是函数表派发。举例如下:

```
class Test {
    @objc func test() {}
}


复制代码
```

SIL代码如下:

```
...

// @objc Test.test()
sil hidden [thunk] [ossa] @$s4main4TestC4testyyFTo : $@convention(objc_method) (Test) -> () {
// %0                                             // user: %1
bb0(%0 : @unowned $Test):
  %1 = copy_value %0 : $Test                      // users: %6, %2
  %2 = begin_borrow %1 : $Test                    // users: %5, %4
  // function_ref Test.test()
  %3 = function_ref @$s4main4TestC4testyyF : $@convention(method) (@guaranteed Test) -> () // user: %4
  %4 = apply %3(%2) : $@convention(method) (@guaranteed Test) -> () // user: %7
  end_borrow %2 : $Test                           // id: %5
  destroy_value %1 : $Test                        // id: %6
  return %4 : $()                                 // id: %7
} // end sil function '$s4main4TestC4testyyFTo'

...

sil_vtable Test {
  #Test.test!1: (Test) -> () -> () : @$s4main4TestC4testyyF	// Test.test()
  #Test.init!allocator.1: (Test.Type) -> () -> Test : @$s4main4TestCACycfC	// Test.__allocating_init()
  #Test.deinit!deallocator.1: @$s4main4TestCfD	// Test.__deallocating_deinit
}

复制代码
```

我们可以看到test方法依旧在“虚函数列表”中，证明其实函数表派发。如果希望test函数使用消息派发，则需要额外添加dynamic关键字。

#### @inline or static

@inline关键字顾名思义是想告诉编译器将此函数直接派发，但将其转换成SIL代码后，依旧是vtable派发。Static关键字会将函数变为直接派发。

## 编译器优化

Swift会尽可能的去优化函数派发方式。我们上文提到，当一个类声明了一个私有函数时，该函数很可能会被优化为直接派发。

## 派发总结

最后我们用一张图总结下Swift中的派发方式:



<img src="./images/函数派发4.png" alt="img" style="zoom:50%;" />

从上表可见，我们在类型的主体中声明的函数大都是函数表派发，这也是Swift中最为常见的派发方式；而扩展大都是直接派发；只有再添加了特定关键字后，如@objc, final, dynamic后，函数派发方式才会有所改变。除此之外，编译器可能将某些方法优化为直接派发。例如私有函数。


作者：JackMayx
链接：https://juejin.cn/post/6847009771845845006
来源：掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。


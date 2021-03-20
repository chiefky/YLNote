为文本字符串添加特性或者语法糖在各种编程语言中都很普遍。就拿大家都很熟悉的 C 语言举例，C 字符串本质是一个字符数组（characters array），但是每次输入字符串的时候不用输入 `['h','e','l','l','o']` ，直接打 `hello` 就可以了，因为这个操作编译器帮你做了。
 更高级的语言比如 Swift 处理字符串就不仅仅是当做字符数组了，String 是一个完整的类型，并且有各种特性。我们先来看一下 String 的一个特性：substring。

## 简单的看一下 String

首先粗略的了解一下字符串的实现。下面的代码来自标准库中 [String.swift](https://link.jianshu.com?t=https%3A%2F%2Fgithub.com%2Fapple%2Fswift%2Fblob%2Fmaster%2Fstdlib%2Fpublic%2Fcore%2FString.swift)：

```swift
public struct String {
  public var _core: _StringCore
}
```

当然也有一些其他初始化设置，不过在声明里只有这一个存储属性！秘密一定都在 [StringCore.swift](https://link.jianshu.com?t=https%3A%2F%2Fgithub.com%2Fapple%2Fswift%2Fblob%2Fmaster%2Fstdlib%2Fpublic%2Fcore%2FStringCore.swift) 里：



```swift
public struct _StringCore {
  public var _baseAddress: UnsafeMutableRawPointer?
  var _countAndFlags: UInt
  public var _owner: AnyObject?
}
```

在这个类型里还有很多其他东西，不过我们还是只关注存储属性：

- Base address — 一个指向内部存储的指针
- Count — 字符串长度，UInt 类型，在一个 64 位的系统中，意味着有 62（64 - 2） 位的空间可以表示长度。这是一个非常大的数字。所以字符串的长度不太可能溢出。
- Flags — 两个 bits 用来做标志。第一位表示是否被 _StringBuffer 持有；第二位表示编码格式是 ASCII 还是 UTF-16。

_StringCore 的真实情况比这里提到的要复杂的多，但是通过上面的内容可以让我们更容易理解字符串的一些信息：字符串的内部存储和存储的大小（underlying storage and size）。

## Substring

Swift 中要怎么创建一个 substring？最简单的方式就是通过下标从 string 取一段：



```swift
let str = "Hello Swift!"
let slice = str[str.startIndex..<str.index(str.startIndex, offsetBy: 5)]
// "Hello"
```

虽然很简单，但是代码看起来不太优雅。
 String 的索引不是直观的整型，所以截取时的位置索引需要利用 startIndex 和 `index(_:offsetBy:)`获取。如果是从字符串开始位置截取，可以省略掉 startIndex ：



```swift
let withPartialRange = str[..<str.index(str.startIndex, offsetBy: 5)]
// still "Hello"
```

或者用 collection 中的这个方法：



```swift
let slice = str.prefix(5)
// still "Hello"
```

要记住字符串也是 collection ，所以你可以用集合下的方法，比如 prefix()，suffix()， dropFirst() 等。

### Substring 的内部原理

substring 一个神奇的地方是他们重用了父 string 的内存。你可以把 substring 理解为父 string 的其中一段。



![img](/Users/tangh/yuki/ios_project/YLNote/YLNote/LocalFiles/markdown/images/substring_string.webp)

举个例子，如果从一个 8000 个字符的字符串中截取 100 个字符，并不需要重新初始化 100 个字符的内存空间。
 这也意味着你可能不小心就把父 string 的生命周期延长了。如果有一大段字符串，然后你只是截取了一小段，只要截取的小段字符串没有释放，大段的字符串也不会被释放。
 Substring 内部到底是怎么做到的呢？



```swift
public struct Substring {
  internal var _slice: RangeReplaceableBidirectionalSlice<String>
```

内部的 _slice 属性保存着所有关于父字符串的信息：



```swift
// Still inside Substring
internal var _wholeString: String {
  return _slice._base
}
public var startIndex: Index { return _slice.startIndex }
public var endIndex: Index { return _slice.endIndex }
```

计算属性 _wholeString（返回整个父字符串），startIndex 和 endIndex 都是通过内部的 _slice 返回。
 也可以看出 slice 是如何引用父字符串的。

### Substring 转换为 String

最后代码里可能有很多 substring，但是函数的参数类型需要的是 string。Substring 转换到 string 的过程也很简单：



```swift
let string = String(substring)
```

因为 substrings 和它的父字符串共享同一个内存空间，猜测创建一个新字符串应该会初始化一片新的存储空间。那么 string 的初始化到底过程是怎样的呢。



```swift
extension String {
  public init(_ substring: Substring) {
    // 1
    let x = substring._wholeString
    // 2
    let start = substring.startIndex
    let end = substring.endIndex
    // 3
    let u16 = x._core[start.encodedOffset..<end.encodedOffset]
    // 4A
    if start.samePosition(in: x.unicodeScalars) != nil
    && end.samePosition(in: x.unicodeScalars) != nil {
      self = String(_StringCore(u16))
    }
    // 4B
    else {
      self = String(decoding: u16, as: UTF16.self)
    }
  }
}
```

1. 创建一个对原有父字符串的引用
2. 获取 substring 在父字符串中的开始和结束位置
3. 获取 UTF-16 格式的 substring 内容。_core 是 _StringCore 的一个实例。
4. 判断匹配的 unicode 编码，生成一个新的字符串实例

把 substring 转换成 string 的步骤非常简单，但是你可能要考虑是不是一需要这样做。是不是进行 substring 操作的时候都要求类型是 string？如果对 substring 的操作都需要转成 string，那么轻量级的 substring 也就失去了意义。🤔

## StringProtocol

StringProtocol 上场！StringProtocol 真是面向协议编程的一个优秀代表。StringProtocol  抽象了字符串的常见功能，比如 `uppercased()`, `lowercased()`，还有 `comparable`、`collection` 等。String 和 Substring 都声明了 StringProtocol。
 也就是说你可以直接使用 `==` 对 substring 和 string 进行判等，不需要类型转换：



```swift
let helloSwift = "Hello Swift"
let swift = helloSwift[helloSwift.index(helloSwift.startIndex, offsetBy: 6)...]

// comparing a substring to a string 
swift == "Swift"  // true
```

也可以遍历 substring，或者从 substring 截取子字符串。
 在标准库里也有一小部分函数使用 StringProtocol 类型作为参数。比如把一个字符串转换为整型就是：`init(text: StringProtocol)`。
 虽然你可能不关心是 string 和 substring，但是使用 StringProtocol 作为参数类型，调用者就不用进行类型转换，对他们会友好很多。

## 总结

- 字符串还是那个常见的字符串。

- Substring 是字符串的一部分，和父字符串共享同一块内存空间，并且记录了自己的开始和结束位置。

- String 和 Substring 都声明实现了 StringProtocol。StringProtocol 包含了一个字符串的基本属性和功能。

  ![img](https:////upload-images.jianshu.io/upload_images/225849-800000c8958cbbca.png?imageMogr2/auto-orient/strip|imageView2/2/w/680/format/webp)

是不是觉得自己也可以自定义字符串类型，实现 StringProtocol ？



```swift
/// Do not declare new conformances to `StringProtocol`. Only the `String` and
/// `Substring` types in the standard library are valid conforming types.
public protocol StringProtocol
```

但是苹果爸爸表示了拒绝。


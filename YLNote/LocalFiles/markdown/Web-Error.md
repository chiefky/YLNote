在之前的版本中，Swift中Error与OC中NSError的关系就像上海的南京路与南京的上海路关系一样，那就是没有关系。
 我们先来看两者的区别。
 Error是一个实现ErrorProtocol枚举，对外能够获取的具体信息只有rawValue。



```swift
enum HomeworkError : Int, Error {
  case forgotten
  case lost
  case dogAteIt
}
```

但是我们知道NSError是有UserInfo和domain的：



```swift
throw NSError(code: HomeworkError.dogAteIt.rawValue,
              domain: HomeworkError._domain,
              userInfo: [ NSLocalizedDescriptionKey : "the dog ate it" ])
```

如果OC中的NSError桥接到Swift中，变成Error类型，那么获取NSError中的UserInfo信息也变成了一件头疼的事情，比如AVError：



```swift
catch let error as NSError where error._domain == AVFoundationErrorDomain 
&& error._code == AVFoundationErrorDomain.diskFull.rawValue {
  // okay: userInfo is finally accessible, but still weakly typed
}
```

很显然，解决方式就是提供一个方式可以让这两个类型可以无损的转换。

## LocalizedError

增加了一个LocalizedError协议。这个协议增加了errorDescription属性。如果Error同时实现这个协议，相比原来只有rawValue就增加了更多的信息。



```swift
extension HomeworkError : LocalizedError {
  var errorDescription: String? {
    switch self {
    case .forgotten: return NSLocalizedString("I forgot it")
    case .lost: return NSLocalizedString("I lost it")
    case .dogAteIt: return NSLocalizedString("The dog ate it")
    }
  }
}
```

这个协议同时还有三个属性：failureReason、helpAnchor、recoverySuggestion。

在NSError中也有对应的三个属性:



```objective-c
@property (readonly, copy) NSString *localizedDescription;

@property (nullable, readonly, copy) NSString *localizedFailureReason;

@property (nullable, readonly, copy) NSString *localizedRecoverySuggestion;
```

## CustomNSError

CustomNSError 用来桥接原来NSError中的code、domain、UserInfo。



```swift
public protocol CustomNSError : Error {

    /// The domain of the error.
    public static var errorDomain: String { get }

    /// The error code within the given domain.
    public var errorCode: Int { get }

    /// The user-info dictionary.
    public var errorUserInfo: [String : Any] { get }
}
```

如果想让我们的自定义Error可以转成NSError，实现CustomNSError就可以完整的as成NSError。

## RecoverableError

这次还给Error增加了RecoverableError协议。用来提示用户可以通过什么样的方式来处理这个Error。
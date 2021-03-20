# iOS - WKWebView Cookie

从UIWebview换到WKWebView之后，会发现管理Cookie是很麻烦事，经常出现 App自定义Cookie的值丢失 或 更新不及时 的情况。苹果iOS11之后也提供了WKWebView的Cookie API [WKHTTPCookieStore](https://developer.apple.com/documentation/webkit/wkhttpcookiestore?language=objc)，但是目前大多数App最低版本不可能设置最低版本到iOS11，所以我们只能想别的办法。

#### 什么是Cookie?

Cookie是一种早期的客户端存储机制，起初是针对服务端脚本设计使用的。以Cookie存储的数据，不论服务端是否需要，每次HTTP请求都会把这些数据传送到服务端。

Cookie是指Web浏览器存储的少量数据，同时它是与具体的Web页面或者站点相关。Cookie最早是设置为被服务端所用的，从最底层来看，作为http协议的一种拓展实现它。

Cookie数据会自动在Web浏览器和Web服务器之间传输，因此服务端脚本就可以读写存储在客户端的cookie值。

#### Cookie的属性

除了 name 与 value，Cookie其他属性：

**domain**：作用域名

> 举例： 设置domain为 bj.jiehun.com.cn,则在app.jiehun.com.cn 等子域名不会生效； 如设置domain为 .jiehun.com.cn，则在jiehun.com.cn 的所有子域名生效。 注意：IP地址特殊，直接设置原地址即可。

**path**：作用路径

> 举例： 如在 www.jiehun.com.cn，设置 path=/m，则只在 www.jiehun.com.cn/m 或 /m子目录下生效，如 www.jiehun.com.cn/app 就不会生效； 不设置默认为当前URL默认路径；我们通常会设置 “/” 代表所有目录。

**expires**：过期时间，格林威治时间 (GMT)字符串格式，设置过期时间后将会存储在一个文件直到过期。

```
// 打印当前时间
var date = new Date();
date.setTime(date.getTime());
console.log(date.toGMTString())；
// 打印结果为：Mon, 25 Feb 2019 15:35:03 GMT

// 设置cookie时间
document.cookie='name=value;expires=' + date.toGMTString();
复制代码
```

**max-age**：有效时长，单位秒。

```
// 设置 cookie 有效期 10秒
document.cookie='name=value;max-age=10;
复制代码
```

> Cookie默认的有效期很短暂，只能维持在Web浏览器的回话期间，一旦用户关闭浏览器，Cookie保存的数据就全部丢失。 如果想要延长Cookie的有效期，可以通过设置max-age或expires属性。一旦设置有效期，浏览器就会将Cookie数据存储在一个文件中，并且直到过了指定的有效期才会删除该文件。

**secure**: Bool值，是否为安全传输，如设置true，在Https或其他网络安全协议才会传输。

####演示 我们可以随便找一个浏览器，如Safari，打开后快捷键 command + alt + c 打开调试窗口：

<img src="/Users/tangh/yuki/ios_project/YLNote/YLNote/LocalFiles/markdown/images/cookie-1.png" alt="img" style="zoom:80%;" />



#### **读取Cookie**

```html
document.cookie
```

#### **保存Cookie**

```html
document.cookie='testName=testValue;path=/;max-age=60*60';
```

> 因为Cookie的名和值中不允许包含分号、逗号和空格，因此，在存储前可以采用全局函数 encodeURIComponent()对值进行编码。相应的，读取cookie值的时候采用decodeURIComponent() 函数解码。

#### **删除Cookie**

相同的名字随意设置一个值，并将max-age指定为0，相当于删除Cookie。

```html
document.cookie='testName=;domain=.jiehun.com.cn;path=/;max-age=0';
```

#### **Cookie的局限性**

个数限制300（现在已经可以超越），每个Cookie数据即名字和值的总量不能超过4KB。

## WKWebView 管理Cookie

上面了解了Cookie的基本知识，我们如何应用到iOS开发中？这里主要介绍WKWebview的使用方法。

因为JavaScript只能设置浏览器本地的cookie，往往客户端第一次请求由开发者创建Request对象请求：

```
[webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"url"]]];

复制代码
```

所以第一次请求需要手动设置请求头中的Cookie,可以继承WKWebView重写 loadRequest 方法，或者直接通过runtime Swizzling loadRequest 方法：

```
/**重写 loadRequest 方法，在请求头中添加自定义到cookie*/
- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request{
    
    NSMutableURLRequest *newRequeset = [request mutableCopy];
    
    // 自定义cookie值
    NSDictionary *customCookieDic =@{
                                     @"testName1":@"value1",
                                     @"testName2":@"value2"
                                     };
    
    // 拼接cookie字符
    NSString *cookie = @"";
    for (NSString *key in customCookieDic.allKeys) {
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@;",key,[customCookieDic objectForKey:key]];
        cookie = [cookie stringByAppendingString:keyValue];
    }
    
    // 设置到请求头
    [newRequeset setValue:cookie forHTTPHeaderField:@"Cookie"];
    
    return [super loadRequest:newRequeset];
}
复制代码
```

此时请求发出，服务端可以收到我们请求头中的cookie值，且请求头的cookie会自动保存到浏览器。

但我们发现请求头中自动保存到浏览器的cookie并不可靠，因为没有设置域名和目录的作用区，往往浏览器内二次跳转就会丢失，我们如何来保证浏览器的Cookie永不丢失？

#### [WKUserScript](https://developer.apple.com/documentation/webkit/wkuserscript?language=objc)

Webkit支持通过 WKUserScript 向网页中注入js脚本：

```
// 设置代码块
// @Source 脚本代码
// @injectionTime 执行时机，网页渲染前或渲染后
// @MainFrameOnly Bool值，YES只注入主帧，NO所有帧
WKUserScript *cookieInScript = [[WKUserScript alloc] initWithSource:@"js脚本代码"
                                                              injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                           forMainFrameOnly:NO];
// 插入脚本
[webview.configuration.userContentController addUserScript:cookieInScript];
复制代码
```

所以，保证Cookie不丢失可以通过此方法注入设置cookie js代码，在页面每次渲染都会设置，从而保证不会丢失。

每个cookie值可以设置为一个代码块，为了表示每个代码块的唯一，我们可以在注入脚本的最后添加 注释标示；其实就是一句注释掉的代码，来确定cookie代码块的唯一性，为以后删除某个代码块做铺垫。 举例设置某个cookie值的 js代码:

```
document.cookie ='cityId=10010;domain=.jiehun.com.cn;path=/';
// The cookie code  identified is cityId (代码块标示)
```

> 为了避免Cookie重复问题，可以直接把cookie设置在根域名。

##### 删除代码块

每次调用 addUserScript方法插入脚本块，代码块会保存在[WKUserContentController](https://developer.apple.com/documentation/webkit/wkusercontentcontroller?language=objc)类的 userScripts数组属性中：

```
@interface WKUserContentController : NSObject <NSSecureCoding>

/*! @abstract The user scripts associated with this user content
 controller.
*/
@property (nonatomic, readonly, copy) NSArray<WKUserScript *> *userScripts;
```

因为 userScripts 为只读权限，我们并不能修改，所以修改某个某一个cookie代码块的时候，需要先全部清除，再把不需要删除的代码块重新添加进去，这里就需要用到前面所说的代码块注释的唯一标示：

```
/**
 删除某个代码片段
 @param tag 片段标示，//The cookie code  identified is cookieName
 */
- (void)deleteUserSciptWithTag:(NSString *)tag {
    
    if (tag) {
        WKUserContentController *userContentController = webView.configuration.userContentController;
        NSMutableArray<WKUserScript *> *array = [userContentController.userScripts mutableCopy];
        int i = 0;
        BOOL isHave = NO;
        for (WKUserScript* wkUScript in userContentController.userScripts) {
            // 通过注释标示判断代码块是否为某个cookie
            if ([wkUScript.source containsString:tag]) {
                [array removeObjectAtIndex:i];
                isHave = YES;
                continue;
            }
            i ++;
        }
        
        if (isHave) {
            ///没法修改数组 只能移除全部 再将不需要删除的cookie重新添加
            [userContentController removeAllUserScripts];
            for (WKUserScript* wkUScript in array) {
                [userContentController addUserScript:wkUScript];
            }
        }
    }
}
```

通过这个Webkit可注入脚本的逻辑，我们基本可以保证使用cookie在WKWebview准确性和不丢失。

下面也写了一个Demo来演示如何通过一个代理方法来管理WKWebView所有Cookie： github地址：https://github.com/GaoGuohao/GGWkCookie

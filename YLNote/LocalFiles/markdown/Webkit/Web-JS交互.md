## OC 与 JS 交互六种方式总结

##### 序言

在 APP 中，免不了与 H5页面打交道，所以掌握 与 JS 交互就显的至关重要，本文总结了常见的与 JS 交互方式。

##### 一 UIWebView 拦截 URL

###### 1.1 JS 调用原生 OC

```objc
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * url = [request URL];
    if ([[url scheme] isEqualToString:@"firstclick"]) {  // firstClick://shareClick?title=分享的标题&content=分享的内容&url=链接地址&imagePath=图片地址
        NSArray *params = [url.query componentsSeparatedByString:@"&"];
        
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        NSMutableString *strM = [NSMutableString string];
        for (NSString *paramStr in params) {
            NSArray *dictArray = [paramStr componentsSeparatedByString:@"="];
            if (dictArray.count > 1) {
                NSString *decodeValue = [dictArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                decodeValue = [decodeValue stringByRemovingPercentEncoding];
                [tempDict setObject:decodeValue forKey:dictArray[0]];
                [strM appendString:decodeValue];
            }
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"这是OC原生的弹出窗" message:strM delegate:self cancelButtonTitle:@"收到" otherButtonTitles:nil];
        [alertView show];
        NSLog(@"tempDic:%@",tempDict);
        return NO;
    }
    return YES;
}

```

注意事项

> 1.JS中的firstClick,在拦截到的url scheme全都被转化为小写。
> 2.html 中需要设置编码，否则中文参数可能会出现编码问题。
> 3.JS用打开一个iFrame的方式替代直接用document.location的方式，以避免多次请求，被替换覆盖的问题

###### 1.2 OC 调用 JS

在 OC 原生中

```
NSString *jsStr = [NSString stringWithFormat:@"showAlert('%@')",@"这里是JS中alert弹出的message"];
[self.webView stringByEvaluatingJavaScriptFromString:jsStr];复制代码
```

> 注意：该方法会同步返回一个字符串，因此是一个同步方法，可能会阻塞主线程。

在 html 文件中

```
function showAlert(message) {
  alert(message);
}复制代码
```

早期的JS与原生交互的开源库很多都是用得这种方式来实现的，例如：PhoneGap、[WebViewJavascriptBridge](https://link.jianshu.com/?t=https://github.com/marcuswestin/WebViewJavascriptBridge)。

效果图

![img](https://user-gold-cdn.xitu.io/2019/3/9/1696097ee3b22e13?imageslim)

js_oc_intercept_url.gif

##### 二 WKWebView拦截 URL

###### 2.1 JS调用 OC

使用WKNavigationDelegate中的代理方法，拦截自定义的 URL 来实现 JS 调用 OC 方法。

```objc
#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"haleyaction"]) {
        [self handleCustomAction:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}复制代码
```

注意点

> 如果实现了这个代理方法，就必须得调用`decisionHandler`这个 block，否则会导致 app 奔溃。block 参数是一个枚举值，`WKNavigationActionPolicyCancel`代表取消加载，相当于UIWebView的代理方法return NO的情况；`WKNavigationActionPolicyAllow`代表允许加载，相当于UIWebView的代理方法中 return YES的情况。

关于如何区分执行不同的OC 方法，也与UIWebView的处理方式一样,通过URL 的host 来区分执行不同的方法：

```
#pragma mark - dealwith custom action

- (void)handleCustomAction:(NSURL *)URL {
    NSString *host = [URL host];
    
    if ([host isEqualToString:@"shareClick"]) {
        [self share:URL];
    } else if ([host isEqualToString:@"getLocation"]) {
        [self getLocation:URL];
    } else if ([host isEqualToString:@"setBGColor"]) {
        [self setBGColor:URL];
    } else if ([host isEqualToString:@"payAction"]) {
        [self payAction:URL];
    } else if ([host isEqualToString:@"shake"]) {
        [self shakeAction];
    } else if ([host isEqualToString:@"back"]) {
        [self goBack];
    }
}复制代码
```

###### 2.2 OC 调用 JS 方法

JS 调用OC 方法后，有的操作可能需要将结果返回给JS。这时候就是OC 调用JS 方法的场景。
WKWebView 提供了一个新的方法`evaluateJavaScript:completionHandler:`，实现OC 调用JS 等场景。

```
- (void)getLocation:(NSURL *)URL {
    // 获取位置信息
    NSLog(@"原生获取位置信息操作");
    
    // 将结果返回给 JS
    NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"广东省广州市白云区豪泉大厦"];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}复制代码
```

注意点

> `evaluateJavaScript:completionHandler:`没有返回值，JS 执行成功还是失败会在completionHandler 中返回。所以使用这个API 就可以避免执行耗时的JS，或者alert 导致界面卡住的问题。

运行结果



![img](https://user-gold-cdn.xitu.io/2019/3/9/1696097ee3ebcf1a?imageslim)

JS_OC_WK_URL.gif

##### 三 JavaScriptCore （UIWebView）

###### 3.1 JS 调用原生 OC

在iOS 7之后，apple添加了一个新的库JavaScriptCore，用来做JS交互，因此JS与原生OC交互也变得简单了许多。

首先导入JavaScriptCore库, 然后在OC中获取JS的上下文。

```
JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];复制代码
```

再然后定义好JS需要调用的方法，例如JS要调用share方法：
则可以在UIWebView加载url完成后，在其代理方法中添加要调用的share方法：

```
- (void)setupData {
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //定义好JS要调用的方法, share就是调用的share方法名
    context[@"share"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        NSMutableString *strM = [NSMutableString string];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal.toString);
            [strM appendString:jsVal.toString];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"这是OC原生的弹出窗" message:strM delegate:self cancelButtonTitle:@"收到" otherButtonTitles:nil];
            [alertView show];
        });
        
        
        NSLog(@"-------End Log-------");
    };
}复制代码
```

###### 3.2 OC 调用 JS

OC 调用 JS 方法有多种，首先介绍使用JavaScriptCore框架的方式。

- 方式一

使用JSContext 的方法`-evaluateScript`，可以实现 OC 调用 JS 方法

```
// 法一
- (void)transferJS {
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *textJS = @"showAlert('这里是JS中alert弹出的message')";
    [context evaluateScript:textJS];
}

// 法二
- (void)transferJS {
    NSString *textJS = @"showAlert('这里是JS中alert弹出的message')";
    [[JSContext currentContext] evaluateScript:textJS];
}复制代码
```

- 方式二
  使用 JSValue 的方法`-callWithArguments`，也可以实现 OC 调用 JS 方法

```
JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
[context[@"showAlert"] callWithArguments:@[@"这里是JS中alert弹出的message"]];复制代码
```

效果图



![img](https://user-gold-cdn.xitu.io/2019/3/9/1696097ee3d55394?imageslim)

js_oc_javaScriptCore.gif

##### 四 MessageHandler(WKWebView)

使用WKWebView的时候，如果想要实现JS调用OC方法，除了拦截URL之外，还有一种简单的方式。那就是利用WKWebView的新特性MessageHandler来实现JS调用原生方法。

###### 4.0 怎么使用MessageHandler？

创建`WKWebViewConfiguration`对象，配置各个API对应的MessageHandler。

> WKUserContentController对象可以添加多个scriptMessageHandler。

然后在界面即将显示的时候添加MessageHandler

```
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // addScriptMessageHandler 很容易导致循环引用
    // 控制器 强引用了WKWebView,WKWebView copy(强引用了）configuration， configuration copy （强引用了）userContentController
    // userContentController 强引用了 self （控制器）
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"ScanAction"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"Location"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"Share"];
}复制代码
```

需要注意的是addScriptMessageHandler很容易引起循环引用，导致控制器无法被释放，所以需要移除MessageHandler

```
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 因此这里要记得移除handlers
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"ScanAction"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"Location"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"Share"];
}复制代码
```

###### 4.1 实现协议方法 - JS调用 OC

这里实现了两个协议``，`WKUIDelegate`是因为我在JS中弹出了alert 。`WKScriptMessageHandler`是因为我们要处理JS调用OC方法的请求。

```
#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // message.body  --  Allowed types are NSNumber, NSString, NSDate, NSArray,NSDictionary, and NSNull.
    if ([message.name isEqualToString:@"ScanAction"]) {
        [self scanAction];
    } else if ([message.name isEqualToString:@"Location"]) {
        [self getLocation];
    } else if ([message.name isEqualToString:@"Share"]) {
        [self shareWithParams:message.body];
    }
}复制代码
```

`WKScriptMessage`有两个关键属性`name` 和 `body`。
因为我们给每一个OC 方法取了一个name，那么我们就可以根据name 来区分执行不同的方法。body 中存着JS 要给OC 传的参数。

关于参数body 的解析，我就举一个body中放字典的例子，其他的稍后可以看demo。
解析JS 调用OC 实现分享的参数：

```
- (void)shareWithParams:(NSDictionary *)params {
    if (![params isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *title = [params objectForKey:@"title"];
    NSString *content = [params objectForKey:@"content"];
    NSString *url = [params objectForKey:@"url"];
    
    // 在这里执行分享的操作
    NSLog(@"在这里执行分享的操作");
    
    // 将分享结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id result, NSError *error) {
        NSLog(@"%@----%@",result, error);
    }];
}复制代码
```

message.boby 就是JS 里传过来的参数。我们不同的方法先做一下容错性判断。然后正常取值就可以了。

###### 4.2 处理HTML中JS调用

下面只列举一个shareClick()方法，其他看Demo

```
// 传字典              
function shareClick(){
  window.webkit.messageHandlers.Share.postMessage({title:'测试分享的标题',content:'测试分享的内容',url:'http://www.baidu.com'});
}

function shareResult(channel_id,share_channel,share_url) {
    var content = channel_id+","+share_channel+","+share_url;
    asyncAlert(content);
    document.getElementById("returnValue").value = content;
}
            
function asyncAlert(content) {
    setTimeout(function(){
        alert(content);
    },1);
}复制代码
```

###### 4.3 OC调用JS

这里使用WKWebView 实现OC 调用JS方法与之前说的文章一样，通过
`- evaluateJavaScript:completionHandler:`

```
// 将分享结果返回给js
NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
[self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    NSLog(@"%@----%@",result, error);
}];复制代码
```

###### 4.4 使用MessageHandler的好处

- 1.在JS中写起来简单，不用再用创建URL的方式那么麻烦了。
- 2.JS传递参数更方便。使用拦截URL的方式传递参数，只能把参数拼接在后面，如果遇到要传递的参数中有特殊字符，如&、=、？等，必须得转换，否则参数解析肯定会出错。

------

效果图如下图所示

![img](https://user-gold-cdn.xitu.io/2019/3/9/1696097ee3ca73a6?imageslim)

JS_OC_WK_MessageHandler.gif

##### 五 WebViewJavascriptBridge(UIWebView)

详情看下面文章链接
[iOS下 JS 与 OC 互相调用(五) - UIWebView+WebViewJavascriptBridge](https://www.jianshu.com/p/810ac09bbf06)

##### 六 WebViewJavascriptBridge(WKWebView)

详情看下面文章链接
[iOS下 JS 与 OC 互相调用(六) - WKWebView+WKWebViewJavascriptBridge](https://www.jianshu.com/p/7b8af7aef4c8)

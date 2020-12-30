//
//  YLWebViewController.m
//  Demo20200420
//
//  Created by tangh on 2020/6/28.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "YLDefaultMacro.h"
#import "YLStudent.h"

//@import SDWebImage;

@interface YLWebViewController ()<WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) JSContext *jsContext;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, assign) NSUInteger buttonClicked;

@end

@implementation YLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupUI];
    
}

#pragma mark - UI
- (void)setupUI {
    WKUserContentController *controller = [[WKUserContentController alloc] init];

    /* 第一步：通过给userContentController添加WKUserScript，可以实现动态注入js。比如我先注入一个脚本，给每个页面添加一个Cookie */
    //添加自定义的cookie
    WKUserScript *newCookieScript = [[WKUserScript alloc] initWithSource:@"                document.cookie = 'LynkcoCookie=Lynkco;'" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    //添加脚本
    [controller addUserScript:newCookieScript];

    /* 第二步骤：注入一个脚本，每当页面加载，就会alert当前页面cookie，在OC中的实现 */
    //创建脚本
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:@"alert(document.cookie);" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    //添加脚本
    [controller addUserScript:cookieScript];
    
    // 添加消息脚本
    [controller addScriptMessageHandler:self name:@"choosePhoneContact"];

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = controller;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, YLSCREEN_WIDTH, 400) configuration:configuration];
    
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.backgroundColor = [UIColor whiteColor];
    self.actionButton.frame = CGRectMake(YLSCREEN_WIDTH / 2 - 50, 450, 100, 30);
    [self.actionButton setTitle:@"change color" forState:UIControlStateNormal];
    [self.view addSubview:self.actionButton];
    [self.actionButton addTarget:self action:@selector(butnAction) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark -WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"choosePhoneContact"]) {
        NSLog(@"choosePhoneContact");
    }
}


#pragma mark - action
- (void)butnAction {
    [self.webView evaluateJavaScript:@"window.webkit.messageHandlers.choosePhoneContact.postMessage(param)" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        NSLog(@"调用evaluateJavaScript异步获取title：%@", title);
    }];

//    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSLog(@"");
}

#pragma mark - native调js
/// 直接执行js代码
- (void)testEvaluateJS {
    /**
JSValue是JSContext执行后的返回结果，他可以是任何js类型（比如基本数据类型和函数类型，对象类型等），并且都有对象的方法转换为native对象
     */
    //定义一个js并执行函数
//    JSValue *exeFunction1 = [self.jsContext evaluateScript:@"function hi(){ return 'hi' }; hi()"];
//    //执行一个闭包js
//    JSValue *exeFunction2 = [self.jsContext evaluateScript:@"(function(){ return 'hi' })()"];
}

/// 通过js文件读取js代码并执行代码
- (void)testEvaluateJSFile {
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"js"];
//    NSString * script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    JSValue *constructor = [self.jsContext evaluateScript:script];
}

//注册js方法，然后在利用JSValue调用
- (void)testRegiestJSFunction {
    //注册一个函数
//    [self.jsContext evaluateScript:@"var hello = function(){ return 3000po }"];
//    //调用
//    JSValue *value1 = [self.jsContext evaluateScript:@"hello()"];
//
//    //注册一个匿名函数
//    JSValue *jsFunction = [self.jsContext evaluateScript:@" (function(){ return 'hello objc' })"];
//    //调用
//    JSValue *value2 = [jsFunction callWithArguments:nil];
}

- (void)testJSFunction {
    /**
//     fun1 得到一个匿名函数，通过callWithArguments方法执行这个block
//     */
//    JSValue *fun1 = [self.jsContext evaluateScript:@"(function(){ return 'mmmm' })"];
//    JSValue *value = [fun1 callWithArguments:nil];
}
#pragma mark - js 调 native
/** jsContext下标方法暴露js对象
 js调用native代码之前需要native先注册接口，使用jsContext[“方法名”]就可以注册，
 后面是一个闭包，闭包可以定义函数参数，也可以使用 [JSContext currentArguments] 方法获取到所有函数调用的参数
 */
// 注册一个objc方法给js调用
- (void)testRegisterNativeFun {
    __weak typeof(self) weakSelf = self;
    self.jsContext[@"log"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (JSValue *value in args) {
            [weakSelf helloWorld:value.toString];
        }
    };
    //使用js调用objc
    [self.jsContext evaluateScript:@"log('2020')"];
}

- (void)helloWorld:(NSString *)dateStr {
    NSLog(@"Hello world, %@",dateStr);
}

#pragma mark - 使用JSExprot协议去把objc复杂对象转换成JSValue并暴露给js对象
- (void)useJSExprot {
    YLStudent *p = [[YLStudent alloc]init];
    self.jsContext[@"person"] = p;
//    JSValue *value = [self.jsContext evaluateScript:@"person.whatYouName()"];
}

#pragma mark - 使用js 进行异常处理
- (void)testJSException {
    self.jsContext.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"%@", exception);
        con.exception = exception;
    };
}



#pragma mark - lazy
- (JSContext *)jsContext {
    if (!_jsContext) {
        _jsContext = [[JSContext alloc] init];
    }
    return _jsContext;
}

@end

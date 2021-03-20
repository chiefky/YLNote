//
//  YLWebBridgeController.swift
//  YLNote
//
//  Created by tangh on 2021/3/16.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
import WebKit

/// 使用方法
/**
 WKWebView不支持JavaScriptCore。此时我们可以使用WKWebView的WKScriptMessageHandler。
 
 1. 在原生代码中利用userContentController添加JS端需要调用的原生方法
 2. 实现WKScriptMessageHandler协议中唯一一个方法`didReceiveScriptMessage`
 3. 在该方法中根据message.name获取调用的方法名做相应的处理，通过message.body获取JS端传递的参数 （这一步OC就可以直接调用JS的方法了[wkwebview.evaluateJavaScript{}]）
 4.在JS端通过`window.webkit.messageHandlers.methodName(事先定好的名称).postMessage(['name','参数','age', 18])`给WK发送消息`didReceiveScriptMessage`这个方法会接收到，可以通过`message.body`获取传来的值。(这一步KJS调用OC方法[事先定好的名称])
 */
class YLMessageHandlerViewController: UIViewController {
    
    /// 销毁时需要移除messageHandler
    deinit {
        myWKWeb.configuration.userContentController.removeScriptMessageHandler(forName: "requestNativeThenCallBack")
        myWKWeb.configuration.userContentController.removeScriptMessageHandler(forName: "requestNative")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = YLTheme.main().backColor
        loadPage()
    }
    
    func loadPage() {
        guard let url = Bundle.main.url(forResource: "WKWebViewJSTest", withExtension: "html") else { return }
        let req = URLRequest(url: url)
        myWKWeb.load(req)
    }
    
    lazy var myWKWeb:WKWebView  = {
        
        /// 创建配置
        let config = WKWebViewConfiguration()
        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        let userContent = WKUserContentController()
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        userContent.add(self, name: "requestNativeThenCallBack")
        userContent.add(self, name: "requestNative")
        // 将UserConttentController设置到配置文件
        config.userContentController = userContent
        
        // 高端的自定义配置创建WKWebView
        let web = WKWebView(frame: .zero, configuration: config)
        view.addSubview(web)
        web.uiDelegate = self
        web.navigationDelegate = self
        web.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-300)
        }
        
        return web
    }()
    
}

extension YLMessageHandlerViewController:WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "requestNativeThenCallBack":
            // JS 唤醒 OC 在此处调用原生方法 或者 do something
            nativeFunction(receive: message)
        case "requestNative":
            nativeFunction()
        default:
            print("Undefined!!")
        }
    }
    
    /// js已唤醒native,执行native方法（带回调）
    /// - Parameter message: 截获message读取回调函数
    func nativeFunction(receive message: WKScriptMessage) {
        print(".......loading ......")
        print(".... request image url....")
        
        let imageUrl = "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3551434013,902303093&fm=26&gp=0.jpg";
        // 如果需要回调给JS数据继续下面
        guard let jsData = message.body as? NSDictionary,
            let jsfunction = jsData["method"] as? String else { return  }
        // 读取js function的字符串
        let dict = ["src":imageUrl,"name":"avatar url"]
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dict) {
            if let paramater = String(data: jsonData, encoding: .utf8) {
                //执行回调(OC调用JavaScript原生方法)
                let funcback = "(\(jsfunction)(\(paramater)))"
                myWKWeb.evaluateJavaScript(funcback) { (rseult, error) in
                    
                }
                
            }
        }
    }
    
    /// js已唤醒native,执行native方法（不带回调）
    func nativeFunction() {
        print("say hello")
        YLAlertManager.showAlert(withTitle: "Hello", message: "", actionTitle: "OK", handler: nil)
    }
}

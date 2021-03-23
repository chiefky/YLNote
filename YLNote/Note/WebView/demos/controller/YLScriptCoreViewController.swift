//
//  YLScriptCoreViewController.swift
//  YLNote
//
//  Created by tangh on 2021/3/18.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
import JavaScriptCore

class YLScriptCoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = YLTheme.main().backColor
        let label = UILabel()
        label.text = "1. native中调JS代码："
        label.font = UIFont.boldSystemFont(ofSize: 17)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(20)
        }

        let butn = UIButton(type: .custom)
        butn.setTitle("直接通过JSContext执行 JS 代码 ", for: .normal)
        butn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        butn.addTarget(self, action: #selector(testJSContextUsage), for: .touchUpInside)
        butn.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        butn.layer.cornerRadius = 10;
//        butn.contentView.image = #imageLiteral(resourceName: "mmco")
        butn.layer.masksToBounds = true

        view.addSubview(butn)
        butn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(label.snp.bottom).offset(10)
            make.height.equalTo(45)
        }
        
        loadPage()
    }
    
    func loadPage() {
        guard let url = Bundle.main.url(forResource: "UIWebViewJSTest", withExtension: "html") else { return }
        let req = URLRequest(url: url)
        myWeb.loadRequest(req)
    }
    
    // Swift调JS：1. 直接通过 JSContext 执行 JS 代码。
    @objc func testJSContextUsage() {

        guard let context = self.myWeb.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext else { return  }

        //JSContext()
        let result1: JSValue = context.evaluateScript("1 + 3")
        print(result1)  // 输出4
            
        // 定义js变量和函数
        context.evaluateScript("var num1 = 10; var num2 = 20;")
        context.evaluateScript("function multiply(param1, param2) { return param1 * param2; }")
            
        // 通过js方法名调用方法
        let result2 = context.evaluateScript("multiply(num1, num2)")
        print(result2 ?? "result2 = nil")  // 输出200
            
        // 通过下标来获取js方法并调用方法
        let squareFunc = context.objectForKeyedSubscript("multiply")
        let result3 = squareFunc?.call(withArguments: [10, 20]).toString()
        print(result3 ?? "result3 = nil")  // 输出200
        
        // 注入弹窗代码，并执行
        context.evaluateScript("function logFunction() { alert('页面显示内容与代码无关'); }")
        context.evaluateScript("logFunction()")
    }
    
    /// 2. 在Swift中通过JSContext注入模型，然后调用模型的方法
    /** 步骤：
     a.首先定义一个协议SwiftJavaScriptDelegate 该协议必须遵守JSExport协议
     b.然后定义一个模型 该模型实现SwiftJavaScriptDelegate协议 (这里注意，如果有更改 UI 的需求，那么需要回到主线程。因为调用不在主线程)
     c.然后使用WebView加载对应的网页，这里加载例子中的demo.html文件
     d.在webViewDidFinishLoad代理中将我们定义的模型注入到网页中，暴露给JS
     e.Swift与JS方法互相调用
     */
    func testJSContextModelUsage() {
        print("参考UIWebViewJSTest.html");
    }


    lazy var myWeb: UIWebView = {
        let web = UIWebView()
        web.delegate = self
        view.addSubview(web)
        web.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.right.bottom.equalToSuperview()
        }
        return web
    }()

}

extension YLScriptCoreViewController:UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        exportToJSAfterModelInjection()
    }
    
    /// 2.c 将我们定义的模型注入到网页中，暴露给JS
    func exportToJSAfterModelInjection(){
        
        let context = myWeb.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        let model = YLSwiftJavaScriptModel()
        model.controller = self
        model.webView = myWeb
        
        // 这一步是将SwiftJavaScriptModel模型注入到JS中，在JS中就可以通过WebViewJavascriptBridge调用我们暴露的方法了。
        context.setObject(model, forKeyedSubscript: "WebViewJavascriptBridge" as NSCopying & NSObjectProtocol)
        
        // 注册到网络Html页面 请设置允许Http请求
        let curUrl = self.myWeb.request?.url?.absoluteString  //WebView当前访问页面的链接 可动态注册
        context.evaluateScript(curUrl)
        context.exceptionHandler = { (context, exception) in
            print("exception：", exception as Any)
        }
    }
}

//
//  YLWebBridgeController.swift
//  YLNote
//
//  Created by tangh on 2021/3/16.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
import WebKit

class YLWebSchemeController: UIViewController {
    deinit {
        print("\(self)  " + #function);
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
        let web = WKWebView(frame: .zero)
        web.navigationDelegate = self
        web.uiDelegate = self
        view.addSubview(web)
        web.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-300)
        }
        return web
    }()
    
}

// WKNavigationDelegate用来监听网页的加载情况，包括是否允许加载，加载失败、成功加载等一些列代理方法。
extension YLWebSchemeController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
//        let scheme = url?.scheme ?? "scheme"
//        let query = url?.query ?? "query"
//        let host = url?.host ?? "host"
//        print(scheme,query,host)

        if url?.absoluteString.hasSuffix("js_native://alert") ?? false {
            schemeHandler()
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow);
        
       
        
    }
    
    func schemeHandler() {
        myWKWeb.evaluateJavaScript("showAlert('哈喽啊')") { (result, error) in
            if let err = error {
                print(err.localizedDescription)
            }

        }
    }
    
}

// UIDelegate用来控制WKWebView中一些弹窗的显示(alert、confirm、prompt)。
extension YLWebSchemeController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        YLAlertManager.showAlert(withTitle: "Hello", message: message, actionTitle: "OK", handler: nil)
        completionHandler()

    }
}


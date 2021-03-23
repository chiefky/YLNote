//
//  YLWebCookieViewController.swift
//  YLNote
//
//  Created by tangh on 2021/3/20.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
import WebKit

class YLWebCookieViewController: UIViewController {
    
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
        let paramater = "/oauth2/v2/authorize?access_type=offline&response_type=code&client_id=100253825&lang=zh-cn&redirect_uri=hms%3A%2F%2Fredirect_url&scope=https%3A%2F%2Fwww.huawei.com%2Fauth%2Faccount%2Fbase.profile+https%3A%2F%2Fsmarthome.com%2Fauth%2Fsmarthome%2Fskill+https%3A%2F%2Fsmarthome.com%2Fauth%2Fsmarthome%2Fdevices&state=state&display=mobile"
        let urlStr = "https://login.vmall.com" + paramater

        guard let cookieArray = YLCookieManager.updateCookies(myWKWeb) as? [HTTPCookie],
        let url = URL(string: urlStr)  else { return }

         var req = URLRequest(url: url)
         for cookie in cookieArray {
             let cookieDict = cookie.dictionaryWithValues(forKeys: [HTTPCookiePropertyKey.name.rawValue,HTTPCookiePropertyKey.value.rawValue,HTTPCookiePropertyKey.domain.rawValue,HTTPCookiePropertyKey.path.rawValue]) as [String:AnyObject]
             var cookieStr = ""
             for key in cookieDict.keys {
                 let value = key + "=" + ((cookieDict[key] as? String) ?? "")
                 cookieStr = cookieStr.appending(value)
             }
             req.addValue(cookieStr, forHTTPHeaderField: "Cookie")
         }

         // 跨域Cookie注入
         let newCookieDict = req.allHTTPHeaderFields
         let newCookieStr = "document.cookie =" + (newCookieDict?["Cookie"] ?? "")
         
         let userContentController = WKUserContentController()
         let cookieInScript = WKUserScript(source: newCookieStr, injectionTime: .atDocumentStart, forMainFrameOnly: false)
         
         userContentController.addUserScript(cookieInScript)
         myWKWeb.configuration.userContentController = userContentController
         let delayTime = DispatchTime.now() + 1
         
        
         DispatchQueue.main.asyncAfter(deadline: delayTime) {
             YLCookieManager.updateCookies(self.myWKWeb)
             _ = self.myWKWeb.load(req)

         }

    }
    
    lazy var myWKWeb:WKWebView  = {
        /// 创建配置
        let config = WKWebViewConfiguration()
        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        let userContent = WKUserContentController()
        // 将UserConttentController设置到配置文件
        config.userContentController = userContent
        
        let web = WKWebView(frame: .zero)
        web.navigationDelegate = self as WKNavigationDelegate
        web.uiDelegate = self as WKUIDelegate
        view.addSubview(web)
        web.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-300)
        }
        return web
    }()
    
    
    
}

extension YLWebCookieViewController: WKUIDelegate,WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("---: 页面开始加载。。。")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("---: 内容开始加载。。。")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("---: 页面加载失败，error:" + error.localizedDescription )
        let code = (error as NSError).code
        if (code == 101 || code == 102 || code == NSURLErrorUnsupportedURL || code == NSURLErrorServerCertificateUntrusted || code == NSURLErrorCancelled) {
               return ;
           }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("---: 重定向to：" + (webView.url?.absoluteString ?? ""))
        guard let url = webView.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        
        let tmpUrl = "hms://redirect_url?authorization_code=DQB6e3x9qjH7dks9yCjXCiE%2FYXJ7oTRrbMiHVNYs0o85FSmIaGzmZtGSkigQOpS9JMxDZWskocLI59sL43AzolhWx%2BeSHGc28P9nnhoWiZ6mGNMVjcjCPjDhIcUQp%2FsZ%2FQq%2Fs%2FQN4HY4uadnI0n5AmiQt95t7b4LgsJ3%2BKnvo9WSMpkIgLouUww4fiD%2FE5T9ls1j4xHeqCUEnnfkR8As3ni41FyfctaL120WZlNCuThJRhmdtQ7TMU6IdFF32AuwsEm1miKlg12CXR%2BiLMc%3D&state=state"
        
        
        if url.contains("authorization_code") {
            print("---: 重定向到 redirect_url成功")
            let code = navigationAction.request.url?.query?.components(separatedBy: "=")[1]
            
            if let range = code?.range(of: "&state") {
                let subCode = code?[range]
                let autnCode = subCode?.removingPercentEncoding
                showAlert(with: autnCode ?? "this is error")
            } else {
                print("---: 重定向失败")
            }
        }
        decisionHandler(.allow)
    }
    
    func showAlert(with code: String) {
        YLAlertManager.showAlert(withTitle: "授权成功", message: code, actionTitle: "OK") { (action) in
        }
    }
}

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
        guard let url = URL(string: "https://www.baidu.com") else { return }
        let req = URLRequest(url: url)
        _ = myWKWeb.load(req)
    }
    
    lazy var myWKWeb:YLWKWebView  = {
        /// 创建配置
        let config = WKWebViewConfiguration()
        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        let userContent = WKUserContentController()
        // 将UserConttentController设置到配置文件
        config.userContentController = userContent
        
        // 设置代码块
        // @Source 脚本代码
        // @injectionTime 执行时机，网页渲染前或渲染后
        // @MainFrameOnly Bool值，YES只注入主帧，NO所有帧
        let cookieInScript = WKUserScript(source: "cookie", injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        config.userContentController.addUserScript(cookieInScript) // 插入脚本

        let web = YLWKWebView(frame: .zero)
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
    
}

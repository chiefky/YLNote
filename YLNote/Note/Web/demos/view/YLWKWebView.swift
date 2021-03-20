//
//  YLWKWebView.swift
//  YLNote
//
//  Created by tangh on 2021/3/20.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
import WebKit

class YLWKWebView: WKWebView {

    override func load(_ request: URLRequest) -> WKNavigation? {
        var newRequest = request
        let cookieDict = ["name1":"张三",
                          "name2":"李四"]
        var cookie = ""
        for key in cookieDict.keys {
            let value = key + "=" + (cookieDict[key] ?? "")
            cookie = cookie.appending(value)
        }
        
        newRequest.setValue(cookie, forHTTPHeaderField: "Cookie")
        
        return super.load(newRequest)
        
    }
    

}

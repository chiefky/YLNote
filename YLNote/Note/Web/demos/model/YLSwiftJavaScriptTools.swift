//
//  YLSwiftJavaScriptTools.swift
//  YLNote
//
//  Created by tangh on 2021/3/18.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation
import JavaScriptCore

// 1. 定义协议SwiftJavaScriptDelegate 该协议必须遵守JSExport协议
@objc protocol YLSwiftJavaScriptDelegate: JSExport {
    
    // js调用App的返回方法
    func popVC()
    
    // js调用App的showDic。传递Dict 参数
    func showDic(_ dict: [String: AnyObject])
    
    // js调用App方法时传递多个参数 并弹出对话框 注意js调用时的函数名
    func showAlert(with title: String, message: String)
    
    // js调用App的功能后 App再调用js函数执行回调
    func callHandler(_ handleFuncName: String)
    
}

//2. 定义一个模型 该模型实现SwiftJavaScriptDelegate协议
/**
 定义了4个常用方法，在JS中可以通过Model调用这四个方法
 */
class YLSwiftJavaScriptModel: NSObject, YLSwiftJavaScriptDelegate {
    
    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    weak var webView: UIWebView?
    
    /// 返回上一页
    func popVC() {
        if let vc = controller {
            DispatchQueue.main.async {
                vc.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    /// 控制台输出信息
    /// - Parameter dict: dic
    func showDic(_ dict: [String: AnyObject]) {
        
        print("展示信息：", dict,"= = ")
        
        // 调起微信分享逻辑
    }
    
    /// 显示弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 内容
    func showAlert(with title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            self.controller?.present(alert, animated: true, completion: nil)
        }
    }
    
    /// 带回调函数的native函数,执行完callHandler之后,会回调js中的’handleFuncName‘方法
    /// - Parameter handleFuncName: js中的方法name（不需要带参数）
    func callHandler(_ handleFuncName: String) {
        guard let web = self.webView else {
            print("can't find web")
            return
        }
        let context = web.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext

        let jsHandlerFunc = context.objectForKeyedSubscript("\(handleFuncName)")
        let dict = ["name": "张三", "age": 18] as [String : Any]
        let _ = jsHandlerFunc?.call(withArguments: [dict])
        
    }
}

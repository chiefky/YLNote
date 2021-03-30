//
//  YLLoginViewController.swift
//  YLNote
//
//  Created by tangh on 2021/3/25.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

protocol LoginProtocol: class {
    func userLogin(name: String,password: String, completionHandler: (_ result: Bool,_ error: String?)->() ) -> Void
}

class YLLoginViewController: UIViewController {
    
    weak var loginDelegate: LoginProtocol?
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    var name: String {
        return usernameField.text ?? ""
    }
    
    var password: String {
        return passwordField.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /// 提交登录
    /// - Parameter sender: button
    @IBAction func clickLoginAction(_ sender: Any) {
        varifyInfo()
        if let delegate = self.loginDelegate {
            delegate.userLogin(name: name, password: password) { (result,error) in
                if result {
                    self.dismiss(animated: true) {
                        print("success ")
                    }
                } else {
                    let msg = error ?? "未知错误"
                    YLAlertManager.showToast(withMessage: msg, senconds: 2)
                }
            }
        }
    }
    
    /// 输入信息校验
    func varifyInfo() {
        guard name.count > 0 else {
            YLAlertManager.showToast(withMessage: "请输入用户名", senconds: 1)
            return
        }
        
        guard password.count > 0 else {
            YLAlertManager.showToast(withMessage: "请输入密码", senconds: 1)
            return
        }
        
    }
}

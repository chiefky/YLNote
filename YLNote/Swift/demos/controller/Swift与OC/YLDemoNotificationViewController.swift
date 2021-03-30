//
//  YLDemoNotificationViewController.swift
//  YLNote
//
//  Created by tangh on 2021/3/29.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
extension Notification.Name {
    static let skinChanged = Notification.Name("kSkinChanged")
}

class YLDemoNotificationViewController: YLDemoBaseViewController {
    deinit {
        print("\(self):\(#function)")
//        NotificationCenter
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @objc func test_notification() {
        changeThemeColor()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: .skinChanged, object: nil)
    }
    
    func changeThemeColor() {
        print("before: \(YLTheme.main().themeColor)")
        YLTheme.main().themeColor = UIColor.random()
        print("after: \(YLTheme.main().themeColor)")
    }
    
    @objc func refreshView() {
    }

}

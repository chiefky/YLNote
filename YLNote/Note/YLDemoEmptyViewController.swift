//
//  YLDemoEmptyViewController.swift
//  YLNote
//
//  Created by tangh on 2021/2/13.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLDemoEmptyViewController: UIViewController {
    deinit {
        // 返回内部类名
        print("deinit: \(object_getClassName(self))")

        // 返回应用程序名+类名
        print("deinit: \(NSStringFromClass(type(of: self)))")

        // 返回应用程序名+类名，并去掉应用程序名
        print("deinit: \(NSStringFromClass(type(of: self)).split(separator:".").last!)")

        // 返回应用程序名+类名+内存地址
        print("deinit: \(self)")

        // 返回应用程序名+类名+内存地址
        print("deinit: \(self.description)")

        // 返回类名
        print("deinit: \(type(of: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI();
        testBackBarButton()
    }
    
    

    // MARK: - func
    func setupUI() {
        self.view.backgroundColor = YLTheme.main().backColor
        self.title = "\(type(of: self))"
    }
    
    /// 返回按钮标题
    func testBackBarButton() {
        changeBackTitle(type: 0)
    }
    
    func changeBackTitle(type: Int) {
        switch type {
        case 1:
            // 方式一 单独页面设置返回按钮 ( 细节: 本界面上设置, 下个界面上显示)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: nil, action: nil)
        case 2:
            // 方式二 设置返回按钮的背景图片 （最好在APPDelegate中设置，影响全局）
            let barButton = UIBarButtonItem.appearance()
            barButton.setBackButtonBackgroundImage(UIImage(named:"swift"), for: .normal, barMetrics: .default) //tab_backButton_background 图片为导航栏背景色图片
        case 3:
            // 方式三 还是使用设置标题位置的方式（推荐）
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -100, vertical: 0), for:UIBarMetrics.default)
        default: break;
        }
    }
    
}

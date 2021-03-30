//
//  UIViewControllerTool.swift
//  YLNote
//
//  Created by tangh on 2021/3/25.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation

extension UIWindow {
    
    @objc static func pushToArticleVC(_ question: YLQuestion) {
        let artVC = YLArticleMDViewController()
        artVC.fileName = question.article.fileName
        artVC.title = question.title
        pushToVC(artVC)
    }

    @objc static func pushToDemoVC(with question: YLQuestion) {
        let demoClass = question.demo
        var myVC: UIViewController
        var typeClass: AnyClass?
        switch demoClass.style {
        case .swift: do {
            typeClass = NSClassFromString("YLNote" + "." + demoClass.className)
        }
        case .oc: do {
            typeClass = NSClassFromString(demoClass.className)
        }
        default: typeClass = NSClassFromString(demoClass.className)
        }
        guard let vcClass = typeClass as? UIViewController.Type else {             print("vcClass不能当做UIViewController")
            return
        }
        
        myVC =  demoClass.useXib ? vcClass.init(nibName: demoClass.className, bundle: nil) : vcClass.init()
        myVC.title = question.title
        pushToVC(myVC)
    }
    
    static func pushToVC(_ vc: UIViewController? ) {
        if let vc = vc {
            let currentVC = YLWindowLoader.getCurrentVC()
            if currentVC.navigationController != nil {
                UIView.setAnimationsEnabled(true)
                currentVC.navigationController?.pushViewController(vc, animated: true)
            } else {
                let naviVC = UINavigationController()
                UIView.setAnimationsEnabled(true)
                naviVC.pushViewController(vc, animated: true)
            }
        }
    }
    
}

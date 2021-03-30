//
//  YLDemoResponderViewController.swift
//  YLNote
//
//  Created by tangh on 2021/1/22.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
/**
 https://www.jianshu.com/p/53e03e558cbd
 https://blog.gocy.tech/2016/11/19/iOS-touch-handling/
 https://www.jianshu.com/p/2dda99a0e09a
 */
class YLDemoResponderViewController: UIViewController {

    
    var naviView: YLMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var top:CGFloat = 20.0,bottom:CGFloat = 0.0
        if #available(iOS 11.0, *) {
            top = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 20
            bottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        }
        
        naviView = YLMenuView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - top - bottom))
//        naviView.maxPopupHeight = 300;
        self.view.addSubview(naviView)
    }
    
    func setupUI() {
        self.view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        self.title = "UIResponder"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func didTap(_ tap: UITapGestureRecognizer) {
        NSLog("Background was tapped !")
    }
    
}

extension YLDemoResponderViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return naviView.shouldReceiveGesture(touch:touch)
    }
}

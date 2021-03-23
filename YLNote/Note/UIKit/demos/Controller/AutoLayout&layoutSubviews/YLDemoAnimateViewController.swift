//
//  YLDemoAnimateViewController.swift
//  YLNote
//
//  Created by tangh on 2021/1/26.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLDemoAnimateViewController: UIViewController {

    @IBOutlet weak var pinkHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pinkView: YLLayoutView!
    @IBOutlet weak var orangeView: YLLayoutView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "试验：layoutIfNeeded的用法"
        setupUI()
    }

    // MARK:func
    func setupUI() {
        self.blueView.frame = CGRect(x: self.pinkView.frame.origin.x + 90, y: self.pinkView.frame.origin.y, width: 50, height: 100);
        orangeView.addSubview(blueView)
        
        print("init:\(pinkView.frame),\(blueView.frame)")
    }
    
    func blueAnimation() {
        UIView.animate(withDuration: 2) {
            self.blueView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5);
            self.pinkView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5);
            print("animate:\(self.pinkView.frame),\(self.blueView.frame)")

//            let pre = self.blueView.frame;
//
//            self.blueView.frame = CGRect(x: pre.origin.x, y: pre.origin.y - 100, width: 50, height: 200)
        }
    }
    @IBAction func butnAction(_ sender: Any) {
        blueAnimation()
        return
        // 任何在等待update cycle中的更新现在都会被立即执行，Apple认为这是一个最佳实践。
        orangeView.layoutIfNeeded()
        // 修改高度的约束。
        UIView.animate(withDuration: 2) {
            self.pinkHeightConstraint.constant = 300;
            self.orangeView.layoutIfNeeded()
        }
    }
    
    // MARK:lazy
    lazy var blueView: YLLayoutView = {
        let blue = YLLayoutView()
        blue.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        return blue
    }()

}

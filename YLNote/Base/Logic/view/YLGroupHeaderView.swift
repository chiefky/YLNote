//
//  YLGroupHeaderView.swift
//  YLNote
//
//  Created by tangh on 2021/3/23.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
typealias ActionHandlerWithParamter = (_ indexpath: Int) -> Void
//typealias ActionHandler = (_ sender: YLGroupHeaderView) -> Bool
typealias ActionHandler = () -> Void

class YLGroupHeaderView: UITableViewHeaderFooterView {
    @objc var actionHandler: ActionHandler?

    @objc var unfoldStatus: Bool = false {
        didSet {
            arrowIcon.image = unfoldStatus ? #imageLiteral(resourceName: "arrow_unfold") : #imageLiteral(resourceName: "arrow_fold")
        }
    }
    
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet var myContentView: UIView!
    
    override var contentView: UIView {
        return myContentView
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
           
    @objc convenience init(reuseIdentifier:String, status:Bool) {
        self.init(reuseIdentifier: reuseIdentifier)
        unfoldStatus = status
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("YLGroupHeaderView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight];
        addSubview(contentView)
    }
    
    @objc var title: String = "" {
        didSet {
            headerButton.setTitle(title
                                  , for: .normal)
            headerButton.setTitleColor(#colorLiteral(red: 1, green: 0.5200329423, blue: 0, alpha: 1), for: .normal)
            headerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        }
    }
        
    @IBAction func clickAction(_ sender: Any) {
        guard let actionBlock = self.actionHandler
        else { return }
         actionBlock()
    }
    
// 旋转动画
//    func arrowAnimation(with unfold: Bool) {
//        //模拟动画，每次都重新刷新了因此仿射变化恢复到原始状态了
//        print("执行动画:" + unfold.description)
//        UIView.animate(withDuration: 0.3) {
//            if !unfold {
//                // 折叠
//                self.arrowIcon.transform = CGAffineTransform(rotationAngle: 0)
//            } else {
//                // 展开
//                self.arrowIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//
//            }
//        }
//    }
        

}

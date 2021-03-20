//
//  YLDynamicAnimatorViewController.swift
//  YLNote
//
//  Created by tangh on 2021/1/29.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
enum ActionType: String {
    case gravity = "重力"
    case snp = "捕获"
    case push = "推动"
    case attach = "吸附"
    case dynamic = "动力"
}

/**
 UIDynamicAnimator 是 iOS 7 引入的一个新类，可以创建出具有物理仿真效果的动画，具体提供了下面几种物理仿真行为：
 
 UIGravityBehavior：重力行为
 UICollisionBehavior：碰撞行为
 UISnapBehavior：捕捉行为
 UIPushBehavior：推动行为
 UIAttachmentBehavior：附着行为
 UIDynamicItemBehavior：动力元素行为
 
 初始化animator。初始化时需要Reference View，相当于力学参考系，只有当想要添加力学的UIView是Reference View的子视图时，UIDynamicAnimator才发生作用。
 */
class YLDynamicAnimatorViewController: UIViewController {
    let menuWidth:CGFloat = 150
    var menuShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI();
    }
    
    
    // MARK: - func
    func setupUI() {
        view.backgroundColor = YLTheme.main().backColor
        title = "试验:左滑显示级联菜单"
        self.edgesForExtendedLayout = [] // 从导航栏底下开始布局
        
        view.addSubview(aView)
        view.addSubview(bView)
        view.addSubview(cView)
        view.addSubview(centerView)
        centerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
        
        
        view.addSubview(self.menuView)
        menuView.frame = CGRect(x: YLScreenSize.width, y: 0, width: menuWidth, height: self.view.frame.size.height);
        menuView.datas = [ActionType.gravity.rawValue,ActionType.push.rawValue,ActionType.snp.rawValue,ActionType.attach.rawValue,ActionType.dynamic.rawValue]
        menuView.handleBlock = {[weak self] (index) in
            guard let type = self?.menuView.datas[index] else { return }
            self?.testAction(ActionType(rawValue: type))
        }
        
        // 添加左滑手势 显示
        let showMenuGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        showMenuGesture.direction = .left;
        view.addGestureRecognizer(showMenuGesture)
        
        // 添加右滑手势 隐藏
        let hideMenuGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        hideMenuGesture.direction = .right;
        view.addGestureRecognizer(hideMenuGesture)
    }
        
    @objc func handleSwipeGesture(_ gesture :UISwipeGestureRecognizer) {
        showMenu(show: gesture.direction == .left)
    }
    
    func showMenu(show:Bool) {
        menuShow = show
        self.animator.removeAllBehaviors()
        
        let gravityDirectionX = show ? -1.0 : 1.0
        let pushMagnitude:CGFloat = show ? -100 : 100
        let boudaryPointX = show ? YLScreenSize.width - menuWidth : YLScreenSize.width + menuWidth // 边界位置
        let boudaryPointy = self.tabBarController?.tabBar.frame.origin.y ?? 20.0
        /// 重力行为
        let gravityBehavior = UIGravityBehavior(items: [self.menuView])
        gravityBehavior.gravityDirection = CGVector(dx: gravityDirectionX, dy: 0)
        self.animator.addBehavior(gravityBehavior)
        
        /// 碰撞行为
        let collisionBehavior = UICollisionBehavior(items: [self.menuView])
        collisionBehavior.addBoundary(withIdentifier: NSString("menuBoundary"), from: CGPoint(x: boudaryPointX, y: 20), to: CGPoint(x: boudaryPointX, y: boudaryPointy))
        self.animator.addBehavior(collisionBehavior)

        /// 推动行为
        let push = UIPushBehavior(items: [self.menuView], mode:.instantaneous) // UIPushBehaviorModeInstantaneous表示施加瞬时力，即一个冲量；UIPushBehaviorModeContinuous表示施加连续的力。
        push.magnitude = pushMagnitude;
        self.animator.addBehavior(push)
        
        /// 动力（弹力）行为
        let dynamic = UIDynamicItemBehavior(items: [self.menuView])
        dynamic.elasticity = 0.4 // 默认值为0，范围是0到1.0，0表示没有弹性，1.0表示完全弹性碰撞
        self.animator.addBehavior(dynamic)
    }
    
    func testAction(_ type: ActionType?) {
        if menuShow {
            showMenu(show: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            switch type {
            case .gravity: self.testGravity()
            case .push: self.testPush()
            case .attach: self.testAttach()
            case .snp: self.testSnap()
            case .dynamic: self.testDynamic()
            case .none:
                print("action is undefined")
            }
        }
    }
    
     func testGravity() {
        self.animator.removeAllBehaviors()
        /// 重力行为
        let gravityBehavior = UIGravityBehavior(items: [self.cView])
        self.animator.addBehavior(gravityBehavior)
        gravityBehavior.action = {
            print("bView: \(self.bView.frame)")
        }
        
        /// 碰撞行为
        let collisionBehavior = UICollisionBehavior(items: [self.cView])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true //把reference view作为碰撞边界。默认为NO。
        self.animator.addBehavior(collisionBehavior)
                
        /// 动力元素行为 (弹力碰撞)
        let dynamic = UIDynamicItemBehavior(items: [self.cView])
        dynamic.elasticity = 0.2 // 默认值为0，范围是0到1.0，0表示没有弹性，1.0表示完全弹性碰撞
        self.animator.addBehavior(dynamic)
    }
    
    /// 捕捉
    func testSnap() {
        
    }
    
    /// 吸附
    /**吸附主要发生在：元素与锚点、元素与元素之间。
    当元素与锚点连接，元素的运动依赖于锚点。
    当元素与元素连接，两个元素的运动彼此影响。
    有的吸附行为支持两个元素和一个锚点。

    除此之外，吸附还分为：刚性吸附和弹性吸附。
    刚性吸附就好像两个物体间使用固定的杆连接，运动时之间的距离不变；
    而弹性吸附就好像两个物体间使用橡皮筋连接，运动时两者之间的距离会发生弹性形变。
 */
    func testAttach() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.animator.removeAllBehaviors()
//            let attach = UIAttachmentBehavior(item: self.cView, attachedToAnchor: CGPoint(x: 175, y: 250))
            let attach = UIAttachmentBehavior(item: self.centerView, attachedTo: self.cView)
            attach.length = 10;
            self.animator.addBehavior(attach)
        }
    }
    
    /// 推动
    func testPush() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.animator.removeAllBehaviors()
            let pushBehavior = UIPushBehavior(items: [self.aView,self.bView], mode: .instantaneous)
            pushBehavior.setTargetOffsetFromCenter(UIOffset(horizontal: -25, vertical: 0), for: self.aView) // 作用力中心偏移量设置
            pushBehavior.pushDirection = CGVector(dx: 1, dy: 1) // 推力矢量的方向
            pushBehavior.magnitude = 0.1 // 默认值为nil，没有任何力量。当设置一个负值，力的方向改变。
            self.animator.addBehavior(pushBehavior)
        }
    }
    
    func testDynamic() {
        
    }
    
    func addToSuper(_ sendder:UIView) {
        if sendder.superview == nil {
            view.addSubview(sendder)
        }
    }
    
    //MARK: lazy
    lazy var aView: YLTestView = {
        let view = YLTestView(frame: CGRect(x: 20, y: 10, width: 40, height: 40))
        view.layer.cornerRadius = 20;
        view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        view.addCorner(.allCorners, radius: 20)

        view.centerText = "A"
        return view
    }()
    
    lazy var bView: YLTestView = {
        let view = YLTestView(frame: CGRect(x: 20, y: 50, width: 40, height: 40))
        view.addCorner(.allCorners, radius: 20)
        view.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        view.centerText = "B"
        return view
    }()
    
    lazy var menuView: YLSlipMenuView = {
        let view = YLSlipMenuView()
        view.backgroundColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 0.7);
        
        return view
    }()
    
    lazy var animator: UIDynamicAnimator = {
        let ani = UIDynamicAnimator(referenceView: view)
        return ani
    }()
    
    lazy var cView: YLTestView = {
        let view = YLTestView(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        view.addCorner(.allCorners, radius: 25)
        view.layer.cornerRadius = 25;
        view.center = CGPoint(x: 125, y: 125)
        view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)

        view.centerText = "c"
        return view
    }()
    
    lazy var centerView: UIView = {
        let point = UIView()
        point.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.04040826857, alpha: 1)
        point.layer.cornerRadius = 5
        return point
    }()
}

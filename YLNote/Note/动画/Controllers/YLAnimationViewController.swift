//
//  YLAnimationViewController.swift
//  YLNote
//
//  Created by tangh on 2021/1/28.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
import SnapKit

enum AnimationType:String {
    case simple = "简单动画（UIView Animation）"
    case key = "关键帧动画（animateKeyframesWithDuration:）"
    case transform = "仿射动画（CGAffineTransform）"
    
    case cabasic = "基本动画（CABasicAnimation）"
    case cakey = "关键帧动画（CAKeyframeAnimation）"
    case group = "组动画（CAAnimationGroup)"
    case transition = "切换动画（CATransition）"
    
    case displaylink = "计时器动画(CADisplayLink)"
    case dynamicAnimator = "仿真效果动画(UIDynamicAnimator)"
    case emitterLayer = "粒子动画(CAEmitterLayer)"
    case test = "旋转动画test"
}

class YLAnimationViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    let kCellReuseIdentifier = "YLAnimationViewControllerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(#function):\(self.view.frame)")
        setupUI();
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("\(#function):\(self.view.frame)")
    }
        
    // MARK: - func
    func setupUI() {
        self.edgesForExtendedLayout = [] // 从导航栏底下开始布局
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: kCellReuseIdentifier)
        view.addSubview(self.aView)
        
        self.aView.addSubview(self.bView)
        self.bView.frame = CGRect(x: 20, y: 20, width: 80, height: 80)
    }
    
    
    func testAnimation(type: AnimationType) {
        func testSimple() {
            //第一个参数是动画的持续时间，第二个参数是一个 block，在 animations block 中对 UIView 的属性进行调整，设置 UIView 动画结束后最终的效果，iOS 就会自动补充中间帧，形成动画。
            UIView.animate(withDuration: 2) {
                let pre = self.aView.frame
                self.aView.frame = CGRect(origin: pre.origin, size: CGSize(width: 180, height: 180))
            }
        }
        
        func testTransform() {
            UIView.animate(withDuration: 3, delay: 0.1, options: .curveEaseIn, animations: {
                self.aView.transform = CGAffineTransform(rotationAngle: 0.5) //CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) { (res) in
                print("res:\(res)")
            }
        }
                
        func testKey() {
            /**这个例子添加了三个关键帧，在外面的 animateKeyframesWithDuration 中我们设置了持续时间为 3.0 秒，这是真实意义上的时间，里面的 startTime 和 relativeDuration 都是相对时间。以第一个为例，startTime 为 0.0，relativeTime 为 0.3，这个动画会直接开始，持续时间为 3.0 X 0.3 = 1.0 秒，下面第二个的开始时间是 0.3，正好承接上一个结束，第三个同理，这样三个动画就变成连续的动画了。*/
            UIView.animateKeyframes(withDuration: 3, delay: 0, options: .calculationModeLinear, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                    self.aView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3) {
                    self.aView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                    self.aView.transform = CGAffineTransform(rotationAngle: 2)
                }

            }) { (res) in
                print("res:\(res)")
            }
        }
        
        func testCABasic() {
            let basicVC = YLBasicAnimateViewController()
            self.navigationController?.pushViewController(basicVC, animated: true)
        }
        
        /// 同 UIView 中的类似，CALayer 层也提供了关键帧动画的支持，CAKeyFrameAnimation 和 CABasicAnimation 都继承自 CAPropertyAnimation，因此它有具有上面提到的那些属性，此外，CAKeyFrameAnimation 还有特有的几个属性。
        func testCAKey() {
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation") //在这里@"transform.rotation"==@"transform.rotation.z"
            let value1 = -Double.pi/180*4;
            let value2 = Double.pi/180*4;
            let value3 = -Double.pi/180*4;
            animation.values = [value1,value2,value3];
            animation.keyTimes = [0.0, 0.5, 1.0];
            animation.repeatCount = MAXFLOAT;
            self.aView.layer.add(animation, forKey: "shakeAnimation")
        }
        
        /// 使用 path 属性可以设置一个动画的运动路径，注意 path 只对 CALayer 的 anchorPoint 和position 属性起作用，另外如果你设置了 path ，那么 values 将被忽略。
        func testCAkey_path() {
            let animation = CAKeyframeAnimation(keyPath: "position")

            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 100))
            animation.path = path.cgPath;
            animation.duration = 2.0;
            self.bView.layer.add(animation, forKey: "pathAnimation")

        }
        
        func testCAgroup() {
            let group = CAAnimationGroup()
            group.duration = 10
            let animation1 = CABasicAnimation(keyPath: "transform.scale")
            animation1.toValue = 0.5
            animation1.duration = 5
            
            let animation2 = CABasicAnimation(keyPath: "position.x")
            animation2.toValue = 300
            animation2.duration = 5

            group.animations = [animation1,animation2]
            self.aView.layer.add(group, forKey: nil)
        }
        
        func testCATranstion() {
            let animation = CATransition()
            animation.duration = 2
            animation.type = .push
            self.aView.layer.add(animation, forKey: nil)
            self.aView.backgroundColor = .random()
        }
        
        func testDisplayLink() {
            let vc = YLDisplayLinkViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        func testDynamicAnimator() {
            let vc = YLDynamicAnimatorViewController()
            self.navigationController?.pushViewController(vc, animated: true)

//            let animation = UIDynamicAnimator(referenceView: self.view)
//            let gravityBehavior = UIGravityBehavior(items: [aView])
//            animation.addBehavior(gravityBehavior)
//            let collisionBehavior = UICollisionBehavior(items: [aView])
//            collisionBehavior.translatesReferenceBoundsIntoBoundary = true
//            animation.addBehavior(collisionBehavior)
        }

        func testEmitterLayer() {
            print("testEmitterLayer")
        }

        func testDemo() {
            let vc = YLDemoTestAniViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        switch type {
        case .simple: testSimple()
        case .transform: testTransform()
        case .key: testKey()
        case .cabasic: testCABasic()
        case .cakey: testCAkey_path()
        case .group: testCAgroup()
        case .transition: testCATranstion()
        case .displaylink: testDisplayLink()
        case .dynamicAnimator: testDynamicAnimator()
        case .emitterLayer: testEmitterLayer()
        case .test: testDemo()
        }
    }
    
    
    lazy var aView: YLTestView = {
        let view = YLTestView(frame: CGRect(x: 10, y: 10, width: 150, height: 150))
        view.backgroundColor = .systemPink
        view.text = "a"
        return view
    }()
    
    lazy var bView: YLTestView = {
        let view = YLTestView()
        view.backgroundColor = .blue
        view.text = "b"
        return view
    }()
    
    lazy var viewAnimations: [AnimationType] = {
        
        return [.simple,.key,.transform]
    }()
    
    lazy var layerAnimations: [AnimationType] = {
        
        return [.cabasic,.cakey,.group,.transition]
    }()

    lazy var otherAnimations: [AnimationType] = {
        
        return [.test,.displaylink,.dynamicAnimator,.emitterLayer]
    }()
    
    var animationDatas: [[AnimationType]] {
        return [viewAnimations,layerAnimations,otherAnimations]
    }
    
    var animationTitles: [String] {
        return ["UIView动画","CALayer动画","other"]
    }


}

extension YLAnimationViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return animationTitles.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        let label = UILabel()
        label.frame = CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: YLScreenSize.width - 20, height: 20))
        header.addSubview(label)
        label.text = animationTitles[section]
        label.textColor = YLTheme.main().themeColor

        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datas = animationDatas[indexPath.section];
        guard indexPath.row < datas.count else { return UITableViewCell() }
        let data = datas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = data.rawValue
        cell.textLabel?.textColor = YLTheme.main().subTextColor
        cell.textLabel?.font = YLTheme.main().textFont
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = animationDatas[section]
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let datas = animationDatas[indexPath.section];
        guard indexPath.row < datas.count else { return }
        let data = datas[indexPath.row]
        print("点击了：\(data.rawValue)")
        testAnimation(type: data)
    }
    
}

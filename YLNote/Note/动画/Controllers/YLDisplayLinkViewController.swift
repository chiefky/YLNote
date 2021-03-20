//
//  YLDisplayLinkViewController.swift
//  YLNote
//
//  Created by tangh on 2021/1/29.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLDisplayLinkViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.displayLink.invalidate()
    }
    
    // MARK: - func
    func setupUI() {
        view.backgroundColor = YLTheme.main().backColor
        title = "DisplayLink"
        self.edgesForExtendedLayout = [] // 从导航栏底下开始布局
        view.addSubview(self.aView)
        
        self.butn.addTarget(self, action: #selector(testAnimation), for: .touchUpInside)
        view.addSubview(self.butn)
        butn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-30)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }
        
        view.addSubview(self.waveV)

    }
    
    @objc func testAnimation() {
        testAnimationWeel();
    }
    
    func testAnimationWeel() {
                if #available(iOS 10.0, *) {
            self.displayLink.preferredFramesPerSecond = 60
        } else {
            self.displayLink.frameInterval = 1;
        }
        
        self.displayLink.add(to: RunLoop.current, forMode: .common)

    }
    
    
    @objc func transformAnimation() {
        self.aView.transform = self.aView.transform.rotated(by: CGFloat( Double.pi / 18));
    }
    
    lazy var aView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        view.image = #imageLiteral(resourceName: "wheel");
        return view
    }()

    lazy var waveV: YLWaveView = {
        let v = YLWaveView(frame: CGRect(x: 0, y: 300, width: YLScreenSize.width, height: 100))
        return v
    }()
    
    lazy var butn: UIButton = {
        let butnn = UIButton(type: .custom)
        butnn.setTitle("显示动画", for: .normal)
        butnn.setTitleColor(.systemPink, for: .normal)
        return butnn
    }()
    
    lazy var displayLink: CADisplayLink = {
        let dis = CADisplayLink(target: self, selector: #selector(transformAnimation))
        return dis
    }()
}

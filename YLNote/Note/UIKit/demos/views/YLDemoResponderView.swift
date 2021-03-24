//
//  YLDemoResponderView.swift
//  YLNote
//
//  Created by tangh on 2021/3/23.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLDemoResponderView: UIView {

    var maxPopupHeight:CGFloat = 300.0
    
    var items: [String] =  ["abc","def","hij","aaaa","bbbb", "dddd","????"] {
        didSet {
            table.reloadData()
        }
    }
    let reusedId = "kYLDemoResponderView"
    var buttonSize = CGSize(width: 32, height: 32)
    let controlButtonPadding = CGPoint(x: 11, y: 11)
    let singleDuration : TimeInterval = 0.5
    let durationBetween : TimeInterval = 0.08
    let tableUpDuration : TimeInterval = 0.46
    let tableDownDuration : TimeInterval = 0.8

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initalUI() {
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: reusedId)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.frame != CGRect.zero {
            reloadAllSubuViews()
        }
    }
    
    func reloadAllSubuViews() {
        self.table.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
        
        self.controlButton.snp.remakeConstraints { (make) in
            make.left.equalTo(20)
            make.size.equalTo(buttonSize)
            make.bottom.equalTo(self.table.snp.top)
        }
    }
    
    //MARK: - Actions
    
    @objc func controlButtonTapped(){
        let goingToOpen = !self.table.transform.isIdentity
        if goingToOpen {
            animateTableShow()
        }else{
            animateTableClose()
        }
    }
        
    lazy var table: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.rowHeight = 44;
        tab.backgroundColor = .systemPink
        tab.dataSource = self
        tab.delegate = self
        self.addSubview(tab)
        return tab
    }()
    
    lazy var controlButton: UIButton = {
        let butn = UIButton(type: .custom)
        butn.addTarget(self, action: #selector(self.controlButtonTapped), for: .touchUpInside)
        butn.backgroundColor = UIColor.red
        butn.layer.cornerRadius = buttonSize.width / 2
        butn.layer.shadowColor = UIColor.black.cgColor
        butn.layer.shadowOpacity = 0.3
        butn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        butn.layer.shadowRadius = 1
        self.addSubview(butn)
        
        
        return butn
    }()

    lazy var arrowLayer: CALayer = {
        let arrowLayer = CAShapeLayer.cleanLayer()
        arrowLayer.frame = self.controlButton.layer.bounds
        arrowLayer.strokeColor = UIColor.darkGray.cgColor
        arrowLayer.lineWidth = 2
        arrowLayer.path = arrowPath().cgPath
        self.controlButton.layer.addSublayer(arrowLayer)
        return layer
    }()
    
    func arrowPath() -> UIBezierPath{
        let arrowLen = buttonSize.width * 0.42
        let arrowHeight = buttonSize.height * 0.18
        
        let path = UIBezierPath()
        
        let start = CGPoint(x: (buttonSize.width - arrowLen)/2, y: buttonSize.height/2 + arrowHeight/3)
        
        path.move(to: start)
        path.addLine(to: CGPoint(x: start.x + arrowLen/2, y: start.y - arrowHeight))
        path.addLine(to: CGPoint(x: start.x + arrowLen, y: start.y))
        
        return path
        
    }
    

}

extension YLDemoResponderView: UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        NSLog("Select Table : \(indexPath.row) with content : \(String(describing: items[indexPath.row]))")
    }
    
    //MARK: - DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusedId)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: reusedId)
        }
        
        
        cell.backgroundColor = .clear
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    
}

//MARK : - Animation
extension YLDemoResponderView {
    
    fileprivate func animateTableShow(){
        for cell in self.table.visibleCells {
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: 0, y: self.table.bounds.height)
        }
        let buttonAnimDuration = self.tableUpDuration/1.05
        let buttonAnimator = UIViewPropertyAnimator(duration: buttonAnimDuration, controlPoint1: CGPoint(x:0.14,y:0.6), controlPoint2:  CGPoint(x:0.47,y:1.05), animations: {
            
            self.controlButton.transform = CGAffineTransform(translationX: 0, y: -(self.controlButton.frame.midY - (self.bounds.height - self.maxPopupHeight)) )
        })
        buttonAnimator.startAnimation()
       
        let arrowAnim = YLAnimationHelper.animation(keyPath: "transform.rotation", from: 0, to: CGFloat.pi, duration: buttonAnimDuration)
        self.arrowLayer.transform = CATransform3DMakeRotation(-CGFloat.pi, 0, 0, 1)
        self.arrowLayer.add(arrowAnim, forKey: nil)
        let tableAnimator = UIViewPropertyAnimator(duration: self.tableUpDuration, controlPoint1: CGPoint(x:0.14,y:0.6), controlPoint2:  CGPoint(x:0.47,y:1.05), animations: {
            self.table.transform = .identity
        })
        
        
        let cellAnimationDelay = tableUpDuration * 0.15
        tableAnimator.startAnimation(afterDelay: 0.15)
        
        
        for (idx ,cell) in self.table.visibleCells.enumerated(){
            let positionAnimator = UIViewPropertyAnimator(duration: self.singleDuration, controlPoint1: CGPoint(x:0.14,y:0.6), controlPoint2:  CGPoint(x:0.47,y:1.05), animations: {
                
                cell.transform = .identity
            })
            
            positionAnimator.startAnimation(afterDelay: cellAnimationDelay + Double(idx) * self.durationBetween)
            
            let alphaAnimator = UIViewPropertyAnimator(duration: self.singleDuration, controlPoint1: CGPoint(x:0.6,y:0.3), controlPoint2:  CGPoint(x:0.95,y:0.8), animations: {
                
                cell.alpha = 1
            })
            
            alphaAnimator.startAnimation(afterDelay: cellAnimationDelay +  Double(idx + 1) * self.durationBetween)
            
        }
        
    }
    
    
    fileprivate func animateTableClose(){
        let buttonAnimDuration = self.tableDownDuration / 1.3
        
        let buttonAnimator = UIViewPropertyAnimator(duration: buttonAnimDuration,  controlPoint1: CGPoint(x:0.1,y:0.7), controlPoint2:  CGPoint(x:0.22,y:1), animations: {
            
            self.controlButton.transform = .identity
        })
        
        buttonAnimator.startAnimation()
        
        let arrowAnim = YLAnimationHelper.animation(keyPath: "transform.rotation", from:  CGFloat.pi, to: 0, duration: buttonAnimDuration)
        
        self.arrowLayer.transform = CATransform3DIdentity
        
        self.arrowLayer.add(arrowAnim, forKey: nil)
        
        
        let tableAnimator = UIViewPropertyAnimator(duration: self.tableDownDuration, controlPoint1: CGPoint(x:0.1,y:0.7), controlPoint2:  CGPoint(x:0.22,y:1), animations: {
            
            
            self.table.transform = CGAffineTransform(translationX: 0, y:self.maxPopupHeight)
        })
        
        
        
        tableAnimator.startAnimation()
        
        
        for cell in self.table.visibleCells {
            
            
            let alphaAnimator = UIViewPropertyAnimator(duration: self.singleDuration, controlPoint1: CGPoint(x:0.6,y:0.3), controlPoint2:  CGPoint(x:0.95,y:0.8), animations: {
                
                cell.alpha = 0
            })
            
            alphaAnimator.startAnimation()
            
        }
        
    }
}

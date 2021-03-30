//
//  YLLayoutTestXibViewController.swift
//  YLNote
//
//  Created by tangh on 2021/1/25.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLLayoutView: UIView {
    override func updateConstraints() {
        super.updateConstraints()
        print("-\(#function):[tag:\(self.tag)]")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLog("-\(#function):[tag:\(self.tag)]")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("-\(#function):[tag:\(self.tag)]")
    }
}

class YLTableView: UITableView {
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        NSLog("-\(#function):[tag:\(self.tag)]")
    //    }
    //
    //    override func updateConstraints() {
    //        super.updateConstraints()
    //        print("-\(#function):[tag:\(self.tag)]")
    //    }
    //
    //    override func draw(_ rect: CGRect) {
    //        super.draw(rect)
    //        print("-\(#function):[tag:\(self.tag)]")
    //    }
}

class YLDemoLayoutViewController: UIViewController {
    
    @IBOutlet weak var table: YLTableView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var aView: YLLayoutView!
    @IBOutlet weak var bView: YLLayoutView!
    @IBOutlet weak var aBottomConstraint: NSLayoutConstraint!
    let cellReuseIdentifier = "kYLLayoutTestXibViewControllerCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addObserver()
        print("当前屏幕：\(UIDevice.current.orientation)")
        print("**********\(#function)***********")
        print("aView:"+"\(NSCoder.string(for: aView.frame))")
        print("bView:"+"\(NSCoder.string(for: bView.frame))")
        print("**********\(#function)***********\n")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        print("**********\(#function)***********")
        print("aView:"+"\(NSCoder.string(for: aView.frame))")
        print("bView:"+"\(NSCoder.string(for: bView.frame))")
        print("**********\(#function)***********\n")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("**********\(#function)***********")
        print("aView:"+"\(NSCoder.string(for: aView.frame))")
        print("bView:"+"\(NSCoder.string(for: bView.frame))")
        print("**********\(#function)***********\n")
    }
    
    //MARK: funcs
    func setupUI() {
        title = "试验:layoutSubviews触发条件"
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func onDeviceOrientationDidChange() {
        print("\(#function)")
        //获取当前设备Device
//        let device = UIDevice.current ;
//        //识别当前设备的旋转方向
//        switch (device.orientation) {
//        case .faceUp:
//            print("屏幕幕朝上平躺");
//        case .faceDown:
//            print("屏幕朝下平躺")
//        case .unknown:
//            //系统当前无法识别设备朝向，可能是倾斜
//            print("未知方向")
//        case .landscapeLeft:
//            print("屏幕向左橫置")
//        case .landscapeRight:
//            print("屏幕向右橫置")
//        case .portrait:
//            print("屏幕直立")
//        case .portraitUpsideDown:
//            print("屏幕直立，上下顛倒")
//        default:
//            print("无法识别")
//        }
    }
    
    ///  修改frame会触发父视图的'layoutSubviews'方法 和 自身的'layoutSubviews'方法；
    @objc func test_changeFrame_aview() {
        print("***\(#function)***")
        UIView.animate(withDuration: 0.4) {
            let preframe = self.aView.frame
            print("preframe:\(preframe)")
            self.aView.frame = CGRect(origin: preframe.origin, size: CGSize(width: preframe.width, height: 200)) // 坑： 效果演示发现aView的frame最终没有变化；原因：系统的布局是优先使用AutoLayout的，但是布局的最终结果却是将约束转化成视图的frame，理解了这一点对于布局方式的选用也很重要。(参考：视图加载过程.md)
        }
    }
    /// addSubView只会触发自身(bView)的'layoutSubviews'方法；打印结果显示cView的'layoutSubviews'方法是因为cView的frame不为0所触发；removeFromSuperview 也会导致父 View 调用 layoutSubviews
    @objc func test_bview_addsubView_cview() {
        print("***\(#function)***")
        self.bView.addSubview(self.cView)
    }
    
    ///  修改frame会触发父视图的'layoutSubviews'方法 和 自身的'layoutSubviews'方法；
    @objc func test_changeFrame_cview() {
        print("***\(#function)***")
        UIView.animate(withDuration: 0.4) {
            let preframe = self.cView.frame
            self.cView.frame = CGRect(origin: preframe.origin, size: CGSize(width: 30, height: 30))
        }
    }
    
    @objc func test_changeConstraint_aview() {
        print("***\(#function)***")
        self.aBottomConstraint.constant = 30;
    }
    
    /// 官方解释：'setNeedsLayout'使接收器的当前布局无效，并在下一个更新周期期间触发布局更新。
    /**当您想要调整视图的子视图布局时，请在应用程序的主线程上调用此方法。此方法记录请求并立即返回。
     因为此方法不强制立即更新，而是等待下一个更新周期，所以您可以使用它在更新多个视图中的任何一个视图之前使这些视图的布局无效。
     此行为允许您将所有布局更新合并到一个更新周期，这通常更有利于性能。*/
    @objc func test_setNeedsLayout() {
        print("***\(#function)***")
        self.aView.setNeedsLayout()
    }
    
    @objc func test_scrollviewDidScroll() {
        print("***\(#function)***")
        table.scrollToRow(at: IndexPath(row: datas_non_responder.count-1, section: 1), at: .bottom, animated: true)
    }

    @objc func test_changeScreenOrientation() {
        YLAlertManager.showAlert(withTitle: "提示", message: "请旋转手机屏幕查看打印结果", actionTitle: "OK", handler: nil)
    }
        
    /// 官方解释：'layoutIfNeeded'如果布局更新挂起，则立即布局子视图。
    /** 使用此方法可强制视图立即更新其布局。使用自动布局时，布局引擎会根据需要更新视图位置，以满足约束中的更改。
     此方法使用接收消息的视图作为根视图，从根开始布局视图子树。
     如果没有挂起的布局更新，此方法将退出，而不修改布局或调用任何与布局相关的回调。
     总结：'layoutIfNeeded'不是触发layoutSubviews的直接原因，它只是当存在布局更新被挂起时不需要等下一个周期执行，而是在此立即执行。
     */
    @objc func test_layoutIfNeeded() {
        print("***\(#function)***")
        self.aBottomConstraint.constant = 80;
        self.aView.layoutIfNeeded()
    }
    
    @objc func test_tmpviewInit() {
        let tmp = YLLayoutView.init()
        tmp.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        print("***\(#function),\(NSCoder.string(for: tmp.frame))*******")
    }
    
    @objc func test_tmpviewInitFrame_zero() {
        let tmp = YLLayoutView.init(frame: CGRect.zero)
        tmp.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        print("***\(#function),\(NSCoder.string(for: tmp.frame))*******")
    }
    
    @objc func test_tmpviewInitFrame() {
        let tmp = YLLayoutView.init(frame: CGRect(x: 10, y: 10, width: 200, height: 120))
        tmp.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        print("***\(#function),\(NSCoder.string(for: tmp.frame))*******")
    }
    
    //MARK: lazy
    lazy var datas_responder: [String] = {
        let array = [
            "changeFrame_aview",
            "changeConstraint_aview",
            "bview_addsubView_cview",
            "changeFrame_cview",
            "setNeedsLayout",
            "scrollviewDidScroll",
            "changeScreenOrientation"
        ]
        return array
    }()
    
    lazy var datas_non_responder: [String] = {
        let array = [
            "layoutIfNeeded",
            "tmpviewInit",
            "tmpviewInitFrame_zero",
            "tmpviewInitFrame"
        ]
        return array
    }()
    
    lazy var cView: YLLayoutView = {
        let view = YLLayoutView(frame: CGRect(x: 20, y: 20, width: 50, height: 50))
        view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        view.tag = 102;
        return view
    }()
    
}

extension YLDemoLayoutViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = #colorLiteral(red: 1, green: 0.9340484738, blue: 0.8118715882, alpha: 0.6)
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 10, width: YLScreenSize.width - 20, height: 20)
        label.textColor = YLTheme.main().themeColor
        label.font = YLTheme.main().titleFont
        label.text = section == 0 ? "can responder to 'layoutSubviews'" : "not responder to 'layoutSubviews'"
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? datas_responder.count : datas_non_responder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let array = indexPath.section == 0 ? datas_responder : datas_non_responder;
        let cell = tableView.dequeueReusableCell(withIdentifier:cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        cell.textLabel?.textColor = YLTheme.main().textColor
        cell.textLabel?.font = YLTheme.main().titleFont
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let array = indexPath.section == 0 ? datas_responder : datas_non_responder;
        
        let functionName = "test_"+array[indexPath.row]
        
        #warning("函数自省的三种方式")
        /// 第一种
        let function = Selector(functionName)
        guard self.responds(to: function) else { return }
        self.perform(function)
        
        return;
        // 第二种： 带参数🌰
        if functionName.contains(":") {
            let funcc = NSSelectorFromString("selectorArg1:Arg2:")
            self.perform(funcc, with: "1", with: "2")
        }
        
        
    }
}

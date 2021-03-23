//
//  YLSwiftViewController.swift
//  YLNote
//
//  Created by tangh on 2021/2/13.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
extension Notification.Name {
    static let skinChanged = Notification.Name("kSkinChanged")
}

class YLSwiftViewController: UIViewController {
    
    let cellIdentifier = "cellIdentifier"
    var foldStatus:NSMutableDictionary = [:]
    var headImageViews:NSMutableDictionary = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = "Swift"
        setupUI()
        addObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupUI() {
        self.view.addSubview(table)
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    
    //MARK: Click Actions
    @objc func clickGroupAction(sender:UIButton) {
        let groupIndex = sender.tag
        var flag = 0;
        
        if let foldStatus = self.foldStatus[groupIndex] as? Int, foldStatus == 1 {
            self.foldStatus[groupIndex] = 0
            flag = 1
        } else {
            self.foldStatus[groupIndex] = 1
            flag = 0;
        }
        
        
        let set = NSIndexSet(index: groupIndex)
        self.table.reloadSections(set as IndexSet, with: .none)
        guard let imageView = self.headImageViews[groupIndex] as? UIImageView else { return }
        if flag == 1 {
            imageView.transform = imageView.transform.rotated(by: CGFloat(Double.pi / 2));
        }
        
        UIView.animate(withDuration: 0.3) {
            if flag == 0 {
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            } else {
                imageView.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
    }
    //MARK:group - 基础知识
    @objc func test_artical() {
        let vc = YLArticleMDViewController()
        vc.fileName = "Swift基础"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// split(separator:) is faster than components(separatedBy:). (split方法效率更高)
    @objc func test_separatorString() {
        /// split(分割substring) + compactMap(转换substring转string)消耗时间 > components(直接分割string)消耗时间

        let str = """
                       One of those refinements is to the String API, which has been made a lot easier to use (while also gaining power) in Swift 4. In past versions of Swift, the String API was often brought up as an example of how Swift sometimes goes too far in favoring correctness over ease of use, with its cumbersome way of handling characters and substrings. This week, let’s take a look at how it is to work with strings in Swift 4, and how we can take advantage of the new, improved API in various situations. Sometimes we have longer, static strings in our apps or scripts that span multiple lines. Before Swift 4, we had to do something like inline \n across the string, add an appendOnNewLine() method through an extension on String or - in the case of scripting - make multiple print() calls to add newlines to a long output. For example, here is how TestDrive’s printHelp() function (which is used to print usage instructions for the script) looks like in Swift 3  One of those refinements is to the String API, which has been made a lot easier to use (while also gaining power) in Swift 4. In past versions of Swift, the String API was often brought up as an example of how Swift sometimes goes too far in favoring correctness over ease of use, with its cumbersome way of handling characters and substrings. This week, let’s take a look at how it is to work with strings in Swift 4, and how we can take advantage of the new, improved API in various situations. Sometimes we have longer, static strings in our apps or scripts that span multiple lines. Before Swift 4, we had to do something like inline \n across the string, add an appendOnNewLine() method through an extension on String or - in the case of scripting - make multiple print() calls to add newlines to a long output. For example, here is how TestDrive’s printHelp() function (which is used to print usage instructions for the script) looks like in Swift 3
                 """
        
        var newString = String()
        for _ in 1..<9999 {
            newString.append(str)
        }
        
        var methodStart = Date()
        
        _  = newString.components(separatedBy: " ")
        print("Execution time Separated By: \(Date().timeIntervalSince(methodStart))")
        
        methodStart = Date()
        let arraySubstrings = newString.split(separator: " ")
        print("Execution time Split By: \(Date().timeIntervalSince(methodStart))")
        
        let _:[String] = arraySubstrings.compactMap { (item) -> String in
            return "\(item)"
        }
        print("Execution time Split By: \(Date().timeIntervalSince(methodStart))")
       
        print("\(arraySubstrings[10])==\(arraySubstrings.count)")
        print("Execution time Split By: \(Date().timeIntervalSince(methodStart))")
    }
    
    @objc func test_substring_vs_string() {
        // substring用法（swift 4 之后）
        func testSubstring_usage() {
              let str = "12345678"
              let length = str.count
             
              print("原始string :\(str)")

              // 截取前四位
              let pre4_a = str.index(str.startIndex, offsetBy: 4)
              let pre4_b = str.prefix(4)
              print("截取前四位 a:\(str[..<pre4_a]) ")
              print("截取前四位 b:\(pre4_b)")

              // 截取后2位（两种方法）
              let last2_a  = str.index(after: str.index(str.startIndex, offsetBy: length-3))
              let last2_b = str.index(str.endIndex, offsetBy: -2)
              let last2_c = str.suffix(2)
              print("截取后2位 a:\(str[last2_a..<str.endIndex])")
              print("截取后2位 b:\(str[last2_b..<str.endIndex])")
              print("截取后2位 c:\(last2_c)")

              // 截取中间4位，从第2位开始(二种方法)下标从0开始计数
              let startIndex = str.index(str.startIndex, offsetBy: 1)
              let endIndex = str.index(str.startIndex, offsetBy: 5)
              let mid2_4 = String(str[startIndex..<endIndex])
              print("从第2位开始,截取中间4位 a:\(mid2_4)")
          }
        testSubstring_usage()
        
        let vc = YLArticleMDViewController()
        vc.fileName = "Substring与String区别"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:group - Swift与OC使用对比
    @objc func test_property() {

    }

    @objc func test_enum() {
        
    }
    
    @objc func test_lazy() {
        let sandboxiePath = NSHomeDirectory()
        print("沙盒路径：\(sandboxiePath)")
        print("程序路径：\(Bundle.main.resourcePath ?? "")")
        print("程序路径：\(Bundle.main.bundlePath)")

    }
    
    @objc func test_block() {

    }
    
    /// 单例的使用
    @objc func test_singleton() {
//        print("第一种方式初始化单例用法：\(doggy.petId)")
//        print("第二种方式初始化单例用法：\(YLPet.catty.petId)")
//        print("第三种方式初始化单例用法：\(YLPet.default().petId)")

        changePetName()
    }
    
    func changePetName() {
        let concurrentQueue = DispatchQueue(label: "swiftlee.concurrent.queue", attributes: .concurrent)

        for i in 1...100 {
            concurrentQueue.async {
                print("Task \(i) started---\(Thread.current)")
                // Do some work..
                doggy.name = "doggy" + "\(i)"
                print("Task  \(i)  finished---\(Thread.current)")

            }
        }

        print(doggy.name ?? "")

    }
    
    @objc func test_init_deinit() {

    }

    @objc func test_notification() {
        changeThemeColor()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: .skinChanged, object: nil)
    }
    
    func changeThemeColor() {
        print("before: \(YLTheme.main().themeColor)")
        YLTheme.main().themeColor = UIColor.random()
        print("after: \(YLTheme.main().themeColor)")
    }
    
    @objc func refreshView() {
        table.reloadData()
    }

    @objc func test_protocol() {

    }
    
    @objc func test_extension() {

    }

    //MARK:group - 函数派发
    @objc func test_function() {
        let vc = YLArticleMDViewController()
        vc.fileName = "Swift函数派发机制"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func test_direct() {
        
    }
    
    @objc func test_table() {
        
    }

    @objc func test_message() {
        
    }

    
    //MARK: lazy method
    lazy var table: UITableView = {
        let t = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped )
        t.rowHeight = 40
        t.delegate = self
        t.dataSource = self
        return t
    }()
    
    lazy var keywords:[NSDictionary] = {
        return [["group":"基础知识",
                 "questions":["artical:文章","separatorString:字符串分割区别","substring_vs_string:Substring与String区别"]],
                ["group":"Swift与OC使用对比",
                "questions":["property:属性","enum:枚举","lazy:懒加载","block:闭包","singleton:单例","init_deinit:初始化和析构","function:函数调用","notification:通知","protocol:协议/代理","extension:扩展"]],

                ["group":"函数派发",
                 "questions":["function:函数派发机制","direct:直接派发","table:函数表派发","message:消息派发"]],
                
        ];
    }()
    
}

extension YLSwiftViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.keywords.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dic = keywords[section]
        if let groupTitle = dic["group"] as? String {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            let butn = UIButton(type: .custom)
            butn.contentHorizontalAlignment = .left;
            butn.setTitle(groupTitle, for: .normal)
            butn.titleLabel?.font = YLTheme.main().titleFont
            butn.setTitleColor(YLTheme.main().themeColor, for: .normal)
            butn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
            butn.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
            butn.tag = section
            butn.addTarget(self, action: #selector(clickGroupAction(sender:)), for: .touchUpInside)
            view.addSubview(butn)
            
            let imageView = UIImageView(frame: CGRect(x: 5, y: 10, width: 20, height: 20))
            imageView.image = #imageLiteral(resourceName: "arrow")
            imageView.tag = 101
            butn.addSubview(imageView)
            headImageViews[section] = imageView
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let flag = self.foldStatus[section] as? Int, flag == 1 {
            let dict = self.keywords[section]
            if let sectionArray = dict["questions"] as? NSArray {
                return sectionArray.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionDict = self.keywords[indexPath.section];
        guard let sectionArry = sectionDict["questions"] as? [String] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let title = sectionArry[safe: indexPath.row];
        cell.textLabel?.text = title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionDict = self.keywords[indexPath.section];
        guard let sectionArry = sectionDict["questions"] as? [String] else { return }
        let question = sectionArry[safe: indexPath.row];
        let questionArry = question?.components(separatedBy: ":")
        guard let questionFunc = questionArry?.first else { return };
        let functionName = "test_"+questionFunc
       
        #warning("函数自省的方式")
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


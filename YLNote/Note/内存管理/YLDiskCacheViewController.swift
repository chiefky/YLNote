//
//  YLDiskCacheViewController.swift
//  YLNote
//
//  Created by tangh on 2021/2/19.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLDiskCacheViewController: UIViewController {

        let cellIdentifier = "cellIdentifier"
        var foldStatus:NSMutableDictionary = [:]
        var headImageViews:NSMutableDictionary = [:]
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.title = "Swift"
            setupUI()
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
        
        //MARK:group - Swift与OC使用对比
        @objc func test_property() {

        }

        @objc func test_enum() {
            
        }
        
        @objc func test_lazy() {

        }
        
        @objc func test_block() {

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
            return [
                ["group":"1","questions":["artical:1","artical:1","artical:1"]],
                ["group":"2","questions":["artical:1","artical:1","artical:1"]],
                ["group":"3","questions":["artical:1","artical:1","artical:1"]]
            ];
        }()
        
    }

    extension YLDiskCacheViewController: UITableViewDataSource,UITableViewDelegate {
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

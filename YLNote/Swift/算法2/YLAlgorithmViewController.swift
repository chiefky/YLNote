//
//  YLAlgorithmViewController.swift
//  YLNote
//
//  Created by tangh on 2021/1/5.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLAlgorithmViewController: UIViewController {
    
    let cellIdentifier = "cellIdentifier"
    var foldStatus:NSMutableDictionary = [:]
    var headImageViews:NSMutableDictionary = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = "算法"
        setupUI()
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
    //MARK: functions
    // 练习一：交换数字
    @objc func test_swap(index: Any) {
        print("响应了\(index)")
        if let index = index as? Int {
            var a = 11,b = 99
            print("原始值：a:\(a),b:\(b)");
            switch index {
                case 0:
                    swapNumbersWithTemp(a: &a, b: &b)
                case 1:
                    swapNumbersWithArithmetic(a: &a, b: &b)
                case 2:
                    swapNumbersWithXOR(a: &a, b: &b)
                default:
                    break;
            }
            print("交换后：a:\(a),b:\(b)");
        }
       
    }
    
    // 练习二：求二叉树的深度
    @objc func test_binaryDepth(index: Any) {
        let rootNode = BinaryTreeNode(val: 1)
        let node1 = BinaryTreeNode(val: 3)
        let node2 = BinaryTreeNode(val: 4)
        let node3 = BinaryTreeNode(val: 5)
        rootNode.left = node1;
        rootNode.right = node2
        node1.left = node3
        node1.right = nil
        node2.left = nil;
        node2.right = nil
        node3.left = nil;
        node3.right = nil;
        
        var deep = 0;
        if let index = index as? Int {
            switch index {
                case 0:
                    deep = getBinaryTreeDepth(rootNode)
                case 1:
                    deep = getBinaryTreeDepthWithDFS(rootNode)
                case 2:
                    deep = getBinaryTreeDepthWithBFS(rootNode)
                default:
                    break;
            }
        }
        print("二叉树深度:\(deep)")
    }
    
    /// 练习三：输入一课二叉树的根结点，判断该树是不是平衡二叉树
    @objc func test_isBalanced(index:Any) {
        let rootNode = BinaryTreeNode.createTree(values: [5,3,4,6,7])
        let result = isBalancedByRecursion(rootNode)
        print("result: \(result)")
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
        return [["group":"数字交换",
                 "questions":[
                    "swapWithIndex: 使用临时变量",
                    "swapWithIndex: 使用四则运算",
                    "swapWithIndex: 使用异或运算"]
            ],
                [
                    "group":"求二叉树深度",
                    "questions":[
                        "binaryDepthWithIndex: 使用递归",
                        "binaryDepthWithIndex: 使用栈+DFS",
                        "binaryDepthWithIndex: 使用队列+BFS"]
            ],
                [
                    "group":"判断是否为平衡二叉树",
                    "questions":[
                        "isBalancedWithIndex: 使用递归"]
            ]
        ];
    }()

}

extension YLAlgorithmViewController: UITableViewDataSource,UITableViewDelegate {
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
        guard let questions = sectionDict["questions"] as? [String] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if let question = questions[safe: indexPath.row] {
            let arraySubstrings: [Substring] = question.split(separator: " ")
            if let first = arraySubstrings.first, let last = arraySubstrings.last {
                cell.textLabel?.text = "\(first)" + "\(indexPath.row) " + "\(last)"
            }
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let sectionDict = self.keywords[indexPath.section];
         guard let sectionArry = sectionDict["questions"] as? [String] else { return }
         let question = sectionArry[safe: indexPath.row];
         let questionArry = question?.components(separatedBy: " ")
         guard let questionFunc = questionArry?.first else { return };
         let functionName = "test_"+questionFunc
        
         #warning("函数自省的方式")
        // 第二种： 带参数🌰
        if functionName.contains(":") {
            let funcc = NSSelectorFromString(functionName)
            self.perform(funcc, with: indexPath.row)
        }
        return;
        
        /// 第一种 不带参数
        let function = Selector(functionName)
        guard self.responds(to: function) else { return }
        self.perform(function)
    }
         

}


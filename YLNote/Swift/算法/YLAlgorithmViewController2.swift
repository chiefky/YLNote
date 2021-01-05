//
//  YLAlgorithmViewController.swift
//  YLNote
//
//  Created by tangh on 2020/7/20.
//  Copyright © 2020 tangh. All rights reserved.
//

import UIKit

class YLAlgorithmViewController2: UIViewController {

    let cellIdentifier = "cellIdentifier"
    
    
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
    
    lazy var table: UITableView = {
        let t = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        t.rowHeight = 40
        t.delegate = self
        t.dataSource = self
        return t
    }()
    
     lazy var keywords:[String: [String]] = {
        return ["递归":["testSum:求和", "testFib:青蛙跳台","testInorderRecursion:二叉树中序遍历(递归)"],
                "双指针":["testString:字符串翻转","testlookupMin:旋转数组中查找最小元素"],
                "二分查找":["testSqrt:求平方根"],
                "迭代":["testInorderIteration:中序遍历(迭代)", "testAlgorithm:"],
             "栈":["testInvalid:求是否是有效括号"]]
    }()

    //MARK: - tests
    //MARK:递归
    @objc func testSum() {
        let sum = rc_sum(100)
        print("1+2+...+ 100 = \(sum)")
    }

    @objc func testFib() {
        let n = 5
        let sum = rc_fib(n)
        print("青蛙跳到第\(n)阶台阶时共有\(sum)种跳法")
    }
    /// test 中序遍历--递归
      @objc func testInorderRecursion() {
          let node1 = TreeNode(1)
      
          let node2 = TreeNode(2)
          let node3 = TreeNode(3)
          node1.left = nil
          node1.right = node2;
          node2.left = node3
          node2.right = nil
          
          let res = rc_inorderTraversal(node1)
          print("res == \(res)")
      }
      
    
    //MARK: 双指针
    @objc func testString() {
        var n:[Character] = ["a","b","c","f"]
        dp_reverseString(&n);
        print("转换后 n:\(n)");
    }
    
    func testlookupMin() {
        let nums = [3,1,3]
        let res = dp_lookupMinInArry(nums)
        print("旋转数组中的最小元素：\(res)")
        
    }
    
    //MARK:二分查找
    /// test 二分查找，开方
    @objc func testSqrt() {
        let n = bs_mySqrt(4)
        print("开方后 n:\(n)");
    }
    
  
    //MARK:迭代
    /// test 中序遍历--迭代
    @objc func testInorderIteration() {
        let node1 = TreeNode(1)
    
        let node2 = TreeNode(2)
        let node3 = TreeNode(3)
        node1.left = nil
        node1.right = node2;
        node2.left = node3
        node2.right = nil
        
        let res = ir_inorderTraversal(node1)
        print("res == \(res)")
    }
 //MARK: 栈
    @objc func testInvalid() {
        let s = "[E"
        let res = st_isValid(s)
        print("结果是\(res)")
    }

 
    
}

extension YLAlgorithmViewController2: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let allSecValues = Array(keywords.values)
        let secItems = allSecValues[indexPath.section]
        let titleValue = secItems[indexPath.row]
        let titleValues = titleValue.components(separatedBy: ":")
        guard  let methodTitle = titleValues.first else { return }
        let selector = NSSelectorFromString(methodTitle)
        if self.responds(to: selector) {
            self.perform(selector)
        }
         
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let allSecValues = Array(keywords.values)
        let secItems = allSecValues[indexPath.section]
        let titleValue = secItems[indexPath.row]
        let titleValues = titleValue.components(separatedBy: ":")
        guard  let methodTitle = titleValues.first else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let attrMethod =  [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) ,
                                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12) ] as [NSAttributedString.Key : Any]
              let attrTitle = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ,
                                NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 12) ] as [NSAttributedString.Key : Any]
        let attrStr = NSMutableAttributedString(string: titleValue)
        attrStr.addAttributes(attrMethod, range: NSMakeRange(0, methodTitle.count + 1))
        attrStr.addAttributes(attrTitle, range: NSMakeRange(methodTitle.count + 1, titleValue.count - methodTitle.count - 1))
        cell.textLabel?.attributedText = attrStr
        
        return cell
        
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        let allSecKeys = Array(keywords.keys)

        return allSecKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allSecValues = Array(keywords.values)
        let secItems = allSecValues[section]
        return secItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let allSecKeys = Array(keywords.keys)

        return allSecKeys[section]
    }
}

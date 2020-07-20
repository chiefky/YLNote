//
//  YLAlgorithmViewController.swift
//  YLNote
//
//  Created by tangh on 2020/7/20.
//  Copyright © 2020 tangh. All rights reserved.
//

import UIKit

class YLAlgorithmViewController: UIViewController {

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
        return ["递归":["testSum:求和", "testFib:青蛙跳台"],
                "二叉树":["testAlgorithm:", "testAlgorithm:"]]
    }()

    //MARK: - tests
    @objc func testSum() {
        let sum = recursionSum(100)
        print("1+2+...+ 100 = \(sum)")
    }

    @objc func testFib() {
        let n = 5
        let sum = recursionFib(n)
        print("青蛙跳到第\(n)阶台阶时共有\(sum)种跳法")
    }
    
    //MARK: 递归
    func recursionSum(_ n: Int) -> Int {
        if n == 0 {
            return 0
        }
        return recursionSum(n-1) + n
    }
    
    /// 斐波那契数列、青蛙跳台
    /// - Parameter n: 第N阶跳台累计s多少种跳法
    func recursionFib(_ n: Int) -> Int {
          if n < 2 {
              return 1
          }
        var sum = 0,a = 1,b=1;
        for _ in 2...n {
            sum = (a + b) % 100000007;
            a = b;
            b = sum;
        }
          return sum
      }
    
//MARK: 二叉树
    
}

extension YLAlgorithmViewController: UITableViewDataSource,UITableViewDelegate {
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

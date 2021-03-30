//
//  YLAlgorithmViewController.swift
//  YLNote
//
//  Created by tangh on 2021/1/5.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLAlgorithmViewController: UIViewController {
    deinit {
        print("\(self.description): \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = "算法"
        setupUI()
    }
    
    func setupUI() {
        self.view.addSubview(table)
        let name = String(describing: YLQuestionTableViewCell.self)
        table.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        table.register(YLGroupHeaderView.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        table.dataSource = self.dataManager
        table.delegate = self.dataManager
    }
    
    //MARK: lazy method
    lazy var table: UITableView = {
        let t = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped )
        t.rowHeight = 40
        
        return t
    }()
    
    lazy var dataManager: YLQuestionDataManager = {
        let manager = YLQuestionDataManager()
        manager.dataSource = self
        return manager
    }()
    
}

extension YLAlgorithmViewController: YLQuestionDataProtocol {
    var jsonFile: String {
        return "Alfgo"
    }
    
    var headerIdentifier: String {
        return "YLAlgorithmViewController.cell"
    }
    
    var cellIdentifier: String {
        return "YLAlgorithmViewController.header"
    }
    
    func doFunction(with name: String, paramete: Any) {
        guard let index = paramete as? Int else { return }
        let funcName = "test_" + name
        if funcName.contains(":") {
            /// 第1种 带参数
            let funcc = NSSelectorFromString(funcName)
            self.perform(funcc, with: index)
        } else {
            /// 第2种 不带参数
            let function = Selector(funcName)
            guard self.responds(to: function) else { return }
            self.perform(function)
        }
    }
    
}

//MARK: demo functions
extension YLAlgorithmViewController {
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
    
    
}

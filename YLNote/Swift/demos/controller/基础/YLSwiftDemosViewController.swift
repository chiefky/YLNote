//
//  YLSwiftDemosViewController.swift
//  YLNote
//
//  Created by tangh on 2021/3/26.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLSwiftDemosViewController: UIViewController {

    let cellIdentifier = "YLSwiftDemosViewController.cell"
    var allQuestions:[YLQuestion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        self.title = "Web相关demo"
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    lazy var table: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.rowHeight = 44
        view.addSubview(tab)
        tab.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return tab
    }()
    
    
}

extension YLSwiftDemosViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemData = allQuestions[safe: indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = itemData.title
        cell.textLabel?.textColor = YLTheme.main().themeColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let question = allQuestions[safe: indexPath.row] else { return }
        UIWindow.pushToDemo(with: question)
        UIWindow.pushToArticle(question.article.fileName)
//        let className = question.demo.className
//        let vcClass: AnyClass? = question.demo.classType ? NSClassFromString("YLNote" + "." + className) : NSClassFromString(className)
//        guard let typeClass = vcClass as? UIViewController.Type else {
//            print("vcClass不能当做UIViewController")
//            return
//        }
//        var myVC: UIViewController
//        if question.demo.xibType { //或者加载xib;
//            myVC = typeClass.init(nibName: question.demo.className, bundle: nil)
//        } else {
//            if let _ = typeClass as? YLArticleMDViewController.Type {
//                let artVC = YLArticleMDViewController()
//                artVC.fileName = question.demo.atrticleTitle
//                myVC = artVC
//            } else {
//                myVC = typeClass.init()
//            }
//        }
//
//        myVC.title = question.demo.atrticleTitle.isEmpty ? (question.demo.title.isEmpty ? question.itemDesc : question.demo.title ) : question.demo.atrticleTitle
//        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
}

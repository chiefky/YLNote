//
//  YLAlgorithmViewController.swift
//  YLNote
//
//  Created by tangh on 2021/1/5.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLSwiftViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = "Swift"
        setupUI()
    }
    
    func setupUI() {
        self.view.addSubview(table)
        table.register(YLGroupHeaderView.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        table.register(UINib(nibName: String(describing: YLQuestionTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)

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

extension YLSwiftViewController: YLQuestionDataProtocol {
    var jsonFile: String {
        return "Swift"
    }
    
    var headerIdentifier: String {
        return "YLSwiftViewController.header"
    }
    
    var cellIdentifier: String {
        return "YLSwiftViewController.cell"
    }
}

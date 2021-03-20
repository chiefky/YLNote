//
//  YLMemoryViewController.swift
//  YLNote
//
//  Created by tangh on 2021/2/3.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLMemoryViewController: UIViewController {
    
    let cellReuseIdentifier = "kYLMemoryViewControllerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    //MARK: funcs
    func setupUI() {
        self.navigationItem.title = "性能优化"
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    @objc func test_addCorner() {
        let vc = YLCornerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func test_addShadow() {
        let vc = YLCollectionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: lazy
    lazy var datas: [[String: Any]] = {
        return [["title":"离屏渲染",
                 "datas":datas_offscreen],
                ["title":"启动优化",
                 "datas":datas_start],
                ["title":"内存泄漏",
                 "datas":datas_memory]]
    }()
    lazy var datas_offscreen: [String] = {
        let array = [
            "addCorner",
            "setMask",
            "addShadow",
        ]
        return array
    }()
    
    lazy var datas_start: [String] = {
        let array = [
            "layoutIfNeeded",
            "tmpviewInit",
            "tmpviewInitFrame_zero",
            "tmpviewInitFrame"
        ]
        return array
    }()
    
    lazy var datas_memory: [String] = {
        let array = [
            "layoutIfNeeded",
            "tmpviewInit",
            "tmpviewInitFrame_zero",
            "tmpviewInitFrame"
        ]
        return array
    }()
    
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        return table
    }()
}

extension YLMemoryViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionModel = datas[safe: section] else { return nil }
        let header = UIView()
        header.backgroundColor = #colorLiteral(red: 1, green: 0.9340484738, blue: 0.8118715882, alpha: 0.6)
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 10, width: YLScreenSize.width - 20, height: 20)
        label.textColor = YLTheme.main().themeColor
        label.font = YLTheme.main().titleFont
        label.text = sectionModel["title"] as? String ?? ""
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001;
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionModel  = datas[safe: section],
            let datas = sectionModel["datas"] as? [String] else { return 0 }
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionModel  = datas[safe: indexPath.section],
            let datas = sectionModel["datas"] as? [String] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier:cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = datas[safe: indexPath.row]
        cell.textLabel?.textColor = YLTheme.main().textColor
        cell.textLabel?.font = YLTheme.main().titleFont
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionModel = datas[safe: indexPath.section],
            let datas = sectionModel["datas"] as? [String] else { return }
        
        let functionName = "test_" + datas[indexPath.row]
        let function = Selector(functionName)
        guard self.responds(to: function) else { return }
        self.perform(function)
        
        
    }
}

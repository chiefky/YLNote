//
//  YLWKWebListViewController.swift
//  YLNote
//
//  Created by tangh on 2021/3/17.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLWKWebDemoListViewController: UIViewController {
    let cellIdentifier = "kYYLWKWebDemoListViewControllerCell"
    
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
    
    lazy var demos: [WebDemoData] = {
        
        return [
            WebDemoData(title:"通过拦截URL进行JS交互",demoID:"web_URL"),
            WebDemoData(title:"使用MessageHandler进行JS交互",demoID:"web_MessageHandler"),
        WebDemoData(title:"使用JavaScriptCore进行JS交互",demoID:"web_JavaScriptCore"),
        WebDemoData(title:"WKWebView cookie设置--test 待确认 ",demoID:"url_Cookie")]
    }()
    
}

extension YLWKWebDemoListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemData = demos[safe: indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = itemData.title
        cell.textLabel?.textColor = YLTheme.main().themeColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemData = demos[safe: indexPath.row] else { return }
        switch itemData.demoID {
        case "web_URL":
            let vc = YLWebSchemeController()
            vc.title = itemData.title
            self.navigationController?.pushViewController(vc, animated: true)
        case "web_MessageHandler":
            let vc = YLMessageHandlerViewController()
            vc.title = itemData.title
            self.navigationController?.pushViewController(vc, animated: true)
        case "web_JavaScriptCore":
            let vc = YLScriptCoreViewController()
            vc.title = itemData.title
            self.navigationController?.pushViewController(vc, animated: true)
        case "url_Cookie":
            let vc = YLWebCookieViewController()
            vc.title = itemData.title
            self.navigationController?.pushViewController(vc, animated: true)

        default:
            print("nothing")
        }
    }
    
}

struct WebDemoData {
    var title:String
    var demoID:String
}

//
//  YLSlipMenuView.swift
//  YLNote
//
//  Created by tangh on 2021/1/30.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation
import UIKit
typealias ActionHandle = (_ indexpath: Int) -> Void

class YLSlipMenuView: UIView {
    let reuseIdentifier = "YLSlipMenuViewCell"
    var handleBlock:ActionHandle?
    var isShow = false

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var table: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit() {
        Bundle.main.loadNibNamed("YLSlipMenuView", owner: self, options: nil)
        contentView.frame = self.bounds;
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight];
        addSubview(contentView)
        table.backgroundColor = .clear
        table.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        addSubview(table)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        table.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
    }
    //MARK: lazy
    var datas: [String] = ["m","n","a"] {
        didSet {
            table.reloadData()
        }
    }
    
    
}

extension YLSlipMenuView:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = datas[indexPath.row]
        cell.textLabel?.textColor = YLTheme.main().naviTintColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let handle = self.handleBlock else { return }
        handle(indexPath.row)
    }
}

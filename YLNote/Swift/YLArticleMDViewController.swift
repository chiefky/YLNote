//
//  YLArticleMDViewController.swift
//  YLNote
//
//  Created by tangh on 2021/2/13.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
import WebKit
import EFMarkdown

class YLArticleMDViewController: UIViewController {

    var fileName:String
    
    @objc init(markdown name: String) {
        fileName = name
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMarkDown()
    }
    
    //MARK: func
    func setupUI() {
        self.title = "\(fileName)"

        view.addSubview(self.mardownView)
        mardownView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func loadMarkDown() {
        let mdFile = YLFileManager.data(withLocalFileName: fileName, type: "md")
        let fileHtml = String(data: mdFile, encoding: .utf8)
        mardownView.load(markdown: fileHtml, options: .default) { (wkweb, navigation) in
            print("\(wkweb)::: \(String(describing: navigation))")
        }
    }
    
    // MARK: - Navigation

    lazy var mardownView: EFMarkdownView = {
        let v = EFMarkdownView()
        return v
    }()

}

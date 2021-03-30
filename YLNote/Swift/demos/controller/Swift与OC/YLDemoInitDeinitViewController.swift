//
//  YLDemoInitDeinitViewController.swift
//  YLNote
//
//  Created by tangh on 2021/3/29.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLDemoInitDeinitViewController: YLDemoBaseViewController {
    deinit {
        print("\(self):\(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @objc func test_init_deinit() {

    }



}

//
//  YLHomeViewController.swift
//  YLNote
//
//  Created by tangh on 2021/3/25.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLHomeViewController: UIViewController {


    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIButton!
    
    @IBOutlet var unloginView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("\(#function)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(#function)")
    }
    
    @IBAction func gotoLoginVCAction(_ sender: Any) {
        let loginVC = YLLoginViewController(nibName: "YLLoginViewController", bundle: nil)
        loginVC.loginDelegate = self;
        self.present(loginVC, animated: true) {
            
        }
        
    }
    
    @IBAction func changeAdvator(_ sender: Any) {
    }

    func setupUI() {
        guard let user = YLNoteUserManager.shared().currentUser else {
            showUnLoginView()
            return
        }
        
        unloginView.removeFromSuperview()
        nameLabel.text = user.name
        telLabel.text = user.tel
        
    }
    
    func showUnLoginView() {
        self.view.addSubview(unloginView)
        unloginView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension YLHomeViewController: LoginProtocol {
    func userLogin(name: String, password: String, completionHandler: (Bool, String?) -> ()) {
        if name == "void" && password == "123" {
            completionHandler(true,nil)
        } else {
            completionHandler(false,"登录失败，请重新登录")
        }
    }
}

//
//  YLDemoTestAniViewController.swift
//  YLNote
//
//  Created by tangh on 2021/3/24.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLDemoTestAniViewController: UIViewController {

    @IBOutlet weak var header: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func clickAction(_ sender: Any) {
        testAnimation(rotationAngle: .pi / 2)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        testAnimation(rotationAngle: 0)
    }
    func testAnimation(rotationAngle: CGFloat) {
        UIView.animate(withDuration: 1) {
            self.titleLab.transform = CGAffineTransform(rotationAngle: rotationAngle)
            self.header.transform = CGAffineTransform(rotationAngle: rotationAngle)

        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  YLQuestionTableViewCell.swift
//  YLNote
//
//  Created by tangh on 2021/3/29.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
typealias ArticleHandler = () -> ()
class YLQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var articleHandler: ArticleHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
//        titleLabel.textColor = .red
    }

    @IBAction func articleActionClicked(_ sender: Any) {
        if let handler = articleHandler {
            handler()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}

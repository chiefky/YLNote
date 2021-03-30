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

    @IBOutlet weak var nextPage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var articleHandler: ArticleHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
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

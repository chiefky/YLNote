//
//  YLCollectionViewCell.swift
//  YLNote
//
//  Created by tangh on 2021/2/4.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("\(#function)")
    }
    


}

//
//  YLColorView.swift
//  YLNote
//
//  Created by tangh on 2021/1/28.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLTestView: UIView {
    
    @IBOutlet weak var centerTextLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var contentView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        
        Bundle.main.loadNibNamed("YLTestView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight];
        contentView.backgroundColor = .clear
        addSubview(contentView)
    }
    
    var text: String = "" {
        didSet {
            textLabel.text = text
        }
    }
    
    var centerText: String = "" {
        didSet {
            centerTextLabel.text = centerText
        }
    }
    
    //MARK: rewrite
    override func updateConstraints() {
        super.updateConstraints()
        print("\(text):\(#function)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("\(text):\(#function)")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("\(text):\(#function)")
    }
    
    
}

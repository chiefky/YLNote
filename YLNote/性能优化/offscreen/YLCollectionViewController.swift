//
//  YLCollectionViewController.swift
//  YLNote
//
//  Created by tangh on 2021/2/4.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLCollectionViewController: UIViewController {
    let kIdentifierCell = "kYLCollectionViewControllerCell"
    let kIdentifierHeader = "kYLCollectionViewControllerHeader"

    let imageSize = CGSize(width: 80, height: 80)
        
    let minimumLineSpacing:CGFloat = 8 // line 间隔
    let minimumInteritemSpacing:CGFloat = 5 // item 间隔
    let itemsPerRow:CGFloat = 3.0
    
    var marH: CGFloat {
        return (YLScreenSize.width - self.imageSize.width * self.itemsPerRow - self.minimumInteritemSpacing * (self.itemsPerRow + 1.0)) / 4;
    }
    
    var marV: CGFloat {
        return 25.0 + self.minimumLineSpacing;
    }
    
    lazy var layout: UICollectionViewFlowLayout = {
        let lay = UICollectionViewFlowLayout()
        return lay
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }


    
    // MARK: - func
    func setupUI() {
        view.backgroundColor = YLTheme.main().backColor

        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = CGSize(width: self.imageSize.width + self.marH, height: self.imageSize.height + self.marV)
        layout.sectionInset = UIEdgeInsets(top: marV/2, left: marH/2, bottom: marV/2, right: marH/2)
        layout.headerReferenceSize = CGSize(width: YLScreenSize.width, height: 40)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(UINib(nibName: "YLCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kIdentifierCell)
        collection.register(YLCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kIdentifierHeader)
        collection.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-150)
        }
        
    }


}

extension YLCollectionViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kIdentifierCell, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        if let imageCell = cell as? YLCollectionViewCell {
            imageCell.imageView?.image = #imageLiteral(resourceName: "mmco")
            imageCell.textLabel.text = "\(indexPath.section)-\(indexPath.row)"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kIdentifierHeader, for: indexPath)
        
        if let headerView = header as? YLCollectionReusableView {
            headerView.textLabel.text = "Supplementary-\(indexPath.section):"
        }
        header.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        return header;
    }
    
    
}

class YLCollectionReusableView: UICollectionReusableView {
    var textLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.left.equalTo(20)
            make.center.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

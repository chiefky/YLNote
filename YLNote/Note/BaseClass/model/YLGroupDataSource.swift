//
//  YLBaseGroupManager.swift
//  YLNote
//
//  Created by tangh on 2021/3/22.
//  Copyright © 2021 tangh. All rights reserved.
//

@objc protocol YLGroupDataSource {
    
//    协议可以要求遵循协议的类型提供特定名称和类型的实例属性或类型属性，它只指定属性的名称和类型，协议还指定属性是可读的还是可读可写的。
    var name: String {get}
//    var price: Double {get set}
    
    // MARK: 必须实现
    func dataGroup() -> [YLNoteGroup]
    
    // MARK: 可选实现
    @objc optional func actionHandler()
}

@objc protocol YLGroupDataDelegate {
    
    
    // MARK: 可选实现
    @objc optional func didSelectRow(with item:YLNoteItem)
}

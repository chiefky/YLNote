//
//  DeallocExecutor.swift
//  YLNote
//
//  Created by tangh on 2021/2/22.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

typealias DeallocHandler = () -> ()
/// 销毁者
class DeallocExecutor: NSObject {
    var handler:DeallocHandler?
    var idTag: String = ""
    
    convenience init(id:String, block:DeallocHandler?) {
        self.init()
        idTag = id
        handler = block
    }
    
    deinit {
        if let block = handler {
            block()
            handler = nil
        }
    }
}

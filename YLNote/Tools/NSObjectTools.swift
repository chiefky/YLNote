//
//  NSObjectTools.swift
//  YLNote
//
//  Created by tangh on 2021/2/22.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation

struct NSObjcAssociatedKeys {
    static var deallocObjArray = "kDeallocExecutors"
}
//MARK: Dealloc
extension NSObject {
    func addDeallocExecutor(tag:String, block: DeallocHandler?) -> DeallocExecutor? {
        guard let handler = block else { return nil }

        var executors:[DeallocExecutor] = []
        if let tmp = objc_getAssociatedObject(self, &NSObjcAssociatedKeys.deallocObjArray) as? [DeallocExecutor] {
            executors = tmp
        } else {
            let executors = [DeallocExecutor]()
            objc_setAssociatedObject(self, &NSObjcAssociatedKeys.deallocObjArray, executors, .OBJC_ASSOCIATION_RETAIN)
        }
        
        for executor in executors {
            if executor.idTag == tag {
                return nil;
            }
        }

        let executor = DeallocExecutor(id: tag, block: handler)
        executors.append(executor)
        return executor

    }
}

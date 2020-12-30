//
//  BinarySearch.swift
//  YLNote
//
//  Created by tangh on 2020/7/22.
//  Copyright © 2020 tangh. All rights reserved.
//

import Foundation
// 二分查找

//MARK:二分查找
 func bs_mySqrt(_ x: Int) -> Int {
    if x == 0 {
        return 0
    }
    var l = 1,r = x/2;
    while l < r {
        let mid = (l + r) / 2 + 1
        if mid > x / mid {
            r = mid - 1
        } else {
            l = mid
        }
    }
    
    return l;

  }

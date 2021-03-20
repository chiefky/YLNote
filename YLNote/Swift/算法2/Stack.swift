//
//  Stack.swift
//  YLNote
//
//  Created by tangh on 2020/7/23.
//  Copyright © 2020 tangh. All rights reserved.
//

import Foundation

func st_isValid(_ s: String) -> Bool {
    var stack:[String] = []
    let map = [")":"(","]":"[","}":"{"]
    for char in s {
        if map.values.contains(char.description) {
            stack.append(char.description)
        } else if let mapVal = map[char.description], mapVal != stack.popLast()  {
            return false
        }
    }
    return stack.count == 0
}

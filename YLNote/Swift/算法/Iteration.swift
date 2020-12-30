//
//  Iteration.swift
//  YLNote
//
//  Created by tangh on 2020/7/22.
//  Copyright © 2020 tangh. All rights reserved.
//

import Foundation
// 迭代
/// 中序遍历 迭代
/// - Parameter root: 根节点
func ir_inorderTraversal(_ root:TreeNode) -> [Int] {
    var stack: [TreeNode] = []
    var res: [Int] = []
    var node:TreeNode? = root
    while node != nil || !stack.isEmpty {
        if let n = node {
            stack.append(n)
            node = n.left
        } else {
            node = stack.popLast()
            if let n = node {
                res.append(n.val)
            }
            node = node?.right
        }
    }
    return res
}




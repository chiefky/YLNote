//
//  BinaryTree.swift
//  YLNote
//
//  Created by tangh on 2021/1/4.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation
class BinaryTreeNode {
    var val: Int
    var left: BinaryTreeNode?
    var right: BinaryTreeNode?
    init(val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
    
    static func createTree(values:NSArray) -> BinaryTreeNode? {
        var node:BinaryTreeNode?
        for val in values {
            if let val = val as? Int {
                node = BinaryTreeNode.addTreeNode(to: node, value: val)
            }
        }
        print("\(String(describing: node))")
        return node;
        
    }

     static func addTreeNode(to node:BinaryTreeNode?, value: Int) -> BinaryTreeNode {
        if let node = node {
            if value < node.val {
                node.left = BinaryTreeNode.addTreeNode(to: node.left, value: value)
            } else {
                node.right = BinaryTreeNode.addTreeNode(to: node.right, value: value)
            }
            print("\(String(describing: node))")
            return node;
        } else {
            print("init node \(value)")
           return BinaryTreeNode(val: value)
        }
    }

}

//MARK:算法--求二叉树深度
/// 使用递归DFS(Depth-First-Search深度优先搜索)实现
/// - Parameter rootNode: 根节点
func getBinaryTreeDepth(_ rootNode: BinaryTreeNode?) -> Int {
    guard let rootNode = rootNode else { return 0 }
    let leftDepth = getBinaryTreeDepth(rootNode.left)
    let rightDepth = getBinaryTreeDepth(rootNode.right)
    return leftDepth > rightDepth ? (leftDepth + 1) : (rightDepth + 1);
}

/// 使用栈+DFS实现
/// - Parameter rootNode: <#rootNode description#>
func getBinaryTreeDepthWithDFS(_ rootNode: BinaryTreeNode?) -> Int {
    guard let rootNode = rootNode else { return 0 }

    var stack = [(node: BinaryTreeNode,level: Int)]()
    stack.append((rootNode, 1))
    var maxDepth = -1
    while !stack.isEmpty {
        let nodeTuple = stack.removeLast()
        let node = nodeTuple.node
        let level = nodeTuple.level
        
        if let left = node.left {
            stack.append((node: left, level: level + 1))
        }
        
        if let right = node.right {
            stack.append((node: right, level: level + 1))
        }
        
        maxDepth = max(maxDepth, level)
    }
    return maxDepth
}

/// 使用队列+BFS(广度优先搜索)实现
/// - Parameter rootNode: 根节点
func getBinaryTreeDepthWithBFS(_ rootNode: BinaryTreeNode?) -> Int {
    guard let rootNode = rootNode else { return 0 }
    var queue = [BinaryTreeNode]()
    queue.append(rootNode)
    var depth = 0
    while !queue.isEmpty {
        var size = queue.count
        while size > 0 {
            let node = queue.removeFirst()
            
            if let left = node.left {
                queue.append(left)
            }
            if let right = node.right {
                queue.append(right)
            }
            
            size -= 1
        }
        depth += 1
    }
    return depth
}

//MARK:算法--求是否为平衡二叉树

/// 递归+左右子树深度差值
///  平衡树的条件：左、右子树均为平衡树且左右子树的深度差值不超过1
/// - Parameter root: 根节点
func isBalancedByRecursion(_ root:BinaryTreeNode?) -> Bool {
    guard let root = root else { return true }
    
    let leftDepth = getBinaryTreeDepthWithDFS(root.left)
    let rightDepth = getBinaryTreeDepthWithDFS(root.right)
    return isBalancedByRecursion(root.left) && isBalancedByRecursion(root.right) && abs(leftDepth - rightDepth) <= 1
}

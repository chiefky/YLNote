//
//  Recursion.swift
//  YLNote
//
//  Created by tangh on 2020/7/22.
//  Copyright © 2020 tangh. All rights reserved.
//

import Foundation
// 递归
//MARK: 递归
  // 求和
  func rc_sum(_ n: Int) -> Int {
      if n == 0 {
          return 0
      }
      return rc_sum(n-1) + n
  }
  
  /// 斐波那契数列、青蛙跳台
  /// - Parameter n: 第N阶跳台累计s多少种跳法
  func rc_fib(_ n: Int) -> Int {
        if n < 2 {
            return 1
        }
      var sum = 0,a = 1,b=1;
      for _ in 2...n {
          sum = (a + b) % 100000007;
          a = b;
          b = sum;
      }
        return sum
    }
  
 // 二叉树中序遍历
 func rc_inorderTraversal(_ root: TreeNode?) -> [Int] {
     guard let root = root else { return [] }
     var res = [Int]()
     res += rc_inorderTraversal(root.left);
     res.append(root.val)
     res += rc_inorderTraversal(root.right)
     return res
 }
  

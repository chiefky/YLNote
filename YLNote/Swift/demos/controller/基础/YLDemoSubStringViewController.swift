//
//  YLDemoSubStringViewController.swift
//  YLNote
//
//  Created by tangh on 2021/3/29.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLDemoSubStringViewController: YLDemoBaseViewController {
    deinit {
        print("\(self):\(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        testSubstring_usage()
    }
    
    // substring用法（swift 4 之后）
    func testSubstring_usage() {
          let str = "12345678"
          let length = str.count
         
          print("原始string :\(str)")

          // 截取前四位
          let pre4_a = str.index(str.startIndex, offsetBy: 4)
          let pre4_b = str.prefix(4)
          print("截取前四位 a:\(str[..<pre4_a]) ")
          print("截取前四位 b:\(pre4_b)")

          // 截取后2位（两种方法）
          let last2_a  = str.index(after: str.index(str.startIndex, offsetBy: length-3))
          let last2_b = str.index(str.endIndex, offsetBy: -2)
          let last2_c = str.suffix(2)
          print("截取后2位 a:\(str[last2_a..<str.endIndex])")
          print("截取后2位 b:\(str[last2_b..<str.endIndex])")
          print("截取后2位 c:\(last2_c)")

          // 截取中间4位，从第2位开始(二种方法)下标从0开始计数
          let startIndex = str.index(str.startIndex, offsetBy: 1)
          let endIndex = str.index(str.startIndex, offsetBy: 5)
          let mid2_4 = String(str[startIndex..<endIndex])
          print("从第2位开始,截取中间4位 a:\(mid2_4)")
      }

}

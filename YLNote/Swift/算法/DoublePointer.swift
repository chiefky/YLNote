//
//  DoublePointer.swift
//  YLNote
//
//  Created by tangh on 2020/7/22.
//  Copyright © 2020 tangh. All rights reserved.
//

import Foundation
// 双指针
//MARK: 双指针
 //字符串翻转
 func dp_reverseString(_ s: inout [Character]) {
        var left = 0, right = s.count - 1;
        while (left < right) {
            let tmp = s[left];
            s[left] = s[right];
            s[right] = tmp;
             left += 1;
            right -= 1;
        }
    }

 // 输入一个递增排序的数组的一个旋转，输出旋转数组的最小元素。例如，数组 [3,4,5,1,2] 为 [1,2,3,4,5] 的一个旋转，该数组的最小值为1。
 func dp_lookupMinInArry(_ numbers:[Int]) -> Int {
     var l = 0;
     var r = numbers.count - 1 ;
     while (l < r) {
         if (numbers[l] > numbers[l + 1]) {
             return numbers[l + 1]
         }
         if (numbers[r - 1] > numbers[r]) {
             return numbers[r]
         }
         l += 1;
         r -= 1;
     }
     return numbers[0]
 }

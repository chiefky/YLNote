//
//  note.swift
//  YLNote
//
//  Created by tangh on 2021/1/4.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation

//1：使用临时变量交换数字
/** C语言写法
void swap(int *a, int *b){
    int temp = *a;
    *a = *b;
    *b = temp;
};
*/
func swapNumbersWithTemp(a: inout Int,b: inout Int) -> Void {
    let tmp = a;
    a = b;
    b = tmp;
}

//2：使用四则运算交换数字
func swapNumbersWithArithmetic(a: inout Int,b: inout Int) -> Void {
    a = a + b;
    b = a - b;
    a = a - b;
}

//3：使用异或运算交换数字
func swapNumbersWithXOR(a: inout Int,b: inout Int) -> Void {
    a = a ^ b
    b = a ^ b
    a = a ^ b
}



//
//  YLPet.swift
//  YLNote
//
//  Created by tangh on 2021/2/14.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation
enum YLGender {
    case female
    case male
    case unknown
}
/**
 使用单例的弊端：
 单例状态的混乱
 由于单例是共享的，所以当使用单例时，程序员无法清楚的知道单例当前的状态。
 当用户登录，由一个实例负责当前用户的各项操作。但是由于共享，当前用户的状态很可能已经被其他实例改变，而原来的实例仍然不知道这项改变。如果想要解决这个问题，实例就必须对单例的状态进行监控。Notifications 是一种方式，但是这样会使程序过于复杂，同时产生很多无谓的通知。
 测试困难
 测试困难主要是由于单例状态的混乱而造成的。因为单例的状态可以被其他共享的实例所修改，所以进行需要依赖单例的测试时，很难从一个干净、清晰的状态开始每一个 test case
 单例访问的混乱
 由于单例时全局的，所以无法对访问权限作出限定。程序任何位置、任何实例都可以对单例进行访问，这将容易造成管理上的混乱。
 */
/// 第一种方式初始化单例
let doggy = YLPet(id:"XD00000001")

class YLPet {
    static let catty = YLPet(id: "XD00000002") // 第二种方式初始化单例
    let petId:String
    var name:String?
    var gender: YLGender = .unknown

    init(id:String) {
        petId = id
    }
    
    // 第三种方式初始化单例(让单例在闭包（Closure）中初始化，同时加入类方法来获取单例。)
    private static let petty: YLPet = {
        let rab = YLPet(id: "XD000000000")
        rab.name = "松茸"
        rab.gender = .female
        // ....do something
        return rab
    }()
    
    class func `default`() -> YLPet {
        return petty
    }
    
}

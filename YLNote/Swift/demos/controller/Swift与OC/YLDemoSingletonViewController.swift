//
//  YLDemoSingletonViewController.swift
//  YLNote
//
//  Created by tangh on 2021/3/29.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLDemoSingletonViewController: YLDemoBaseViewController {
    deinit {
        print("\(self):\(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        test_singleton()
    }
    

    /// 单例的使用
     func test_singleton() {
//        print("第一种方式初始化单例用法：\(doggy.petId)")
//        print("第二种方式初始化单例用法：\(YLPet.catty.petId)")
//        print("第三种方式初始化单例用法：\(YLPet.default().petId)")

        changePetName()
    }
    
    func changePetName() {
        let concurrentQueue = DispatchQueue(label: "swiftlee.concurrent.queue", attributes: .concurrent)

        for i in 1...100 {
            concurrentQueue.async {
                print("Task \(i) started---\(Thread.current)")
                // Do some work..
                doggy.name = "doggy" + "\(i)"
                print("Task  \(i)  finished---\(Thread.current)")

            }
        }

        print(doggy.name ?? "")

    }
}

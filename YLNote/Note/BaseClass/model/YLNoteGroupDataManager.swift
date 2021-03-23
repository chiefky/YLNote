//
//  YLNoteFoundationManager.swift
//  YLNote
//
//  Created by tangh on 2021/3/22.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
import YYModel

class YLNoteGroupDataManager: NSObject {
    
    var foundationDatas: NSDictionary {
        return YLFileManager.jsonParse(withLocalFileName: "Foundation") as NSDictionary;
    }
    var uikitDatas: NSDictionary {
        return YLFileManager.jsonParse(withLocalFileName: "UIKit") as NSDictionary
    }
    var webDatas: NSDictionary {
        return YLFileManager.jsonParse(withLocalFileName: "Web") as NSDictionary
    }
    var runloopDatas: NSDictionary {
        return YLFileManager.jsonParse(withLocalFileName: "Runloop") as NSDictionary
    }
    var runtimeDatas: NSDictionary {
        return YLFileManager.jsonParse(withLocalFileName: "Runtime") as NSDictionary
    }
    
    var messageDatas: NSDictionary {
        return YLFileManager.jsonParse(withLocalFileName: "Message") as NSDictionary
    }
    
    var memoryDatas: NSDictionary {
        return YLFileManager.jsonParse(withLocalFileName: "Memory") as NSDictionary
    }
    var optimizationDatas: NSDictionary {
        return YLFileManager.jsonParse(withLocalFileName: "ProgramOptimization") as NSDictionary
    }
    var threadDatas: NSDictionary {
        return YLFileManager.jsonParse(withLocalFileName: "Thread") as NSDictionary
    }

    func pushToVC(_ vc: UIViewController? ) {
        if let vc = vc {
            let currentVC = YLWindowLoader.getCurrentVC()
            if currentVC.navigationController != nil {
                UIView.setAnimationsEnabled(true)
                currentVC.navigationController?.pushViewController(vc, animated: true)
            } else {
                let naviVC = UINavigationController()
                UIView.setAnimationsEnabled(true)
                naviVC.pushViewController(vc, animated: true)
            }
        }
    }
    @objc func pushToDemo(with item: YLNoteItem) {
        let demoClass = item.itemClass
        let vcClass: AnyClass? = demoClass.classType ? NSClassFromString("YLNote" + "." + demoClass.className) : NSClassFromString(demoClass.className)
        guard let typeClass = vcClass as? UIViewController.Type else {
            print("vcClass不能当做UIViewController")
            return
        }
        var myVC: UIViewController
        if demoClass.xibType { //或者加载xib;
            myVC = typeClass.init(nibName: demoClass.className, bundle: nil)
        } else {
            if let _ = typeClass as? YLArticleMDViewController.Type {
                let artVC = YLArticleMDViewController()
                artVC.fileName = demoClass.atrticleTitle
                myVC = artVC
            } else {
                myVC = typeClass.init()
            }
        }
        
        myVC.title = demoClass.atrticleTitle.isEmpty ? (demoClass.title.isEmpty ? item.itemDesc : demoClass.title ) : demoClass.atrticleTitle
        pushToVC(myVC)
    }
    
    /// MARK: Foundation
    @objc func testNilAndNSNull() {
        YLAlertManager.showAlert(withTitle: "", message: "nil、NIL 可以说是等价的，都代表内存中一块空地址。\n NSNULL 代表一个指向 nil 的对象。", actionTitle: "OK", handler: nil)
    }
    
    /**
     相同点:
    instancetype 和 id 都是万能指针，指向对象。
    不同点：
    1.id 在编译的时候不能判断对象的真实类型，instancetype 在编译的时候可以判断对象的真实类型。
    2.id 可以用来定义变量，可以作为返回值类型，可以作为形参类型；instancetype 只能作为返回值类型。
     */
    @objc func testIdAndInstancetype() {
        let title = "id & instancetype"
        let msg = " 相同点:instancetype 和 id 都是万能指针，指向对象。\n不同点： 1.id 在编译的时候不能判断对象的真实类型，instancetype 在编译的时候可以判断对象的真实类型。\n    2.id 可以用来定义变量，可以作为返回值类型，可以作为形参类型；instancetype 只能作为返回值类型"
        YLAlertManager.showAlert(withTitle: title, message: msg, actionTitle: "OK", handler: nil)
    }
    
    @objc func testStructAndClass() {
        let title = "值类型&引用类型"
        let msg = "类： 引用类型（位于栈上面的指针（引用）和位于堆上的实体对象）\n结构体：值类型（实例直接位于栈中）";
        YLAlertManager.showAlert(withTitle: title, message: msg, actionTitle: "OK", handler: nil)
    }
    
    @objc func testSelfAndSuper_classFunc() {
        let plumDict = YLFileManager.jsonParse(withLocalFileName: "TRex")// [YLFileManager jsonParseWithLocalFileName:@"TRex"];
        let TRex = YLDinodsaul.yy_model(with: plumDict)
        TRex?.testClass()
    }

    /// MARK: UIKit
    /**
     因为UIView依赖于CALayer提供的内容，而CALayer又依赖于UIView提供的容器来显示绘制的内容，所以UIView的显示可以说是CALayer要显示绘制的图形。当要显示时，CALayer会准备好一个CGContextRef(图形上下文)，然后调用它的delegate(这里就是UIView)的drawLayer:inContext:方法，并且传入已经准备好的CGContextRef对象，在drawLayer:inContext:方法中UIView又会调用自己的drawRect:方法。
         我们可以把UIView的显示比作“在电脑上使用播放器播放U盘上得电影”，播放器相当于UIView，视频解码器相当于CALayer，U盘相当于CGContextRef，电影相当于绘制的图形信息。不同的图形上下文可以想象成不同接口的U盘

     注意：当我们需要绘图到根层上时，一般在drawRect:方法中绘制，不建议在drawLayer:inContext:方法中绘图
     */
    @objc func testUIView() {
        YLAlertManager.showAlert(withTitle: "", message: "因为UIView依赖于CALayer提供的内容，而CALayer又依赖于UIView提供的容器来显示绘制的内容，所以UIView的显示可以说是CALayer要显示绘制的图形。当要显示时，CALayer会准备好一个CGContextRef(图形上下文)，然后调用它的delegate(这里就是UIView)的drawLayer:inContext:方法，并且传入已经准备好的CGContextRef对象，在drawLayer:inContext:方法中UIView又会调用自己的drawRect:方法。", actionTitle: "OK", handler: nil)
    }
}

extension YLNoteGroupDataManager: YLGroupDataSource {
    var name: String {
        return String(describing: YLNoteGroupDataManager.self)
    }

    @objc func dataGroup() -> [YLNoteGroup] {
        let foundation = YLNoteGroup.yy_model(with: foundationDatas as! [AnyHashable : Any]) ?? YLNoteGroup.init(name: "foundation", questions: [])
        
        let uikit = YLNoteGroup.yy_model(with: uikitDatas as! [AnyHashable : Any]) ?? YLNoteGroup.init(name: "uikit", questions: [])
        let web = YLNoteGroup.yy_model(with: webDatas as! [AnyHashable : Any]) ?? YLNoteGroup.init(name: "web", questions: [])
        let runloop = YLNoteGroup.yy_model(with: runloopDatas as! [AnyHashable : Any]) ?? YLNoteGroup.init(name: "runloop", questions: [])

        let runtime = YLNoteGroup.yy_model(with: runtimeDatas as! [AnyHashable : Any]) ?? YLNoteGroup.init(name: "runtime", questions: [])
        let message = YLNoteGroup.yy_model(with: messageDatas as! [AnyHashable : Any]) ?? YLNoteGroup.init(name: "message", questions: [])
        let memory = YLNoteGroup.yy_model(with: memoryDatas as! [AnyHashable : Any]) ?? YLNoteGroup.init(name: "memory", questions: [])
        let optimization = YLNoteGroup.yy_model(with: optimizationDatas as! [AnyHashable : Any]) ?? YLNoteGroup.init(name: "optimization", questions: [])
        let thread = YLNoteGroup.yy_model(with: threadDatas as! [AnyHashable : Any]) ?? YLNoteGroup.init(name: "thread", questions: [])
        return [foundation,uikit,web,runloop,runtime,message,memory,optimization,thread]
    }
    

}

extension YLNoteGroupDataManager: YLGroupDataDelegate {
    func didSelectRow(with item: YLNoteItem) {
//        var count: UInt32 = 0;
//        let cls: AnyClass? = object_getClass(self);
//
//        print("===开始获取");
//           let methodList = class_copyMethodList(cls, &count);
//           for item in 0..<count {
//               let meth = methodList![Int(item)];
//               let m = method_getName(meth);
//               let mStrl = NSStringFromSelector(m);
//               print("方法：\(mStrl)");
//           }
//           print("===结束获取");
//
       
        let functionName = item.functionName
        if functionName.contains(":") {
          let funcc = NSSelectorFromString(functionName)
          self.perform(funcc, with: item)
        } else {
            let function = Selector(functionName)
            guard self.responds(to: function) else { return }
            self.perform(function)
        }
    }
}

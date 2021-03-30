//
//  YLDemoSeparatorViewController.swift
//  YLNote
//
//  Created by tangh on 2021/3/29.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

/// split(separator:) is faster than components(separatedBy:). (split方法效率更高)
class YLDemoSeparatorViewController: UIViewController {
    let text = "Swift 中分割字符串有两种方法：\n 方法一： 先通过'split'方法切割成[Substring];\n 然后通过'compactMap'方法将substring转换成[String]。\n (如果取某个值的话直接将substring转成string即可，无需转成[String])\n 方法二： 使用'components'方法直接分割 得到[String]。"
    @IBOutlet weak var tipLabel: UILabel!
    var newString = ""
        
    deinit {
        print("\(self):\(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipLabel.text = text
    }    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for _ in 1..<9999 {
            newString.append(oriStr)
        }
    }

    @IBAction func action1(_ sender: Any) {
        let methodStart = Date()
        let arraySubstrings = newString.split(separator: " ")
        print("Execution time Split By Split: \(Date().timeIntervalSince(methodStart))")
        
        let _:[String] = arraySubstrings.compactMap { (item) -> String in
            return "\(item)"
        }
        print("Execution time Separated By Split + compactMap: \(Date().timeIntervalSince(methodStart))")
    }
    
    let oriStr = "One of those refinements is to the String API, which has been made a lot easier to use (while also gaining power) in Swift 4. In past versions of Swift, the String API was often brought up as an example of how Swift sometimes goes too far in favoring correctness over ease of use, with its cumbersome way of handling characters and substrings. This week, let’s take a look at how it is to work with strings in Swift 4, and how we can take advantage of the new, improved API in various situations. Sometimes we have longer, static strings in our apps or scripts that span multiple lines. Before Swift 4, we had to do something like inline \n across the string, add an appendOnNewLine() method through an extension on String or - in the case of scripting - make multiple print() calls to add newlines to a long output. For example, here is how TestDrive’s printHelp() function (which is used to print usage instructions for the script) looks like in Swift 3  One of those refinements is to the String API, which has been made a lot easier to use (while also gaining power) in Swift 4. In past versions of Swift, the String API was often brought up as an example of how Swift sometimes goes too far in favoring correctness over ease of use, with its cumbersome way of handling characters and substrings. This week, let’s take a look at how it is to work with strings in Swift 4, and how we can take advantage of the new, improved API in various situations. Sometimes we have longer, static strings in our apps or scripts that span multiple lines. Before Swift 4, we had to do something like inline \n across the string, add an appendOnNewLine() method through an extension on String or - in the case of scripting - make multiple print() calls to add newlines to a long output. For example, here is how TestDrive’s printHelp() function (which is used to print usage instructions for the script) looks like in Swift 3"
        
    
     @IBAction func action2(_ sender: Any) {
        let methodStart = Date()
        let _ = newString.components(separatedBy: " ")
        print("Execution time Separated By components: \(Date().timeIntervalSince(methodStart))")
    }


}

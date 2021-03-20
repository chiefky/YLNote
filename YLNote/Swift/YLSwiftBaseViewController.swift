//
//  YLSwiftBaseViewController.swift
//  YLNote
//
//  Created by tangh on 2021/2/13.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLSwiftBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        testSeparatorString()
    }
    

    // MARK: - func
    func testSeparatorString() {
        var str = """
                       One of those refinements is to the String API, which has been made a lot easier to use (while also gaining power) in Swift 4. In past versions of Swift, the String API was often brought up as an example of how Swift sometimes goes too far in favoring correctness over ease of use, with its cumbersome way of handling characters and substrings. This week, let’s take a look at how it is to work with strings in Swift 4, and how we can take advantage of the new, improved API in various situations. Sometimes we have longer, static strings in our apps or scripts that span multiple lines. Before Swift 4, we had to do something like inline \n across the string, add an appendOnNewLine() method through an extension on String or - in the case of scripting - make multiple print() calls to add newlines to a long output. For example, here is how TestDrive’s printHelp() function (which is used to print usage instructions for the script) looks like in Swift 3  One of those refinements is to the String API, which has been made a lot easier to use (while also gaining power) in Swift 4. In past versions of Swift, the String API was often brought up as an example of how Swift sometimes goes too far in favoring correctness over ease of use, with its cumbersome way of handling characters and substrings. This week, let’s take a look at how it is to work with strings in Swift 4, and how we can take advantage of the new, improved API in various situations. Sometimes we have longer, static strings in our apps or scripts that span multiple lines. Before Swift 4, we had to do something like inline \n across the string, add an appendOnNewLine() method through an extension on String or - in the case of scripting - make multiple print() calls to add newlines to a long output. For example, here is how TestDrive’s printHelp() function (which is used to print usage instructions for the script) looks like in Swift 3
                 """

           var newString = String()
           for _ in 1..<9999 {
               newString.append(str)
           }

           var methodStart = Date()

        _  = newString.components(separatedBy: " ")
           print("Execution time Separated By: \(Date().timeIntervalSince(methodStart))")

           methodStart = Date()
           _ = newString.split(separator: " ")
           print("Execution time Split By: \(Date().timeIntervalSince(methodStart))")
    }
}

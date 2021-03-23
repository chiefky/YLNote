//
//  YLNoteDataGroup.swift
//  YLNote
//
//  Created by tangh on 2021/3/22.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit
import YYModel

@objc class YLNoteGroupData: NSObject {
    @objc var groupName = ""
    @objc var groupItems = [YLNoteCellData]()
    
    @objc func modelCustomPropertyMapper() -> NSDictionary {
        return ["groupName": "group",
                 "groupItems": "questions"];
    }
}

@objc class YLNoteCellData: NSObject {
    var cellName = ""
    var functionName: String = ""
    func modelCustomPropertyMapper() -> NSDictionary {
        return ["name": "class",
                 "functionName": "answer"];
    }

}

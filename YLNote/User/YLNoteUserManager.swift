//
//  YLNoteUser.swift
//  YLNote
//
//  Created by tangh on 2021/3/25.
//  Copyright © 2021 tangh. All rights reserved.
//

import UIKit

class YLNoteUserManager: NSObject {
    private static var defaultManager: YLNoteUserManager {
        let instance = YLNoteUserManager()
        return instance
    }
    
    @objc class func shared() -> YLNoteUserManager {
        return defaultManager
    }
    
    var currentUser: YLNoteUser?
    
}

struct YLNoteUser {
    var name: String
    var gender: String
    var age: UInt
    var tel: String
    var address: String
    var avatarUrl: String?
    
}

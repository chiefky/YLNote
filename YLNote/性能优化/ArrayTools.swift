//
//  ArrayTools.swift
//  YLNote
//
//  Created by tangh on 2021/2/3.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

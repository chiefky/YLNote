//
//  NameSpaceWapper.swift
//  YLNote
//
//  Created by tangh on 2021/2/25.
//  Copyright © 2021 tangh. All rights reserved.
//

import Foundation

public protocol NamespaceWrappable {
    associatedtype WrapperType
    var yl: WrapperType { get }
    static var yl: WrapperType.Type { get }
}

public extension NamespaceWrappable {
    var yl: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }

    static var yl: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

public protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}

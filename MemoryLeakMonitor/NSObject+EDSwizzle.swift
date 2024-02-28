//
//  NSObject+EDSwizzle.swift
//  EddidOne
//
//  Created by chenfanfang  on 2020/4/17.
//  Copyright © 2020 chenfanfang . All rights reserved.
//

import UIKit

/// 方法交换的结果
public enum EDSwizzleResult {
    /// 方法交换成功
    case succeed
    /// 方法交换失败：原始方法不存在
    case originMethodNotFound
    /// 方法交换失败: 新方法不存在
    case newMethodNotFound
}

/// 方法交换的拓展
public extension NSObject {
    @discardableResult
    //=================================================================
    //                         交换对象方法
    //=================================================================
    // MARK: - 交换对象方法
    /// 交换对象方法
    /// - Parameters:
    ///   - origSelector: 原始方法
    ///   - newSelector: 新方法
    /// - Returns: 方法交换的结果
    class func swizzleInstanceMethod(origSelector: Selector, newSelector: Selector) -> EDSwizzleResult {
        return self.swizzleMethod(origSelector: origSelector,
                                  newSelector: newSelector,
                                  inAlterClass: self.classForCoder(),
                                  isClassMethod: false)
    }
    /// 交换类方法
    /// - Parameters:
    ///   - origSelector: 原始方法
    ///   - newSelector: 新方法
    /// - Returns: 方法交换的结果
    class func swizzleClassMethod(origSelector: Selector, newSelector: Selector) -> EDSwizzleResult {
        return self.swizzleMethod(origSelector: origSelector,
                                  newSelector: newSelector,
                                  inAlterClass: self.classForCoder(),
                                  isClassMethod: true)
    }
    /// 交换对象方法
    /// - Parameters:
    ///   - origSelector: 原始方法
    ///   - newSelector: 新方法
    ///   - alterClass: 需要交换方法到哪个类
    /// - Returns: 方法交换的结果
    class func swizzleInstanceMethod(origSelector: Selector, newSelector: Selector, inAlterClass alterClass: AnyClass) -> EDSwizzleResult {
        return self.swizzleMethod(origSelector: origSelector,
                                  newSelector: newSelector,
                                  inAlterClass: alterClass,
                                  isClassMethod: false)
    }
    /// 交换类方法
    /// - Parameters:
    ///   - origSelector: 原始方法
    ///   - newSelector: 新方法
    ///   - alterClass: 需要交换方法到哪个类
    /// - Returns: 方法交换的结果
    class func swizzleClassMethod(origSelector: Selector, newSelector: Selector, inAlterClass alterClass: AnyClass) -> EDSwizzleResult {
        return self.swizzleMethod(origSelector: origSelector,
                                  newSelector: newSelector,
                                  inAlterClass: alterClass,
                                  isClassMethod: true)
    }
    /// 交换方法
    /// - Parameters:
    ///   - origSelector: 原始方法
    ///   - newSelector: 新方法
    ///   - alterClass: 需要交换方法到哪个类
    ///   - isClassMethod: 需要交换的方法是否是类方法
    /// - Returns: 方法交换的结果
    private class func swizzleMethod(origSelector: Selector, newSelector: Selector!, inAlterClass alterClass: AnyClass!, isClassMethod: Bool) -> EDSwizzleResult {
        /// 需要更改到哪个类
        var alterClass: AnyClass? = alterClass
        /// 原本类
        var origClass: AnyClass = self.classForCoder()
        if isClassMethod {
            /// 类方法存在元类中, 所以可以认为类方法就是元类 的 对象方法？？？？？？？？？
            alterClass = object_getClass(alterClass)
            guard let tempClass = object_getClass(self.classForCoder()) else {
                return .originMethodNotFound
            }
            origClass = tempClass
        }
        return mainSwizzleMethod(origClass: origClass, origSelector: origSelector, newSelector: newSelector, inAlterClass: alterClass)
    }
}

/// 方法交换
/// - Parameters:
///   - origClass: 原始类：需要进行方法交换的那个类
///   - origSelector: 原始方法
///   - newSelector: 新方法
///   - alterClass: 新方法所在的类
/// - Returns: 方法交换的结果
private func mainSwizzleMethod(origClass: AnyClass!, origSelector: Selector, newSelector: Selector!, inAlterClass alterClass: AnyClass!) -> EDSwizzleResult {
    guard  let origMethod: Method = class_getInstanceMethod(origClass, origSelector) else {
        return EDSwizzleResult.originMethodNotFound
    }
    guard let altMethod: Method = class_getInstanceMethod(alterClass, newSelector) else {
        return EDSwizzleResult.newMethodNotFound
    }
    _ = class_addMethod(origClass, origSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
    _ = class_addMethod(alterClass, newSelector, method_getImplementation(altMethod), method_getTypeEncoding(altMethod))
    method_exchangeImplementations(origMethod, altMethod)
    return EDSwizzleResult.succeed
}

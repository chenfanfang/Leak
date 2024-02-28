//
//  NSObject+EDLeaksMonitor.swift
//  EddidOne
//
//  Created by chenfanfang  on 2020/4/17.
//  Copyright © 2020 chenfanfang . All rights reserved.
//

import UIKit

/// 视图栈属性关联的key
private var kEDMemoryLeakViewStackKey: Void?
/// 对象唯一标识栈关联的key
private var kEDMemoryLeakUintptrStack: Void?
var isOnTip: Bool = false
extension NSObject {
    //=================================================================
    //                              视图栈
    //=================================================================
    // MARK: - 视图栈
    var viewStack: [String] {
        get {
            let stack: [String]? = (objc_getAssociatedObject(self, &kEDMemoryLeakViewStackKey) as? [String])
            let newStack = stack ?? [NSStringFromClass(self.classForCoder)]
            return newStack
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kEDMemoryLeakViewStackKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    //=================================================================
    //                          对象唯一标识栈信息
    //=================================================================
    // MARK: - 对象唯一标识栈信息
    var uintptrStack: [String] {
        get {
            let stack: [String]? = (objc_getAssociatedObject(self, &kEDMemoryLeakUintptrStack) as? [String])
            let newStack = stack ?? [String.init(format: "%p", self)]
            return newStack
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kEDMemoryLeakUintptrStack, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    /// 交给子类去重写(工具内部重写，用户可以忽略此函数)
    @objc class func setupForLeaksMonitor() {
    }
    //=================================================================
    //                        对象将要被销毁
    //=================================================================
    // MARK: - 对象将要被销毁
    /// 将要被销毁，若哪个类不需要检测内存泄漏，则可重写此方法，并且返回 false即可
    @discardableResult
    @objc func willDeInit() -> Bool {
        let className: String = NSStringFromClass(self.classForCoder)
        // 根据白名单过滤
        if EDLeaksMonitor.getClassNamesWhiteList().contains(className) {
            return false
        }
        // 3秒内进行内存泄漏检测
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            [weak self] in
            self?.noticeMemoryLeak()
        }
        return true
    }
    /// 通知内存泄漏
    func noticeMemoryLeak() {
        if isOnTip == true {
            return
        }
        isOnTip = true
        let tipTitle: String = ""
        + "\n\n=================================================================\n"
        + "                         疑似内存泄漏\n"
        + "=================================================================\n"
        print(tipTitle)
        let viewStackArray = self.viewStack
        print("视图栈信息:\n")
        for (index, value) in viewStackArray.enumerated() {
            print(value)
            if index != viewStackArray.count - 1 {
                print("\n   ↓\n")
            }
        }
        print("\n\n=================================================================\n\n")
        print("若因为单例或者缓存需求,请重写该类的willDeInit，直接返回false")
        print("或者通过EDLeaksMonitor将该类添加至白名单")
        print("\n\n=================================================================\n\n")
        // 弹窗提示
        let alertVc = UIAlertController(title: "温馨提示", message: "疑似内存泄漏,请注意查看控制台信息", preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "知道了", style: .cancel, handler: { _ in
            isOnTip = false
        }))
        let currentVc = EDTools.gainCurrentViewController()
        
        currentVc?.present(alertVc, animated: true)
    }
    //=================================================================
    //                          将要释放child
    //=================================================================
    // MARK: - 将要释放child
    func willReleaseChild(child: NSObject?) {
        guard let child = child else {
            return
        }
        willReleaseChildren(children: [child])
    }
    func willReleaseChildren(children: [NSObject]) {
        let currentViewStack = self.viewStack
        let currentUintptrStack = self.uintptrStack
        for child in children {
            // 构建child的视图栈信息
            let className = NSStringFromClass(child.classForCoder)
            var newViewStack = currentViewStack
            newViewStack.append(className)
            child.viewStack = newViewStack
            // 构建对象唯一标识栈信息
            let addressString = String.init(format: "%p", child)
            var newUintptrStack = currentUintptrStack
            newUintptrStack.append(addressString)
            child.uintptrStack = newUintptrStack
            child.willDeInit()
        }
    }
}

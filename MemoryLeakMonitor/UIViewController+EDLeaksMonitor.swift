//
//  UIViewController+EDLeaksMonitor.swift
//  EddidOne
//
//  Created by chenfanfang  on 2020/4/17.
//  Copyright © 2020 chenfanfang . All rights reserved.
//

import UIKit

public var kEDMemoryLeakHasBeenPopedKey: Void?

extension UIViewController {
    override class func setupForLeaksMonitor() {
        var origSEL: Selector
        var newSEL: Selector
        /// dismiss
        origSEL = #selector(UIViewController.dismiss(animated:completion:))
        newSEL = #selector(UIViewController.leaksMonitorDismiss(animated:completion:))
        UIViewController.swizzleInstanceMethod(origSelector: origSEL, newSelector: newSEL)
        /// viewDidDisappear
        origSEL = #selector(UIViewController.viewDidDisappear(_:))
        newSEL = #selector(UIViewController.leakMonitorViewDidDisappear(_:))
        UIViewController.swizzleInstanceMethod(origSelector: origSEL, newSelector: newSEL)
        // viewWillAppear
        origSEL = #selector(UIViewController.viewWillAppear(_:))
        newSEL = #selector(UIViewController.leakMonitorViewWillAppear(_:))
        UIViewController.swizzleInstanceMethod(origSelector: origSEL, newSelector: newSEL)
    }
    //=================================================================
    //                              dismiss
    //=================================================================
    // MARK: - dismiss
    @objc open func leaksMonitorDismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.leaksMonitorDismiss(animated: flag, completion: completion)
        /// 以下操作主要是处理 UIAlertController dismiss造成的问题
        var dismissedViewController: UIViewController? = self.presentedViewController
        // 如果没有子控制器被当前控制器给present出来  并且  当前控制器的父控制器还存在(也就是父控制器把当前控制器present出来)
        if dismissedViewController == nil && self.presentingViewController != nil {
            dismissedViewController = self
        }
        if let controller = dismissedViewController {
            controller.willDeInit()
        }
    }
    //=================================================================
    //                       viewDidDisappear
    //=================================================================
    // MARK: - viewDidDisappear
    @objc open func leakMonitorViewDidDisappear(_ animated: Bool) {
        self.leakMonitorViewDidDisappear(animated)
        let hasBeenPoped: Bool = objc_getAssociatedObject(self, &kEDMemoryLeakHasBeenPopedKey) as? Bool ?? false
        if hasBeenPoped == true {
            self.willDeInit()
        }
    }
    //=================================================================
    //                        viewWillAppear
    //=================================================================
    // MARK: - viewWillAppear
    @objc open func leakMonitorViewWillAppear(_ animated: Bool) {
        self.leakMonitorViewWillAppear(animated)
        objc_setAssociatedObject(self, &kEDMemoryLeakHasBeenPopedKey, false, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
    }
    //=================================================================
    //                          将要被销毁
    //=================================================================
    // MARK: - 将要被销毁
    @discardableResult
    override func willDeInit() -> Bool {
        // 若父级不进行相应的销毁判断处理，这子类也不进行处理
        if super.willDeInit() == false {
            return false
        }
        // 将释放子控制器
        self.willReleaseChildren(children: self.children)
        // 将释放模态出来的控制器
        self.willReleaseChild(child: self.presentedViewController)
        if self.isViewLoaded {
            // 释放View
            self.willReleaseChild(child: self.view)
        }
        return true
    }
}

//
//  UINavigationController+EDLeaksMonitor.swift
//  EddidOne
//
//  Created by chenfanfang  on 2020/4/20.
//  Copyright © 2020 chenfanfang . All rights reserved.
//

import UIKit

extension UINavigationController {
    override class func setupForLeaksMonitor() {
        var origSEL: Selector
        var newSEL: Selector
        // popViewController
        origSEL = #selector(UINavigationController.popViewController(animated:))
        newSEL = #selector(UINavigationController.leaksMonitorPopViewController(animated:))
        UINavigationController.swizzleInstanceMethod(origSelector: origSEL, newSelector: newSEL)
        // popToViewController
        origSEL = #selector(UINavigationController.popToViewController(_:animated:))
        newSEL = #selector(UINavigationController.leaksMonitorPopToViewController(_:animated:))
        UINavigationController.swizzleInstanceMethod(origSelector: origSEL, newSelector: newSEL)
        // popToRootViewController
        origSEL = #selector(UINavigationController.popToRootViewController(animated:))
        newSEL = #selector(UINavigationController.leaksMonitorPopToRootViewController(animated:))
        UINavigationController.swizzleInstanceMethod(origSelector: origSEL, newSelector: newSEL)
    }
    //=================================================================
    //                      popViewController
    //=================================================================
    // MARK: - popViewController
    @objc open func leaksMonitorPopViewController(animated: Bool) -> UIViewController? {
        let poppedViewController: UIViewController? = self.leaksMonitorPopViewController(animated: animated)
        guard let controller = poppedViewController else {
            return nil
        }
        objc_setAssociatedObject(controller, &kEDMemoryLeakHasBeenPopedKey, true, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        return controller
    }
    //=================================================================
    //                         popToViewController
    //=================================================================
    // MARK: - popToViewController
    @objc open func leaksMonitorPopToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let poppedViewControllers = self.leaksMonitorPopToViewController(viewController, animated: animated)
        guard let controllers = poppedViewControllers else {
            return nil
        }
        for subControlelr in controllers {
            subControlelr.willDeInit()
        }
        return controllers
    }
    //=================================================================
    //                       popToRootViewController
    //=================================================================
    // MARK: - popToRootViewController
    @objc open func leaksMonitorPopToRootViewController(animated: Bool) -> [UIViewController]? {
        let poppedViewControllers = self.leaksMonitorPopToRootViewController(animated: animated)
        guard let controllers = poppedViewControllers else {
            return nil
        }
        for subControlelr in controllers {
            subControlelr.willDeInit()
        }
        return controllers
    }
    //=================================================================
    //                          将要被销毁
    //=================================================================
    // MARK: - 将要被销毁
    override func willDeInit() -> Bool {
        if super.willDeInit() == false {
            return false
        }
        self.willReleaseChild(child: self.viewControllers as NSObject)
        return true
    }
}

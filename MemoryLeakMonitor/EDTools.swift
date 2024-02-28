//
//  EDTools.swift
//  Sample
//
//  Created by 陈蕃坊 on 2024/2/28.
//

import UIKit

class EDTools: NSObject {
    //=================================================================
    //                              公开方法
    //=================================================================
    // MARK: - 公开方法
    /// 获取当前显示的控制器
    static func gainCurrentViewController() -> UIViewController? {
        return gainCurrentViewController(fromVC: UIApplication.shared.keyWindow?.rootViewController)
    }
    //=================================================================
    //                              私有方法
    //=================================================================
    // MARK: - 私有方法
    /// 获取当前显示的控制器内部方法
    /// - Parameter FromVC: 开始查找的VC
    private static func gainCurrentViewController(fromVC: UIViewController?) -> UIViewController? {
        if fromVC?.presentedViewController != nil {
            return gainCurrentViewController(fromVC: fromVC?.presentedViewController)
        } else if fromVC is UISplitViewController {
            let svc = fromVC as? UISplitViewController
            if (svc?.viewControllers.count ?? 0) > 0 {
                return gainCurrentViewController(fromVC: svc?.viewControllers.last)
            } else {
                return fromVC
            }
        } else if fromVC is UINavigationController {
            let svc = fromVC as? UINavigationController
            if (svc?.viewControllers.count ?? 0) > 0 {
                return gainCurrentViewController(fromVC: svc?.topViewController)
            } else {
                return fromVC
            }
        } else if fromVC is UITabBarController {
            let svc = fromVC as? UITabBarController
            if svc?.viewControllers?.count ?? 0 > 0 {
                return gainCurrentViewController(fromVC: svc?.selectedViewController)
            } else {
                return fromVC
            }
        } else {
            return fromVC
        }
    }
}

//
//  EddidOne.swift
//  EddidOne
//
//  Created by chenfanfang  on 2020/4/17.
//  Copyright © 2020 chenfanfang . All rights reserved.
//

import UIKit

/// 是否已经初始化
var setuped: Bool = false

class EDLeaksMonitor: NSObject {
    /// 白名单列表
    static var classNamesWhitelist: Set<String> = {
        var whitelist: Set<String> = [
            "UIFieldEditor", // UIAlertControllerTextField
            "UINavigationBar",
            "_UIAlertControllerActionView",
            "_UIVisualEffectBackdropView",
            "UIImagePickerController",
            "UITextField",
            "UIDocumentMenuViewController",
            "UIDocumentPickerViewController",
            "UANavigationController"
        ]
        return whitelist
    }()
    //=================================================================
    //                            启动
    //=================================================================
    // MARK: - 启动
    class func setup() {
        #if DEBUG
        if setuped == true {
            return
        }
        setuped = true
        UIViewController.setupForLeaksMonitor()
        UINavigationController.setupForLeaksMonitor()
        #endif
    }
    //=================================================================
    //                           白名单
    //=================================================================
    // MARK: - 白名单
    /// 获取白名单列表
    class func getClassNamesWhiteList() -> Set<String> {
        return classNamesWhitelist
    }
    /// 添加名至白名单
    class func addClassNamesToWhitelist(names: [String]) {
        for name in names {
            classNamesWhitelist.insert(name)
        }
    }
}

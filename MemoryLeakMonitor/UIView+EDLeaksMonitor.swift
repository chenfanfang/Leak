//
//  UIView+EddidOne.swift
//  EddidOne
//
//  Created by chenfanfang  on 2020/4/17.
//  Copyright © 2020 chenfanfang . All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    override func willDeInit() -> Bool {
        if super.willDeInit() == false {
            return false
        }
        self.willReleaseChildren(children: self.subviews)
        return true
    }
}

//
//  LeekView.swift
//  Sample
//
//  Created by 陈蕃坊 on 2024/2/28.
//

import UIKit

class LeakTool {
    var view: UIView?
}

class LeekView: UILabel {
    var tool: LeakTool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .orange
        // 循环引用，返回的时候会造成内存泄漏
        self.tool = LeakTool()
        self.tool?.view = self
        
        self.text = "我是LeekView，我会内存泄露，不信你点击dismiss试下"
        self.contentMode = .center
        self.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

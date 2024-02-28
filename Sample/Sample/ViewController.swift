//
//  ViewController.swift
//  Sample
//
//  Created by chenfanfang on 2024/2/28.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("跳转到会有内存泄露的界面", for: .normal)
        btn.addTarget(self, action: #selector(pushToWillLeakPage), for: .touchUpInside)
        btn.frame = CGRect(x: 20, y: 100, width: 300, height: 50)
        self.view.addSubview(btn)
    }
    
    @objc private func pushToWillLeakPage() {
        let vc = TestViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}


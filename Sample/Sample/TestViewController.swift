//
//  LeakViewController.swift
//  Sample
//
//  Created by chenfanfang on 2024/2/28.
//

import UIKit



class TestViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemPink
        
        let btn = UIButton()
        btn.setTitle("dismiss", for: .normal)
        btn.backgroundColor = .black
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
        btn.addTarget(self, action: #selector(dismissBtnClick), for: .touchUpInside)
        self.view.addSubview(btn)
        
        
        let leakView = LeekView()
        leakView.frame = CGRect(x: 100, y: 250, width: 200, height: 200)
        self.view.addSubview(leakView)
    }
    
    @objc private func dismissBtnClick() {
        self.dismiss(animated: true)
    }
    

}

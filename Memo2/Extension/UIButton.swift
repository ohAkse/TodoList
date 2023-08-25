//
//  UIButton.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/22.
//

import UIKit

extension UIButton {
    func setupCustomButtonUI(red : CGFloat = 0.5, green : CGFloat = 0.7, blue : CGFloat = 0.5, alpha : CGFloat = 1.0){
        self.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        self.setTitleColor(.blue, for: .normal)
        self.layer.cornerRadius = 10.0
    }    
    func setupCustomButtonFont(){
        let buttonFont = UIFont(name: "Helvetica-Bold", size: 17.0)
        self.titleLabel?.font = buttonFont
        self.setTitleColor(.white, for: .normal)
    }
    
}

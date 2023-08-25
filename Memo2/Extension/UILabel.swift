//
//  UILabel.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/22.
//

import UIKit

extension UILabel {
    func setupCustomLabelFont(text: String = "", isBold: Bool = false, textSize : Double = 30.0, textColor: UIColor = .black) {
        if isBold {
            self.font = UIFont.boldSystemFont(ofSize: textSize)
        } else {
            self.font = UIFont.systemFont(ofSize: textSize)
        }
        self.textColor = textColor
        self.text = text
    }
}

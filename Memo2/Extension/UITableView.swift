//
//  UITableView.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/24.
//

import UIKit

extension UITableView{

    func setupCustomTableviewUI(red : CGFloat = 0.5, green : CGFloat = 0.7, blue : CGFloat = 0.5, alpha : CGFloat = 1.0){
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.showsVerticalScrollIndicator = false
        self.register(TodoListCell.self, forCellReuseIdentifier: "TodoListCell")
    }
    
}

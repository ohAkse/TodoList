//
//  Date.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/22.
//

import UIKit
extension Date{
    func GetCurrentTime() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: self)
        return dateString
    }
}

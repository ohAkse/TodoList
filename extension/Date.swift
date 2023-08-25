//
//  Date.swift
//  Memo
//
//  Created by 박유경 on 2023/08/04.
//

import Foundation
extension Date{    
    func GetCurrentTime() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: self)
        return dateString
    }
}

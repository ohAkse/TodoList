//
//  CategoryType.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/23.
//

import Foundation
enum CategoryType {
    case workout
    case study
    case meeting
    case none
    var typeValue: String {
        switch self {
        case .workout: return "운동"
        case .study: return "공부"
        case .meeting: return "모임"
        case .none: return ""
        }
    }
}

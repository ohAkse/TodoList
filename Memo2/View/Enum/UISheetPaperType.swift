//
//  UISheetPaperType.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/23.
//

import Foundation
enum UISheetPaperType {
    case create
    case update
    case category
    case none
    case complete
    var typeValue: String {
        switch self {
        case .none: return ""
        case .create: return "할일 작성"
        case .update: return "할일 수정"
        case .category: return "카테 고리"
        case .complete: return "완료 리스트"
        }
    }
}

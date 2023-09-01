//
//  TextChnageCommitStatus.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/23.
//

import Foundation
enum TextChangeCommitStatus{
    case success
    case fail
    case none
    var typeValue: String {
        switch self {
        case .success: return "성공"
        case .fail: return "실패"
        case .none: return ""
        }
    }
}

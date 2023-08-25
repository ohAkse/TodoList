//
//  TextChnageCommitStatus.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/23.
//

import Foundation
enum TextChangeCommitStatus{
    case Success
    case Fail
    case none
    var typeValue: String {
        switch self {
        case .Success: return "성공"
        case .Fail: return "실패"
        case .none: return ""
        }
    }
}

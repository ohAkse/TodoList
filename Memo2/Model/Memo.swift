//
//  Memo.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/22.
//

import Foundation
struct Category :  Codable {
    var name: String
    var items: [SectionItem]
}
struct SectionItem  : Codable{
    var memoText: String
    var isSwitchOn: Bool
}

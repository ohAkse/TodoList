//
//  Dummy.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/23.
//

import Foundation
//var categories: [Category] = [
//    Category(name: "운동", items: [
//        SectionItem(memoText: "가나다1", isSwitchOn: false),
//        SectionItem(memoText: "라마바", isSwitchOn: true),
//        SectionItem(memoText: "사자차", isSwitchOn: false),
//        SectionItem(memoText: "아리랑", isSwitchOn: true)
//    ]),
//    Category(name: "공부", items: [
//        SectionItem(memoText: "공부1", isSwitchOn: true),
//        SectionItem(memoText: "공부2", isSwitchOn: false),
//        SectionItem(memoText: "공부3", isSwitchOn: true)
//
//    ]),
//    Category(name: "모임", items: [
//        SectionItem(memoText: "모임1", isSwitchOn: false),
//        SectionItem(memoText: "모임2", isSwitchOn: true),
//    ])
//]

class Observable<T> {
    
    private var listener: ((T?) -> Void)?
    
    var value: T? {
        didSet {
            self.listener?(self.value)
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}

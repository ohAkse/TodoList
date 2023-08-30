//
//  Observable.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/29.
//

import Foundation
class Observable<T> {
    typealias Observer = (T) -> Void
    var observers: [Observer] = []
    var value: T {
        didSet {
            notifyObservers()
        }
    }
    init(_ value: T) {
        self.value = value
    }
    func addObserver(_ observer: @escaping Observer) {
        observers.append(observer)
        observer(value)
    }
    //지금은 로컬 DB Instance하나로 관리하지만 나중에 Observable이 배열형태인경우 모든 데이터의 변경사항을 알려주려할때 유용할듯
    private func notifyObservers() {
        for observer in observers {
            observer(value)
        }
    }
}

//
//  Observable.swift
//  Memo2
//
//  Created by 박유경 on 2023/09/20.
//

class Observable<T> {
    typealias Observer = (T) -> Void
    var observers: [Observer] = []
    
    init(_ value: T) {
        self.value = value
    }
    func addObserver(_ observer: @escaping Observer) {
        observers.append(observer)
        observer(value)
    }
    func notifyObservers() {
        for observer in observers {
            observer(value)
        }
    }
    var value: T {
        didSet {
            notifyObservers()
        }
    }
}

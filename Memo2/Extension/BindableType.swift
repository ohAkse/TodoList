//
//  BindableType.swift
//  Memo2
//
//  Created by 박유경 on 2023/09/20.
//

import UIKit
protocol BindableType: AnyObject {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}
extension BindableType where Self: UIViewController {
    func bind(to model: Self.ViewModelType) {
        self.viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}

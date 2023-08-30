//
//  ViewModelBindableType.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/30.
//

import UIKit
protocol ViewModelBindableType{
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    func setupSubviews()
    func setupLayout()
    func setupBind()
}
extension ViewModelBindableType where Self: UIViewController{
    mutating func bind(viewModel: Self.ViewModelType){
        self.viewModel = viewModel
        setupSubviews()
        setupLayout()
        setupBind()
    }

}

//
//  NetworkResponseStatus.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/25.
//

import UIKit
enum NetworkResponseStatus<T> {
    case success(T)
    case error(String)
    case unknown(String)
    case none
}


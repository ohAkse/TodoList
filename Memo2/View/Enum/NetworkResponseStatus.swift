//
//  NetworkResponseStatus.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/25.
//

import Foundation
enum NetworkResponseStatus : Error {
    case success
    case error(error: String)
    case unknown
    case none
    
    var typeValue: String {
        switch self {
        case .success:
            return "Success"
        case .error(let error):
            print("Error: \(error)")
            return error
        case .unknown:
            return "Unknown"
        case .none:
            return ""
        }
    }
}


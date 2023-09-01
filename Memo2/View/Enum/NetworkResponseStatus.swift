//
//  NetworkResponseStatus.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/25.
//

import UIKit
enum NetworkResponseStatus<T> {
    case success(T)
    case error(NetworkError)
    case unknown(String)
    case none
}
enum NetworkError: Error {
    case decodingJSON(String)
    case decodingImage(String)
    case statusCode(HTTPStatusCode)
    case unknown(String)
    case wrongUrL(String)
    enum HTTPStatusCode {
        case success
        case redirection(Int)
        case clientError(Int)
        case serverError(Int)
        case unknown(Int)
    }
}

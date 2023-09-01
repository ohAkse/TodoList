//
//  RemoteImageLoader.swift
//  Memo2
//
//  Created by 박유경 on 2023/09/01.
//

import Foundation
final class RemoteImageLoader {
    private let url: URL
    private let instance: NetworkManager
    init(url: URL, instance: NetworkManager) {
        self.url = url
        self.instance = instance
    }
    func loadImageAsync() async throws -> Data {
        try await instance.getImageAsync(imageUrl: url)
    }
    func loadImage(completion: @escaping (NetworkResponseStatus<Data>) -> Void) {
        instance.getImage(imageUrl: url) { response in
            switch response {
            case .success(let data):
                completion(.success(data))
            case .error(let error):
                completion(.error(error))
            default:
                print("Unexpected error occurred.")
            }
        }
    }
}

//
//  NetworkManager.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/25.
//

import Foundation
final class NetworkManager{
    static let instance = NetworkManager()
    func getImageAsync(imageUrl: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: imageUrl)
        guard
            let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200
        else { throw InvalidData() }
        return data
    }
    func getImage(imageUrl: URL, completion: @escaping (NetworkResponseStatus<Data>) -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: imageUrl) { (data, response, error) in
            if let error = error {
                completion(.error(.unknown("Unknown : \(error.localizedDescription)")))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200
                {
                    if let data = data {
                        completion(.success(data))
                    } else {
                        completion(.error(.decodingImage("Failed to decode Image")))
                    }
                }else{
                    completion(.error(.decodingImage("200이외 에러")))
                }
            }
        }
        task.resume()
    }
}
struct InvalidData: Error {}

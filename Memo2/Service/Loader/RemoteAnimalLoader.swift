//
//  RemoteAnimalLoader.swift
//  Memo2
//
//  Created by 박유경 on 2023/09/01.
//

import Foundation
final class RemoteAnimalLoader {
    private let instance: NetworkManager
    init(instance: NetworkManager) {
        self.instance = instance
    }
    func decodeImageAsync(data: Data) async throws -> Data {
        do {
            let decoder = JSONDecoder()
            let animal = try decoder.decode([Animal].self, from: data)
            let imageUrl = animal[0].url
            let imageData = try await instance.getImageAsync(imageUrl: URL(string: imageUrl)!)
            return imageData
        } catch {
            throw InvalidData()
        }
    }
    func decodeImage(data: Data, completion: @escaping (NetworkResponseStatus<Data>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let animals = try decoder.decode([Animal].self, from: data)
            guard let imageUrlString = animals.first?.url, let imageUrl = URL(string: imageUrlString) else {
                completion(.error(.wrongUrL("Invalid Image URL")))
                return
            }
            instance.getImage(imageUrl: imageUrl) { response in
                switch response {
                case .success(let imageData):
                    completion(.success(imageData))
                case .error(let error):
                    completion(.error(error))
                default :
                    print("AA")
                }
            }
        } catch {
            completion(.error(.decodingImage(error.localizedDescription)))
        }
    }
    
}

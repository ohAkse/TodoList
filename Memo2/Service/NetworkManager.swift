//
//  NetworkManager.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/25.
//

import Foundation
import UIKit

final class NetworkManager{
    static let instance = NetworkManager()
    //강아지 버전은 Async/Await으로 처리(IOS 15버전 이상)
    func fetchRandomImageAsync(imageUrl: String) async throws -> UIImage {
        let session = URLSession(configuration: .default)
        let (data, _) = try await session.data(from: URL(string: imageUrl)!)//URLResponse는 별 쓸모없는거같음
        do {
            let decoder = JSONDecoder()
            let cats = try decoder.decode([Animal].self, from: data)
            let imageUrl = cats[0].url
            return await getImageAsync(imageUrl: imageUrl)
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return UIImage()
    }
    
    func getImageAsync(imageUrl: String) async -> UIImage {
        if let imageUrl = URL(string: imageUrl) {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageUrl)
                if let image = UIImage(data: data) {
                    return image
                } else {
                    return UIImage()
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        return UIImage()
    }
    
    func fetchRandomImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        if let imageUrl = URL(string: imageUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: imageUrl) { [weak self ](data, response, error) in
                guard let self = self else{return}
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        print("HTTP Error: \(httpResponse.statusCode)")
                        completion(nil)
                        return
                    }
                }
                do {
                    let decoder = JSONDecoder()
                    let cats = try decoder.decode([Animal].self, from: data!)
                    let imageUrl = cats[0].url
                    getImage(imageUrl: imageUrl) { image in
                        completion(image)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    func getImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        if let imageUrl = URL(string: imageUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        print("HTTP Error: \(httpResponse.statusCode)")
                        completion(nil)
                        return
                    }
                }
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
}

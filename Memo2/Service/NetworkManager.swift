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
    func fetchRandomImageAsync(imageUrl: String) async throws -> UIImage {
        let session = URLSession(configuration: .default)
        let (data, response) = try await session.data(from: URL(string: imageUrl)!) // URLResponse는 별 쓸모없는거같음
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200..<300:
                do {
                    let decoder = JSONDecoder()
                    let cats = try decoder.decode([Animal].self, from: data)
                    let imageUrl = cats[0].url
                    return await getImageAsync(imageUrl: imageUrl)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case 300..<400:
                print("300번대 에러 -> \(response.statusCode)")
            case 400..<500:
                print("400번대 에러 -> \(response.statusCode)")
            default:
                print("Unknown Error")
            }
        }
        return UIImage()
    }
    
    func getImageAsync(imageUrl: String) async -> UIImage {
        if let imageUrl = URL(string: imageUrl) {
            do {
                let (data, response) = try await URLSession.shared.data(from: imageUrl)
                
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200..<300:
                        if let image = UIImage(data: data) {
                            return image
                        } else {
                            return UIImage()
                        }
                    case 300..<400:
                        print("300번대 에러 -> \(response.statusCode)")
                        
                    case 400..<500:
                        print("400번대 에러 -> \(response.statusCode)")
                    default:
                        print("Unknown Error")
                    }
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
            let task = session.dataTask(with: imageUrl) { [weak self](data, response, error) in
                guard let self = self else {return}
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200..<300:
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
                    case 300..<400:
                        print("300번대 에러 -> \(httpResponse.statusCode)")
                        completion(nil)
                    case 400..<500:
                        print("400번대 에러 -> \(httpResponse.statusCode)")
                        completion(nil)
                    default:
                        print("Unknown Error")
                        completion(nil)
                    }
                } else {
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
            let task = session.dataTask(with: imageUrl) { [weak self ](data, response, error) in
                guard let self = self else {return}
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200..<300:
                        if let data = data, let image = UIImage(data: data) {
                            completion(image)
                        } else {
                            completion(nil)
                        }
                    case 300..<400:
                        print("300번대 에러 -> \(httpResponse.statusCode)")
                        completion(nil)
                    case 400..<500:
                        print("400번대 에러 -> \(httpResponse.statusCode)")
                        completion(nil)
                    default:
                        print("Unknown Error")
                        completion(nil)
                    }
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


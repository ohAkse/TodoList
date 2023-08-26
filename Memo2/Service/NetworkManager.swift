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
    func fetchRandomImageAsync(imageUrl: String) async throws -> NetworkResponseStatus<UIImage> {
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(from: URL(string: imageUrl)!)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300:
                    let decoder = JSONDecoder()
                    let cats = try decoder.decode([Animal].self, from: data)
                    let imageUrl = cats[0].url
                    let imageResponse = await getImageAsync(imageUrl: imageUrl)
                    return imageResponse
                case 300..<400:
                    return .error("Decoding Json 300-399: \(httpResponse.statusCode)")
                case 400..<500:
                    return .error("Decoding Json 400-499: \(httpResponse.statusCode)")
                default:
                    return .unknown("Decoding Json Unkonw error :\(httpResponse.statusCode)")
                }
            }
        } catch {
            return .error("Decoding Json Error: \(error.localizedDescription)")
        }
        
        return .error("Decoding Json Unknown Error")
    }
    
    
    func getImageAsync(imageUrl: String) async-> NetworkResponseStatus<UIImage> {
        if let imageUrl = URL(string: imageUrl) {
            do {
                let (data, response) = try await URLSession.shared.data(from: imageUrl)
                
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200..<300:
                        if let image = UIImage(data: data) {
                            return .success(image)
                        } else {
                            return .error("Failed to decode image data")
                        }
                    case 300..<400:
                        return .error("Decoding Image 300-399: \(httpResponse.statusCode)")
                    case 400..<500:
                        return .error("Decoding Image400-499: \(httpResponse.statusCode)")
                    default:
                        return .unknown("Decoding Image Unkonw error :\(httpResponse.statusCode)")
                    }
                }
            } catch {
                return .error("Decoding Image Error: \(error.localizedDescription)")
            }
        }
        
        return .error("Decoding Image  Unknown Error")
    }
    
    func fetchRandomImage(imageUrl: String, completion: @escaping (NetworkResponseStatus<UIImage>) -> Void) {
        if let imageUrl = URL(string: imageUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: imageUrl) { [weak self ](data, response, error) in
                guard let self = self else {return}
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.error("Failed to fetch image"))
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200..<300:
                        do {
                            let decoder = JSONDecoder()
                            let cats = try decoder.decode([Animal].self, from: data!)
                            let imageUrl = cats[0].url
                            self.getImage(imageUrl: imageUrl) { imageResponse in
                                switch imageResponse {
                                case .success(let image):
                                    completion(.success(image))
                                case .error(let errorMessage):
                                    completion(.error(errorMessage))
                                default:
                                    completion(.error("Unknown response"))
                                }
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                            completion(.error("Failed to decode JSON"))
                        }
                    case 300..<400:
                       
                        completion(.error("Decoding Json 300-399 \(httpResponse.statusCode)"))
                    case 400..<500:
                        print("400번대 에러 -> \(httpResponse.statusCode)")
                        completion(.error("Decoding Json 300-399 \(httpResponse.statusCode)"))
                    default:
                        print("Unknown Error")
                        completion(.error("Decoding Json :Unknown Error"))
                    }
                } else {
                    completion(.error("Decoding Json Error Unknown Response"))
                }
            }
            task.resume()
        } else {
            completion(.error("Invalid URL"))
        }
    }
    
    func getImage(imageUrl: String, completion: @escaping (NetworkResponseStatus<UIImage>) -> Void) {
        if let imageUrl = URL(string: imageUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: imageUrl) { [weak self ](data, response, error) in
                guard let self = self else {return}
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.error("Failed to fetch image"))
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200..<300:
                        if let data = data, let image = UIImage(data: data) {
                            completion(.success(image))
                        } else {
                            completion(.error("Failed to decode image data"))
                        }
                    case 300..<400:
                        completion(.error("Decoding Image 300-399 \(httpResponse.statusCode)"))
                    case 400..<500:
                        completion(.error("Decoding Image 400-499 \(httpResponse.statusCode)"))
                    default:
                        print("Unknown Error")
                        completion(.error("Decoding Image FetchUnknown Error"))
                    }
                } else {
                    completion(.error("Unknown Response"))
                }
            }
            task.resume()
        } else {
            completion(.error("Invalid URL"))
        }
    }
}


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
    func fetchRandomImageAsync(imageUrl: String) async  -> NetworkResponseStatus<UIImage> {
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(from: URL(string: imageUrl)!)
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300:
                    if httpResponse.statusCode == 200{
                        let decoder = JSONDecoder()
                        let animal = try decoder.decode([Animal].self, from: data)
                        let imageUrl = animal[0].url
                        let imageResponse = await getImageAsync(imageUrl: imageUrl)
                        return imageResponse
                    }else{
                        //성공은 했지만 상황에 따라 안되는 코드에 따른 추가 로직 구성
                    }
                case 300..<400:
                    return .error(.statusCode(.redirection(httpResponse.statusCode)))
                case 400..<500:
                    return .error(.statusCode(.clientError(httpResponse.statusCode)))
                default:
                    return .error(.unknown("Network Error"))
                }
            }
        } catch {
            return .error(.decodingJSON("Failed to decdoing Json"))
        }
        return .error(.wrongUrL("Wrong URL!"))
    }
    
    
    func getImageAsync(imageUrl: String) async-> NetworkResponseStatus<UIImage> {
        if let imageUrl = URL(string: imageUrl) {
            do {
                let (data, response) = try await URLSession.shared.data(from: imageUrl)
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200..<300:
                        if httpResponse.statusCode == 200{
                            if let image = UIImage(data: data) {
                                return .success(image)
                            } else {
                                return .error(.decodingImage("Failed to load Image"))
                            }
                        }else{
                            //성공은 했지만 상황에 따라 안되는 코드에 따른 추가 로직 구성
                        }
                    case 300..<400:
                        return .error(.statusCode(.redirection(httpResponse.statusCode)))
                    case 400..<500:
                        return .error(.statusCode(.clientError(httpResponse.statusCode)))
                    default:
                        return .error(.unknown("Network Error"))
                    }
                }
            } catch {
                return .error(.unknown("Network Error"))
            }
        }
        return .error(.wrongUrL("Wrong URL!"))
    }
    
    func fetchRandomImage(imageUrl: String, completion: @escaping (NetworkResponseStatus<UIImage>) -> Void) {
        guard let imageURL = URL(string: imageUrl) else {
            completion(.error(.wrongUrL("Wrong URL!")))
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: imageURL) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let error = error {
                completion(.error(.unknown(error.localizedDescription)))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300:
                    if httpResponse.statusCode == 200
                    {
                        do {
                            let decoder = JSONDecoder()
                            let animal = try decoder.decode([Animal].self, from: data!)
                            let imageUrl = animal[0].url
                            getImage(imageUrl: imageUrl) { imageResponse in
                                switch imageResponse {
                                case .success(let image):
                                    completion(.success(image))
                                default :
                                    completion(.unknown("Failed to load Image"))
                                }
                            }
                        } catch {
                            completion(.error(.decodingJSON("Failed to decode JSON")))
                        }
                    }else{
                        //성공은 했지만 상황에 따라 안되는 코드에 따른 추가 로직 구성
                    }
                case 300..<400:
                    completion(.error(.statusCode(.redirection(httpResponse.statusCode))))
                case 400..<500:
                    completion(.error(.statusCode(.clientError(httpResponse.statusCode))))
                default:
                    completion(.error(.unknown("Netowrk Error")))//어떤 경우에 default로 빠지는지 감이 안잡혀서 이렇게 설정
                }
            }
        }
        task.resume()
    }
    
    func getImage(imageUrl: String, completion: @escaping (NetworkResponseStatus<UIImage>) -> Void) {
        guard let imageURL = URL(string: imageUrl) else {
            completion(.error(.wrongUrL("Wrong URL!")))
            return
        }

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: imageURL) { (data, response, error) in
            if let error = error {
                completion(.error(.unknown("Unknown : \(error.localizedDescription)")))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300 :
                    if httpResponse.statusCode == 200
                    {
                        if let data = data, let image = UIImage(data: data) {
                            completion(.success(image))
                        } else {
                            completion(.error(.decodingImage("Failed to Decoding")))
                        }
                    }else{
                        //성공은 했지만 상황에 따라 안되는 코드에 따른 추가 로직 구성
                    }
                case 300..<400:
                    completion(.error(.statusCode(.redirection(httpResponse.statusCode))))
                case 400..<500:
                    completion(.error(.statusCode(.clientError(httpResponse.statusCode))))
                default:
                    completion(.error(.unknown("Netowrk Error")))//어떤 경우에 default로 빠지는지 감이 안잡혀서 이렇게 설정
                }
            }
        }
        task.resume()
    }
}


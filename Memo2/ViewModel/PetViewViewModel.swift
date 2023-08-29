//
//  PetViewViewModel.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/29.
//

import UIKit

class PetViewViewModel{
    var catImage : UIImage?
    var dogImage : UIImage?
    let instance = NetworkManager.instance
    
    func setupImagesAsync(completion: @escaping (NetworkResponseStatus<UIImage>, NetworkResponseStatus<UIImage>) -> Void) async {
        let dogImageURL = "https://api.thedogapi.com/v1/images/search"
        let catImageURL = "https://api.thecatapi.com/v1/images/search"
        let dogImageTask = Task {
            let dogImageResponse = await instance.fetchRandomImageAsync(imageUrl: dogImageURL)
            return dogImageResponse
        }
        let catImageTask = Task {
            let catImageResponse = await instance.fetchRandomImageAsync(imageUrl: catImageURL)
            return catImageResponse
        }
        let (dogImageResponse, catImageResponse) =  await (dogImageTask.value, catImageTask.value)
        completion(dogImageResponse, catImageResponse)
    }
  
    func setupImages(completion: @escaping (UIImage?, UIImage?) -> Void){
        let dogImageURL = "https://api.thedogapi.com/v1/images/search"
        let catImageURL = "https://api.thecatapi.com/v1/images/search"
        let group = DispatchGroup()
        
        var dogImageResult: NetworkResponseStatus<UIImage> = .none
        var catImageResult: NetworkResponseStatus<UIImage> = .none
        
        if case .none = dogImageResult {
            group.enter()
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                instance.fetchRandomImage(imageUrl: dogImageURL) { [weak self] dogImageResponse in
                    guard let self = self else { return }
                    switch dogImageResponse {
                    case .success(let dogImage):
                        self.dogImage = dogImage
                        completion(dogImage,catImage)
                    case .error(let errorMessage):
                        dogImageResult = .error(errorMessage)
                    default:
                        break
                    }
                    group.leave()
                }
            }
        }
        if case .none = catImageResult {
            group.enter()
            DispatchQueue.global().async { [weak self ] in
                guard let self = self else { return }
                instance.fetchRandomImage(imageUrl: catImageURL) { [weak self] catImageResponse in
                    guard let self = self else { return }
                    switch catImageResponse {
                    case .success(let catImage):
                        self.catImage = catImage
                        completion(nil,catImage)
                    case .error(let errorMessage):
                        catImageResult = .error(errorMessage)
                    default:
                        break
                    }
                    group.leave()
                }
            }
        }
    }
}

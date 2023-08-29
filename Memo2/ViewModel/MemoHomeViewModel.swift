//
//  MemoHomeViewModel.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/29.
//

import UIKit

class MemoHomeViewModel{
    var moveToListAction: (() -> Void)?
    var moveToCompleteAction: (() -> Void)?
    var moveToPetAction: (() -> Void)?
    var mainImage : UIImage?
    let instance = NetworkManager.instance
    
    func moveToList(){
        self.moveToListAction?()
    }
    func moveToComplete(){
        self.moveToCompleteAction?()
    }
    func moveToPet(){
        self.moveToPetAction?()
    }
    
    func setLogoImageView(completion: @escaping (NetworkResponseStatus<UIImage>)  -> Void) {
        DispatchQueue.global().async{[weak self] in
            guard let self = self else{return}
            instance.getImage(imageUrl: "https://spartacodingclub.kr/css/images/scc-og.jpg") { [weak self] imageResponse in
                guard let self = self else { return }
                switch imageResponse {
                case .success(let image):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        completion(.success(image))
                    }
                case .error(let errorMessage):
                    completion(.error(errorMessage))
                default:
                    break
                }
            }
        }
    }
    func setupLogoImageViewAsync(completion: @escaping (NetworkResponseStatus<UIImage>) -> Void) async {
        Task{
            do {
                let imageResponse = await instance.getImageAsync(imageUrl: "https://spartacodingclub.kr/css/images/scc-og.jpg")
                switch imageResponse {
                case .success(let image):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        completion(.success(image))
                    }
                case .error(let errorMessage):
                    completion(.error(errorMessage))
                default:
                    break
                }
            }
        }
    }
}

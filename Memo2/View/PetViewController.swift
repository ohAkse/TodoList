//
//  PetViewController.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/25.
//

import UIKit
import NVActivityIndicatorView
class PetViewController : UIViewController
{
    lazy var catImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: ""))
        return imageView
    }()
    lazy var dogImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: ""))
        return imageView
    }()
    let catLoadingindicator = NVActivityIndicatorView(
        frame: CGRect.zero,
        type: .ballSpinFadeLoader,
        color: .black,
        padding: 0
    )
    let dogLoadingindicator = NVActivityIndicatorView(
        frame: CGRect.zero,
        type: .ballSpinFadeLoader,
        color: .black,
        padding: 0
    )
    private var dogImageLoader : RemoteImageLoader?
    private var catImageLoader : RemoteImageLoader?
    private var animalLoader : RemoteAnimalLoader?
    let instance = NetworkManager.instance
    deinit{
        print("PetViewController deinit called")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupLoaders()
    }
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 16, *) {
            Task{
                try await setupImagesAsync()
            }
        }else{
            setupImages()
        }
        catLoadingindicator.startAnimating()
        dogLoadingindicator.startAnimating()
    }
    func setupLoaders(){
        dogImageLoader = RemoteImageLoader(url: URL(string: "https://api.thedogapi.com/v1/images/search")!, instance: NetworkManager.instance)
        catImageLoader = RemoteImageLoader(url: URL(string: "https://api.thecatapi.com/v1/images/search")!, instance: NetworkManager.instance)
        animalLoader = RemoteAnimalLoader(instance: NetworkManager.instance)
    }
    private func setupImagesAsync() async throws -> Void{
        let dogImageTask = Task {
            let dogImageResponse = try await dogImageLoader?.loadImageAsync()
            return dogImageResponse
        }
        let catImageTask = Task {
            let catImageResponse = try await catImageLoader?.loadImageAsync()
            return catImageResponse
        }
        do {
            let (dogImageResponse, catImageResponse) =  try await (dogImageTask.value, catImageTask.value)
                let dogImg = try await animalLoader?.decodeImageAsync(data: dogImageResponse!)
                let catImg = try await animalLoader?.decodeImageAsync(data: catImageResponse!)
                if let dogImage = dogImg, let catImage = catImg {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        dogLoadingindicator.stopAnimating()
                        dogImageView.image = UIImage(data: dogImage)
                        catLoadingindicator.stopAnimating()
                        catImageView.image = UIImage(data: catImage)
                    }
                }else{
                    print("Dog or Cat Image Error")
                }
            
        } catch {
            throw InvalidData()
        }
    }
    
    private func setupImages() {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            dogImageLoader?.loadImage{ [weak self] dogImageResponse in
                guard let self = self else { return }
                switch dogImageResponse {
                case .success(let dogJsonData):
                    animalLoader?.decodeImage(data: dogJsonData){ [weak self] dogImage in
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            switch dogImage{
                            case .success(let dogData):
                                dogLoadingindicator.stopAnimating()
                                dogImageView.image = UIImage(data : dogData)
                                group.leave()
                            case .error(let errorMessage):
                                print("decoding Image Data(Dog) error : \(errorMessage)")
                            default:
                                print("error")
                            }
                        }
                    }
                case .error(let errorMessage):
                    print("decoding Json Data(Dog) error: \(errorMessage)")
                    group.leave()
                default:
                    break
                }
            }
        }
        group.enter()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            catImageLoader?.loadImage{ [weak self] catImageResponse in
                guard let self = self else { return }
                switch catImageResponse {
                case .success(let catJsonData):
                    animalLoader?.decodeImage(data: catJsonData){ [weak self] catImage in
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            switch catImage{
                            case .success(let catData):
                                catLoadingindicator.stopAnimating()
                                catImageView.image = UIImage(data : catData)
                                group.leave()
                            case .error(let errorMessage):
                                print("decoding Image Data(Cat) error : \(errorMessage)")
                            default:
                                print("error")
                            }
                        }
                    }
                case .error(let errorMessage):
                    print("decoding Json Data(Cat) error : \(errorMessage)")
                    group.leave()
                default:
                    break
                }
            }
        }
    }
    private func setupLayout(){
        [dogImageView, catImageView, catLoadingindicator,dogLoadingindicator].forEach(view.addSubview)
        dogImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        dogLoadingindicator.snp.makeConstraints { make in
            make.centerX.equalTo(dogImageView.snp.centerX)
            make.centerY.equalTo(dogImageView.snp.centerY)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        catImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dogImageView.snp.bottom).offset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.width.equalTo(dogImageView.snp.width)
            make.height.equalTo(dogImageView.snp.height)
        }
        catLoadingindicator.snp.makeConstraints { make in
            make.centerX.equalTo(catImageView.snp.centerX)
            make.centerY.equalTo(catImageView.snp.centerY)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }
}

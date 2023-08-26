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
    let instance = NetworkManager.instance
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
    
    deinit{
        print("PetViewController deinit called")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 16, *) {
            Task{
                await setupImagesAsync()
            }
        }else{
            setupImages()
        }
        catLoadingindicator.startAnimating()
        dogLoadingindicator.startAnimating()
    }
    func setupImagesAsync() async {
        let dogImageURL = "https://api.thedogapi.com/v1/images/search"
        let catImageURL = "https://api.thecatapi.com/v1/images/search"
        
        do {
            let dogImageResponse = try await instance.fetchRandomImageAsync(imageUrl: dogImageURL)
            let catImageResponse = try await instance.fetchRandomImageAsync(imageUrl: catImageURL)

            switch (dogImageResponse, catImageResponse) {
            case (.success(let dogImage), .success(let catImage)):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.dogLoadingindicator.stopAnimating()
                    self.dogImageView.image = dogImage
                    self.catLoadingindicator.stopAnimating()
                    self.catImageView.image = catImage
                }
            case (.error(let dogError), .error(let catError)):
                print("Dog Error: \(dogError), Cat Error: \(catError)")
            default:
                break
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func setupImages() {
        let dogImageURL = "https://api.thedogapi.com/v1/images/search"
        let catImageURL = "https://api.thecatapi.com/v1/images/search"
        let group = DispatchGroup()
        group.enter()
        instance.fetchRandomImage(imageUrl: dogImageURL) { [weak self] dogImageResponse in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                switch dogImageResponse {
                case .success(let dogImage):
                    dogLoadingindicator.stopAnimating()
                    dogImageView.image = dogImage
                case .error(let errorMessage):
                    print("Dog Image Error: \(errorMessage)")
                default :
                    break
                }
                group.leave()
            }
        }
        group.enter()
        instance.fetchRandomImage(imageUrl: catImageURL) { [weak self] catImageResponse in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                switch catImageResponse {
                case .success(let catImage):
                    catLoadingindicator.stopAnimating()
                    catImageView.image = catImage
                case .error(let errorMessage):
                    print("Cat Image Error: \(errorMessage)")
                default :
                    break
                }
                group.leave()
            }
        }
    }
    
    func setupSubviews(){
        view.addSubview(dogImageView)
        view.addSubview(catImageView)
        view.addSubview(catLoadingindicator)
        view.addSubview(dogLoadingindicator)
    }
    
    func setupLayout(){
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

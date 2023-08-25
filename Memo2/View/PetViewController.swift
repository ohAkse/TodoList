//
//  PetViewController.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/25.
//

import UIKit

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
    
    deinit{
        print("PetViewController deinit called")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 15, *) {
            Task{
                await setupImagesAsync()
            }
        }else{
            setupImages()
        }
    }
    func setupImagesAsync() async {
        let dogImageURL = "https://api.thedogapi.com/v1/images/search"
        let catImageURL = "https://api.thecatapi.com/v1/images/search"
        
        do {
            let dogImage = try await instance.fetchRandomImageAsync(imageUrl: dogImageURL)
            let catImage = try await instance.fetchRandomImageAsync(imageUrl: catImageURL)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.dogImageView.image = dogImage
                self.catImageView.image = catImage
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
        instance.fetchRandomImage(imageUrl: dogImageURL) { [weak self] dogImage in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dogImageView.image = dogImage
                group.leave()
            }
        }
        group.enter()
        instance.fetchRandomImage(imageUrl: catImageURL) { [weak self] catImage in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.catImageView.image = catImage
                group.leave()
            }
        }
    }
    
    
    
    func setupSubviews(){
        view.addSubview(dogImageView)
        view.addSubview(catImageView)
        
    }
    
    func setupLayout(){
        dogImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        catImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dogImageView.snp.bottom).offset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.width.equalTo(dogImageView.snp.width)
            make.height.equalTo(dogImageView.snp.height)
            
        }
    }
}

//
//  PetViewController.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/25.
//

import UIKit
import NVActivityIndicatorView
class PetViewController : UIViewController, ViewModelBindableType
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
    var viewModel : PetViewViewModel!
    deinit{
        print("PetViewController deinit called")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        catLoadingindicator.startAnimating()
        dogLoadingindicator.startAnimating()
    }
    func setupBind(){
        if #available(iOS 16.0, *) {
            Task {
                await viewModel.setupImagesAsync { [weak self] dogResponse, catResponse in
                    guard let self = self else { return }
                    switch (dogResponse, catResponse) {
                    case (.success(let dogImage), .success(let catImage)):
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else {return}
                            dogImageView.image = dogImage
                            dogLoadingindicator.stopAnimating()
                            catImageView.image = catImage
                            catLoadingindicator.stopAnimating()
                        }
                    case (.error(let dogError), .error(let catError)):
                        print("Dog Error: \(dogError), Cat Error: \(catError)")
                    default:
                        print("error")
                    }
                }
            }
            
        }
        else{
            viewModel.setupImages { [weak self] dogImage, catImage in
                guard let self = self else { return }
                if let dogImage = dogImage {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else{return }
                        dogImageView.image = dogImage
                        dogLoadingindicator.stopAnimating()
                    }
                }
                if let catImage = catImage {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else{return }
                        catImageView.image = catImage
                        catLoadingindicator.stopAnimating()
                    }
                }
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

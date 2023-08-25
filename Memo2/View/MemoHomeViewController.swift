//
//  MemoHomeViewController.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/22.
//

import UIKit
import SnapKit
import NVActivityIndicatorView
class MemoHomeViewController : UIViewController{
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: ""))
        return imageView
    }()
    
    lazy var moveToCompleteButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료 목록 이동하기", for: .normal)
        button.addTarget(self, action: #selector(moveToCompletsButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI()
        button.setupCustomButtonFont()
        return button
    }()
    
    lazy var moveToListButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("리스트로 이동하기", for: .normal)
        button.addTarget(self, action: #selector(moveToListButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI()
        button.setupCustomButtonFont()
        return button
    }()
    
    lazy var moveToAnimalButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("동물 구경하러 이동하기", for: .normal)
        button.addTarget(self, action: #selector(moveToAnimalButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI(red: 0.7)
        button.setupCustomButtonFont()
        return button
    }()
    
    let mainLoadingindicator = NVActivityIndicatorView(
        frame: CGRect.zero,
        type: .ballSpinFadeLoader,
        color: .black,
        padding: 0
    )

    let instance = NetworkManager.instance
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 16.0, *) {
            Task{
                await setupLogoImageViewAsync()
            }
        }else{
            setLogoImageView()
        }
        mainLoadingindicator.startAnimating()
    }
    func setLogoImageView(){
        
        instance.getImage(imageUrl: "https://spartacodingclub.kr/css/images/scc-og.jpg"){ [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                mainLoadingindicator.stopAnimating()
                mainImageView.image = image
            }
        }
    }
    
    func setupLogoImageViewAsync() async {
        do {
            let image =  await instance.getImageAsync(imageUrl: "https://spartacodingclub.kr/css/images/scc-og.jpg")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                mainLoadingindicator.stopAnimating()
                mainImageView.image = image
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupLayout()
    }
    
    func setupSubviews(){
        view.addSubview(mainImageView)
        view.addSubview(moveToListButton)
        view.addSubview(moveToCompleteButton)
        view.addSubview(moveToAnimalButton)
        view.addSubview(mainLoadingindicator)
    }
    
    func setupLayout(){
        mainImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        mainLoadingindicator.snp.makeConstraints { make in
            make.centerX.equalTo(mainImageView.snp.centerX)
            make.centerY.equalTo(mainImageView.snp.centerY)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        moveToListButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainImageView.snp.bottom).offset(60)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        moveToCompleteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(moveToListButton.snp.bottom).offset(30)
            make.width.equalTo(moveToListButton.snp.width)
            make.height.equalTo(moveToListButton.snp.height)
        }
        moveToAnimalButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(moveToCompleteButton.snp.bottom).offset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.width.equalTo(moveToCompleteButton.snp.width)
            make.height.equalTo(moveToCompleteButton.snp.height)
        }
    }
    @objc func moveToAnimalButtonTapped(){
        let petViewController = PetViewController()
        UIView.transition(with: navigationController!.view, duration: 0.5, options: .transitionFlipFromTop, animations: {
            self.navigationController?.pushViewController(petViewController, animated: false)
        }, completion: nil)
    }
    
    @objc func moveToListButtonTapped(){
        let memoListVC = MemoListViewController()
        UIView.transition(with: navigationController!.view, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            self.navigationController?.pushViewController(memoListVC, animated: false)
        }, completion: nil)
    }
    @objc func moveToCompletsButtonTapped(){
        let memoListVC = MemoCompleteViewController()
        present(memoListVC, animated: true, completion: nil)
    }
}




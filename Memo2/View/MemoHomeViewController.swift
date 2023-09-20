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
    private var logoImageLoader : RemoteImageLoader?
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: ""))
        return imageView
    }()
    
    private lazy var moveToCompleteButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료 목록 이동하기", for: .normal)
        button.addTarget(self, action: #selector(moveToCompletsButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI()
        button.setupCustomButtonFont()
        return button
    }()
    
    private lazy var moveToListButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("리스트로 이동하기", for: .normal)
        button.addTarget(self, action: #selector(moveToListButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI()
        button.setupCustomButtonFont()
        return button
    }()
    
    private lazy var moveToAnimalButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("동물 구경하러 이동하기", for: .normal)
        button.addTarget(self, action: #selector(moveToAnimalButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI()
        button.setupCustomButtonFont()
        return button
    }()
    
    private lazy var moveToProfileButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인스타 UI화면으로 이동하기", for: .normal)
        button.addTarget(self, action: #selector(moveToProfileButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI(red: 0.7)
        button.setupCustomButtonFont()
        return button
    }()
    
    private lazy var moveToTodoMVVMButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("MVVM Todo 화면 이동하기", for: .normal)
        button.addTarget(self, action: #selector(moveToTodoMVVMButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI(red: 0.7)
        button.setupCustomButtonFont()
        return button
    }()
    
    private let mainLoadingindicator = NVActivityIndicatorView(
        frame: CGRect.zero,
        type: .ballSpinFadeLoader,
        color: .black,
        padding: 0
    )
    deinit{
        print("MemoHomeViewController deinit called")
    }
    private let instance = NetworkManager.instance
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
    private func setLogoImageView() {
        DispatchQueue.global().async{[weak self] in
            guard let self = self else{return}
            logoImageLoader?.loadImage(){ [weak self] imageResponse in
                guard let self = self else { return }
                switch imageResponse {
                case .success(let image):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        mainLoadingindicator.stopAnimating()
                        mainImageView.image = UIImage(data : image)
                    }
                case .error(let errorMessage):
                    print("Error fetching image: \(errorMessage)")
                default:
                    break
                }
            }
        }
    }
    private func setupLogoImageViewAsync() async {
        Task{
            do {
                let image = try await logoImageLoader?.loadImageAsync()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let image = image{
                        mainLoadingindicator.stopAnimating()
                        mainImageView.image = UIImage(data : image)
                    } else{
                        return
                    }
                }
            }
            catch{
                throw InvalidData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupLogoImageLoader()
    }
    private func setupLogoImageLoader(){
        logoImageLoader = RemoteImageLoader(url: URL(string: "https://spartacodingclub.kr/css/images/scc-og.jpg")!, instance: NetworkManager.instance)
    }
    private func setupLayout(){
        [mainImageView, moveToListButton, moveToCompleteButton,moveToProfileButton,  moveToAnimalButton,mainLoadingindicator,moveToTodoMVVMButton].forEach(view.addSubview)
        mainImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview().multipliedBy(0.3)
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
            make.width.equalTo(moveToCompleteButton.snp.width)
            make.height.equalTo(moveToCompleteButton.snp.height)
        }
        moveToTodoMVVMButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(moveToAnimalButton.snp.bottom).offset(30)
            make.width.equalTo(moveToAnimalButton.snp.width)
            make.height.equalTo(moveToAnimalButton.snp.height)
        }
        moveToProfileButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(moveToTodoMVVMButton.snp.bottom).offset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.width.equalTo(moveToTodoMVVMButton.snp.width)
            make.height.equalTo(moveToTodoMVVMButton.snp.height)
        }
    }
    @objc private func moveToAnimalButtonTapped(){
        let petViewController = PetViewController()
        UIView.transition(with: navigationController!.view, duration: 0.5, options: .transitionFlipFromTop, animations: {
            self.navigationController?.pushViewController(petViewController, animated: false)
        }, completion: nil)
    }
    
    @objc private func moveToListButtonTapped(){
        let memoListVC = MemoListViewController()
        UIView.transition(with: navigationController!.view, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            self.navigationController?.pushViewController(memoListVC, animated: false)
        }, completion: nil)
    }
    @objc private func moveToCompletsButtonTapped(){
        let memoListVC = MemoCompleteViewController()
        present(memoListVC, animated: true, completion: nil)
    }
    @objc private func moveToProfileButtonTapped(){
        let tabController = UITabBarController()
        let profileDesignController = ProfileDesignViewController()
        profileDesignController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 0)
        tabController.viewControllers = [profileDesignController]
        tabController.modalPresentationStyle = .fullScreen
        tabController.modalTransitionStyle = .crossDissolve
        self.present(tabController, animated: true, completion: nil)
    }
    @objc private func moveToTodoMVVMButtonTapped(){
        let profileVC = ProfileViewController(viewModel: ProfileViewModel(coreDataManager: CoreDataManager()))
        profileVC.bindViewModel()
        UIView.transition(with: navigationController!.view, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            self.navigationController?.pushViewController(profileVC, animated: false)
        }, completion: nil)
    }
}

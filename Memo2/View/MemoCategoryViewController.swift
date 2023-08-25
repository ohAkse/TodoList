//
//  MemoCategoryViewController.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/23.
//

import UIKit

class MemoCategoryViewController : UIViewController
{
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.setupCustomLabelFont(text: UISheetPaperType.category.typeValue, isBold: true)
        label.textAlignment = .center
        return label
    }()
    lazy var workoutButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CategoryType.workout.typeValue, for: .normal)
        button.addTarget(self, action: #selector(workoutButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI(blue : 0.2)
        button.setupCustomButtonFont()
        return button
    }()
    lazy var studytButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CategoryType.study.typeValue, for: .normal)
        button.addTarget(self, action: #selector(studytButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI(red : 0.2)
        button.setupCustomButtonFont()
        return button
    }()
    lazy var meetingButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CategoryType.meeting.typeValue, for: .normal)
        button.addTarget(self, action: #selector(meetingButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI(green: 0.4)
        button.setupCustomButtonFont()
        return button
    }()
    deinit{
        print("MemoCategoryViewController deinit called")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupLayout()
    }
    func setupSubviews(){
        view.addSubview(titleLabel)
        view.addSubview(workoutButton)
        view.addSubview(studytButton)
        view.addSubview(meetingButton)
    }
    func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.1)
        }

        workoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.15)
        }

        studytButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview() 
            make.top.equalTo(workoutButton.snp.bottom).offset(30)
            make.width.equalTo(workoutButton.snp.width)
            make.height.equalTo(workoutButton.snp.height)
        }

        meetingButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(studytButton.snp.bottom).offset(30)
            make.width.equalTo(workoutButton.snp.width)
            make.height.equalTo(workoutButton.snp.height)
        }
    }
    func moveMemoWriteViewController(categoryType : CategoryType)
    {
        let memoWriteVC = MemoWriteViewController()
        if let presentationController = memoWriteVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(),
            ]
        }
        memoWriteVC.titleLabel.text = UISheetPaperType.create.typeValue
        memoWriteVC.category = categoryType.typeValue
        self.present(memoWriteVC, animated: true)
    }
    @objc func workoutButtonTapped(){
        moveMemoWriteViewController(categoryType: .workout)
    }
    @objc func studytButtonTapped(){
        moveMemoWriteViewController(categoryType: .study)
    }
    @objc func meetingButtonTapped(){
        moveMemoWriteViewController(categoryType: .meeting)
    }
}


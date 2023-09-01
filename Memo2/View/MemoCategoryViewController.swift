//
//  MemoCategoryViewController.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/23.
//

import UIKit
class MemoCategoryViewController : UIViewController, UISheetPresentationControllerDelegate
{
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.setupCustomLabelFont(text: UISheetPaperType.category.typeValue, isBold: true)
        label.textAlignment = .center
        return label
    }()
    private lazy var workoutButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CategoryType.workout.typeValue, for: .normal)
        button.addTarget(self, action: #selector(workoutButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI(blue : 0.2)
        button.setupCustomButtonFont()
        return button
    }()
    private lazy var studytButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CategoryType.study.typeValue, for: .normal)
        button.addTarget(self, action: #selector(studytButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI(red : 0.2)
        button.setupCustomButtonFont()
        return button
    }()
    private lazy var meetingButton : UIButton = {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.dismiss(animated: true)
    }
    private func setupLayout() {
        [titleLabel, workoutButton, studytButton,meetingButton].forEach(view.addSubview)
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
    private func moveMemoWriteViewController(categoryType : CategoryType)
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
    @objc private func workoutButtonTapped(){
        moveMemoWriteViewController(categoryType: .workout)
    }
    @objc private func studytButtonTapped(){
        moveMemoWriteViewController(categoryType: .study)
    }
    @objc private func meetingButtonTapped(){
        moveMemoWriteViewController(categoryType: .meeting)
    }
}


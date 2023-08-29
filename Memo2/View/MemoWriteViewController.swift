//
//  MemoWriteViewController.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/23.
//

import UIKit
class MemoWriteViewController : UIViewController, UITextViewDelegate
{
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.setupCustomLabelFont(text: UISheetPaperType.none.typeValue, isBold: true)
        label.textAlignment = .center
        return label
    }()
    lazy var textContent : UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right : 0)
        textView.layer.cornerRadius = 10.0
        textView.backgroundColor = .lightGray
        return textView
    }()
    lazy var confirmButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.setupCustomButtonUI(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        button.setupCustomButtonFont()
        return button
    }()
    var category : String = ""
    var originText : String = ""
    var selectedItem : SectionItem?
    
    deinit{
        print("MemoWriteViewController deinit called")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupLayout()
        setupBind()
        originText = textContent.text
    }
    let viewModel = MemoWriteViewViewModel()
    
    func setupBind(){
        viewModel.confirmAction = { [weak self] (category, bsuccess) in
            guard let self = self else {return}
            if bsuccess == false{
                showAlert(title: "에러", message: "내용을 추가해주세요")
            }else{
                if category.typeValue == "할일 수정"
                {
                    dismiss(animated: true)
                }else{
                    presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
                NotificationCenter.default.post(name: .textChangeStatus, object: TextChangeCommitStatus.Success)
            }
        }
    }
    func setupSubviews(){
        view.addSubview(titleLabel)
        view.addSubview(textContent)
        view.addSubview(confirmButton)
    }
    func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        textContent.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(textContent.snp.bottom).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalToSuperview().multipliedBy(0.09)
        }
    }
    @objc func confirmButtonTapped() {
        if titleLabel.text == UISheetPaperType.update.typeValue {
            viewModel.onUpdateText(category: category, originText: originText, changeText: textContent.text)
        } else {
            viewModel.onCreateData(category: category, item: SectionItem(memoText: textContent.text, isSwitchOn: false))
        }
    }
}

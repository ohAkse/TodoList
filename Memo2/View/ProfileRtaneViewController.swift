//
//  ProfileRtaneViewController.swift
//  Memo2
//
//  Created by 박유경 on 2023/09/20.
//

import UIKit
enum textFieldType: Int {
    case age = 1
    case name = 2
}

class ProfileRtaneViewController : UIViewController, BindableType
{
    var viewModel: ProfileRtaneViewModel!
    lazy var ageLabel : CLabel = {
        let label = CLabel(fontSize: .medium, isBold: false)
        label.text = "ageLabel"
        return label
    }()
    lazy var nameLabel : CLabel = {
        let label = CLabel(fontSize: .medium, isBold: false)
        label.text = "nameLabel"
        return label
    }()
    
    lazy var ageTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "숫자 입력"
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.tag = textFieldType.age.rawValue
        textField.borderStyle = .roundedRect
        textField.becomeFirstResponder()
        
        return textField
    }()
    lazy var nameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "문자열을 입력해주세요"
        textField.delegate = self
        textField.tag = textFieldType.name.rawValue
        textField.borderStyle = .roundedRect
        textField.becomeFirstResponder()
        return textField
    }()
    func bindViewModel() {
        viewModel.age.addObserver  { [weak self] age in
            guard let self = self else {return}
            ageLabel.text = String(age)
        }
        viewModel.name.addObserver  { [weak self] name in
            guard let self = self else {return}
            nameLabel.text = name
        }
    }
    init(viewModel : ProfileRtaneViewModel){
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("음뭬에에에")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    func configUI() {
        [ageLabel, ageTextField, nameLabel, nameTextField].forEach(view.addSubview)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.centerY.equalToSuperview()
            
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        nameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(nameLabel)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        ageTextField.snp.makeConstraints { make in
            make.centerY.equalTo(ageLabel)
            make.leading.equalTo(ageLabel.snp.trailing).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
    }
}

extension ProfileRtaneViewController : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            return
        }
        if textField.tag == textFieldType.age.rawValue
        {
            viewModel.setAge(age : Int(textField.text!)!)
        }else{
            
            viewModel.setName(name : textField.text!)
        }
    }
}

//
//  TodoListCell.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/22.
//

import UIKit

let footerHeight = 40.0
let headerHeight = 40.0
let cellFontSize = 24.0
let cellHeight = 70.0

class TodoListCell : UITableViewCell, UITextViewDelegate{
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail 
        textView.textContainer.maximumNumberOfLines = 1
        textView.font = UIFont.systemFont(ofSize: cellFontSize)
        textView.tintColor = .clear
        textView.delegate = self
        return textView
    }()
    
    lazy var switchButton : UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.onTintColor = UIColor.blue
        switchButton.tintColor = UIColor.red
        switchButton.addTarget(self, action: #selector(switchButtonTapped), for: .touchUpInside)
        return switchButton
    }()
    var switchButtonAction: (() -> Void)?
    var contentTextFieldAction : (()-> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupLayout()
    }
    @objc func switchButtonTapped(){
        self.switchButtonAction?()
    }
    @objc func textViewDidBeginEditing(_ textView: UITextView) {
        self.contentTextFieldAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("음뭬에에에")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.attributedText = nil
    }
    
    func setupSubviews(){
        contentView.addSubview(textView)
        contentView.addSubview(switchButton)
    }
    
    func setupLayout() {
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(contentView.snp.width).multipliedBy(0.7)
        }
        switchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(contentView.snp.width).multipliedBy(0.15) 
        }
    }
    
}

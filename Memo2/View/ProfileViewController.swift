//
//  ProfileViewController.swift
//  Memo2
//
//  Created by 박유경 on 2023/09/19.
//

import UIKit
import SnapKit
enum LabelFontSize: CGFloat {
    case small = 10
    case medium = 18
    case large = 25
}
class CLabel : UILabel{
    
    init(fontSize: LabelFontSize, isBold: Bool) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.font = UIFont.boldSystemFont(ofSize: fontSize.rawValue)
        if isBold {
            self.font = UIFont.boldSystemFont(ofSize: fontSize.rawValue)
        } else {
            self.font = UIFont.systemFont(ofSize: fontSize.rawValue)
        }
        self.textAlignment = .center
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class CButton : UIButton{
    init(image : UIImage?){
        super.init(frame: .zero)
        self.contentMode = .scaleToFill
        if let image = image{
            self.setImage(image, for: .normal)
        }else{
            self.setImage(UIImage(named: "book"), for: .normal)
        }
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
    }
    init (middleBarSetting : Bool = false){
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
class ProfileViewController: UIViewController{
    
    lazy var userName : CLabel = {
        let label = CLabel(fontSize: LabelFontSize.large, isBold: true)
        label.text = "nabaecamp"
        label.textAlignment = .center
        return label
    }()
    lazy var menuButton : CButton = {
        let button = CButton(image: UIImage(named: "Menu"))
        return button
    }()
    lazy var userPic: CButton = {
        let image = UIImage(named: "rtane")
        let button = CButton(image: image)
        return button
    }()
    
    lazy var postLabel : CLabel = {
        let label = CLabel(fontSize: LabelFontSize.medium, isBold: false)
        label.text = "post"
        return label
    }()
    
    lazy var postNumber : CLabel = {
        let label = CLabel(fontSize: LabelFontSize.large, isBold: true)
        label.text = "7"
        return label
    }()
    
    lazy var followerLabel : CLabel = {
        let label = CLabel(fontSize: LabelFontSize.medium, isBold: false)
        label.text = "follower"
        return label
    }()
    
    lazy var fowllowerNumber : CLabel = {
        let label = CLabel(fontSize: LabelFontSize.large, isBold: true)
        label.text = "0"
        return label
    }()
    
    lazy var  followingLabel : CLabel = {
        let label = CLabel(fontSize: LabelFontSize.medium, isBold: false)
        label.text = "following"
        return label
    }()
    
    lazy var followingNumber : CLabel = {
        let label = CLabel(fontSize: LabelFontSize.large, isBold: true)
        label.text = "0"
        return label
    }()
    
    lazy var rtaneLabel : CLabel = {
        let label = CLabel(fontSize: LabelFontSize.medium, isBold: true)
        label.textAlignment = .left
        label.text = "르탄이"
        return label
    }()
    
    lazy var iosDevelopLabel : CLabel = {
        let label = CLabel(fontSize: LabelFontSize.medium, isBold: false)
        label.textAlignment = .left
        label.text = "IOS Developer"
        return label
    }()
    
    lazy var spartacodingclubLabel : CLabel = {
        let label = CLabel(fontSize: LabelFontSize.medium, isBold: false)
        label.textAlignment = .left
        label.text = "spartacodingclub.kr"
        label.textColor = .blue
        return label
    }()
    
    lazy var followButton : CButton = {
        let button = CButton(image: UIImage(named: "Follow"))
        return button
    }()
    
    lazy var messageButton : UIButton = {
        let button = CButton(image: UIImage(named: "Message"))
        return button
    }()
    
    lazy var moreButton : CButton = {
        let button = CButton(image: UIImage(named: "More"))
        return button
    }()
    lazy var userFollowInfoStackView: UIStackView = {
        let userFollowInfoStackView = UIStackView()
        userFollowInfoStackView.axis = .horizontal
        userFollowInfoStackView.spacing = 5
        userFollowInfoStackView.distribution = .fillEqually
        
        let postInfoStackView = UIStackView()
        postInfoStackView.axis = .vertical
        postInfoStackView.alignment = .fill
        
        postInfoStackView.addArrangedSubview(postNumber)
        postInfoStackView.addArrangedSubview(postLabel)
        
        let followerInfoStackView = UIStackView()
        followerInfoStackView.axis = .vertical
        followerInfoStackView.alignment = .fill
        
        followerInfoStackView.addArrangedSubview(fowllowerNumber)
        followerInfoStackView.addArrangedSubview(followerLabel)
        
        let followingInfoStackView = UIStackView()
        followingInfoStackView.axis = .vertical
        followingInfoStackView.alignment = .fill
        
        followingInfoStackView.addArrangedSubview(followingNumber)
        followingInfoStackView.addArrangedSubview(followingLabel)
        
        userFollowInfoStackView.addArrangedSubview(postInfoStackView)
        userFollowInfoStackView.addArrangedSubview(followerInfoStackView)
        userFollowInfoStackView.addArrangedSubview(followingInfoStackView)
        return userFollowInfoStackView
    }()
    lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        
        stackView.addArrangedSubview(rtaneLabel)
        stackView.addArrangedSubview(iosDevelopLabel)
        stackView.addArrangedSubview(spartacodingclubLabel)
        return stackView
    }()
    
    lazy var middleBar: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(followButton)
        stackView.addArrangedSubview(messageButton)
        stackView.addArrangedSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(moreButton.snp.height)
        }
        followButton.snp.makeConstraints {
            $0.width.equalTo(messageButton.snp.width)
            $0.height.equalTo(moreButton.snp.height)
        }
        
        messageButton.snp.makeConstraints {
            $0.width.equalTo(followButton.snp.width)
            $0.height.equalTo(moreButton.snp.height)
        }
        
        return stackView
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // 수직 스크롤을 원하는 경우
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell") // 셀 등록
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
    }
    
    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        self.view.addSubview(view)
        view.snp.makeConstraints {
            $0.top.equalTo(middleBar.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(1)
        }
        return view
    }()
    lazy var navGalleryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        
        let navGalleryView = UIView()
        view.addSubview(navGalleryView)
        navGalleryView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(50)
            $0.top.equalTo(divider.snp.bottom)
        }
        
        let centerButton = UIButton()
        centerButton.setImage(UIImage(named: "Grid"), for: .normal)
        navGalleryView.addSubview(centerButton)
        centerButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }
        let navLineView = UIView()
        navLineView.backgroundColor = .darkGray
        view.addSubview(navLineView)
        navLineView.snp.makeConstraints {
            $0.top.equalTo(navGalleryView.snp.bottom)
            $0.leading.equalTo(navGalleryView)
            $0.trailing.equalTo(navGalleryView)
            $0.height.equalTo(5)
        }
        stackView.addArrangedSubview(navGalleryView)
        stackView.addArrangedSubview(navLineView)
        return stackView
    }()
    func configUI()
    {
        [userName,postLabel,menuButton,userPic,postNumber,followerLabel,fowllowerNumber,followingLabel,followingNumber,rtaneLabel,iosDevelopLabel,spartacodingclubLabel,followButton,messageButton,moreButton].forEach(view.addSubview)
        userName.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.width.equalToSuperview().multipliedBy(0.4)
        }
        menuButton.snp.makeConstraints{
            $0.centerY.equalTo(userName.snp.centerY)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-28)
            $0.height.equalTo(userName.snp.height).multipliedBy(0.7)
            $0.width.equalToSuperview().multipliedBy(0.05)
        }
        userPic.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(14)
            $0.top.equalTo(menuButton.snp.bottom).offset(40)
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(userPic.snp.width)
        }
        view.addSubview(userFollowInfoStackView)
        userFollowInfoStackView.snp.makeConstraints {
            $0.centerY.equalTo(userPic.snp.centerY)
            $0.leading.equalTo(userPic.snp.trailing)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-28)
        }
        
        view.addSubview(userInfoStackView)
        rtaneLabel.snp.makeConstraints {
            $0.leading.equalTo(userInfoStackView.snp.leading)
        }
        iosDevelopLabel.snp.makeConstraints {
            $0.leading.equalTo(userInfoStackView.snp.leading)
        }
        spartacodingclubLabel.snp.makeConstraints {
            $0.leading.equalTo(userInfoStackView.snp.leading)
        }
        userInfoStackView.snp.makeConstraints {
            $0.top.equalTo(userPic.snp.bottom).offset(40)
            $0.leading.equalTo(userPic.snp.leading)
        }
        
        //버튼들(팔로우, 메세지, 더보기)
        view.addSubview(middleBar)
        middleBar.snp.makeConstraints {
            $0.top.equalTo(userInfoStackView.snp.bottom).offset(10)
            $0.leading.equalTo(userPic.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-28)
        }
        
        //구분선 및 갤러리 이미지
        view.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalTo(middleBar.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(1)
        }
        view.addSubview(navGalleryStackView)
        navGalleryStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3).offset(-2)
            $0.top.equalTo(divider.snp.bottom)
        }
        
        //밑에 사진첩
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.top.equalTo(navGalleryStackView.snp.bottom)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    let numberOfSections = 3
    let itemsPerSection = 10
}

let imageList : [String] = ["picture1","picture2","picture3","picture4","picture5","picture6","picture7"]

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCollectionViewCell
        let imageName = "picture" + String(indexPath.item + 1)
        cell.imageView.image = UIImage(named: imageName)
        return cell
    }

}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width ) / 3 - 2
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}


class MyCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

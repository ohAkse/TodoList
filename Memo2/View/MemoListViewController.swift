//
//  MemoListViewController.swift
//  Memo2
//
//  Created by 박유경 on 2023/08/22.
//

import UIKit
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    //섹션 헤더/푸터 기준으로 공통으로 Text 및 배경색 설정하는 함수
    func createSectionView(text: String, isHeader: Bool) -> UIView {
        let sectionView = UIView()
        let sectionLabel = UILabel()
        sectionLabel.setupCustomLabelFont(text: text, isBold: false, textSize: 20)
    
        if isHeader {
            sectionView.backgroundColor = .lightGray
            sectionLabel.frame = CGRect(x: 20, y: (((footerHeight) / 2) - sectionLabel.frame.size.height) / 2, width: tableView.bounds.width, height: sectionLabel.intrinsicContentSize.height)
        }else {
            sectionLabel.frame = CGRect(x: 20, y: (((footerHeight) / 2) - sectionLabel.frame.size.height) / 2, width: tableView.bounds.width, height: sectionLabel.intrinsicContentSize.height)
        }
        sectionView.addSubview(sectionLabel)
        return sectionView
    }
    //텍스트를 기준으로 카테고리와 아이템을 반환
    func findSectionItem(with text: String) -> (category: String, item: SectionItem)? {
        for category in categories {
            if let sectionItem = category.items.first(where: { $0.memoText == text }) {
                return (category.name, sectionItem)
            }
        }
        return nil
    }
    //스위치 온오프 여부에 따라 글자가 밑줄긋는 함수
    func configureTextView(for textView: UITextView, with text: String, isSwitchOn: Bool) {
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[.font] = UIFont.systemFont(ofSize: cellFontSize)
        if isSwitchOn {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        } else {
            attributes.removeValue(forKey: .strikethroughStyle)
        }
        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    //수정페이지 전환
    func editMemo(_ text: String) {
        guard presentedViewController == nil, let item = findSectionItem(with: text) else {
            return
        }

        let memoWriteVC = MemoWriteViewController()
        if let presentationController = memoWriteVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        memoWriteVC.titleLabel.text = UISheetPaperType.update.typeValue
        memoWriteVC.category = item.category
        memoWriteVC.selectedItem = item.item
        memoWriteVC.textContent.text = text
        present(memoWriteVC, animated: true)
    }
    //섹션 헤더 관련 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return footerHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = categories[section]
        return createSectionView(text : category.name, isHeader : true)
    }
    //섹션 푸터 관련 설정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return headerHeight
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let category = categories[section]
        return createSectionView(text: "완료되지 않은 항목은 총 \(category.items.filter{$0.isSwitchOn == false}.count)건 입니다.", isHeader : false)
    }
    //테이블뷰 셀 관련 함수
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell") as? TodoListCell else {
            return UITableViewCell()
        }
        
        let category = categories[indexPath.section]
        let sectionItem = category.items[indexPath.row]
        
        cell.textView.text = sectionItem.memoText
        cell.switchButton.isOn = sectionItem.isSwitchOn
        configureTextView(for: cell.textView, with: sectionItem.memoText, isSwitchOn: cell.switchButton.isOn)
        
        cell.switchButtonAction = { [weak self] in
            guard let self = self else { return }
            instance.updateData(category: category.name, cellIndex: indexPath.row, content: sectionItem.memoText, isSwitchOn: cell.switchButton.isOn)
            configureTextView(for: cell.textView, with: sectionItem.memoText, isSwitchOn: cell.switchButton.isOn)
            updateUI()
        }
        
        cell.contentTextFieldAction = { [weak self] in
            guard let self = self, let text = cell.textView.text else { return }
            editMemo(text)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    //스와이프시 삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let category = categories[indexPath.section]
            let sectionItem = category.items[indexPath.row]
            instance.deleteData(category: category.name, content: sectionItem.memoText)
            updateUI()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") {  [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
   
            let category = categories[indexPath.section]
            let sectionItem = category.items[indexPath.row]
            editMemo(sectionItem.memoText)
            completionHandler(true)
        }
        editAction.image = UIImage(systemName: "pencil")
        return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    }
}
class MemoListViewController : UIViewController{
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.setupCustomTableviewUI()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    private let instance = LocalDBManager.instance
    private var uncompletedItemListCount = 0
    private var categories : [Category] = []
    deinit{
        NotificationCenter.default.removeObserver(self)
        print("MemoListViewController deinit called")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        setupTableFHView()
        InitLocalDBData()
        updateUI()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(DidReceiveTextChangeCommitStatus),
            name: .textChangeStatus,
            object: nil
        )
    }
    @objc private func DidReceiveTextChangeCommitStatus(_ notification: Notification) {
        if let status = notification.object as? TextChangeCommitStatus {
            if status == .success
            {
                Toast.showToast(message: "요청이 성공적으로 처리되었습니다.", errorMessage: [], font: UIFont.systemFont(ofSize: 14.0), controllerView: self)
                updateUI()
            }
        }
    }
    private func InitLocalDBData(){
        instance.initializeCategoriesIfNeeded()
    }
    private func updateUI(){
        categories = instance.getCategoriesFromUserDefaults()
        uncompletedItemListCount = categories.reduce(0) { (count, category) in
            let categoryCount = category.items.reduce(0) { (itemCount, sectionItem) in
                return itemCount + (sectionItem.isSwitchOn == true ? 0 : 1)
            }
            return count + categoryCount
        }
        let text = uncompletedItemListCount == 0 ? "All plans have been executed!" :  "총 \(uncompletedItemListCount)개 항목이 완료되지 않았습니다."
        if let footerLabel = tableView.tableFooterView?.subviews.first as? UILabel {
            footerLabel.text = text
            footerLabel.sizeToFit()
        }
        tableView.reloadData()
    }
    private func setupTableFHView(){
        //테이블뷰 헤더
        let tableViewHeader = UIView(frame: CGRect(x: 0, y: 0 , width: view.bounds.width, height: headerHeight))
        tableViewHeader.backgroundColor = .white
        let headerLabel = UILabel()
        headerLabel.setupCustomLabelFont(text: "Todo List", isBold: true, textSize: 30)
        headerLabel.sizeToFit()
        headerLabel.center.x = tableViewHeader.center.x
        headerLabel.center.y = tableViewHeader.frame.size.height / 2
        tableViewHeader.addSubview(headerLabel)
        tableView.tableHeaderView = tableViewHeader
        
        //테이블뷰 푸터
        let tableViewFooter = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: footerHeight))
        tableViewFooter.backgroundColor = .gray
        let footerLabel = UILabel()
        footerLabel.setupCustomLabelFont(text: "총 0개 항목이 완료되지 않았습니다.", isBold: true, textSize: 20) //초기 설정, but 나중에 UI업데아트시 계속 변경됨
        footerLabel.sizeToFit()
        footerLabel.center.x = tableViewFooter.center.x
        footerLabel.center.y = tableViewFooter.frame.size.height / 2
        tableViewFooter.addSubview(footerLabel)
        tableView.tableFooterView = tableViewFooter
    }
    private func setupNavigationBar(){
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    @objc private func addButtonTapped() {
        let memoCategoryVC = MemoCategoryViewController()
        let presentationController = memoCategoryVC.presentationController as? UISheetPresentationController
        presentationController?.detents = [
            .medium(),
        ]
        presentationController?.delegate = memoCategoryVC
        self.present(memoCategoryVC, animated: true)
    }
}

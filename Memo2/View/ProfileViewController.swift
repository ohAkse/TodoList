//
//  ProfileViewController.swift
//  Memo2
//
//  Created by 박유경 on 2023/09/19.
//
import UIKit
protocol BindableType: AnyObject {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}
extension BindableType where Self: UIViewController {
    func bind(to model: Self.ViewModelType) {
        self.viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
class ProfileViewController : UIViewController, BindableType{
    var viewModel: ProfileViewModel!
    deinit{
        print("ProfileViewController deinit called")
    }
    lazy var addButton : CButton = {
        let button = CButton(image: UIImage(named: "Add"))
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    lazy var titleLabel : CLabel = {
        let label = CLabel(fontSize: .medium, isBold: true)
        label.text = "데이터가 읍습니다"
        return label
    }()
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableCustomCell.self, forCellReuseIdentifier: "tableCustomCell")
        tableView.backgroundView?.backgroundColor = .yellow
        return tableView
    }()
    
    init(viewModel : ProfileViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        configUI()
    }
    func configUI(){
        [addButton,titleLabel,tableView].forEach(view.addSubview)
        addButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            $0.width.equalToSuperview().multipliedBy(0.15)
            $0.height.equalTo(addButton.snp.width)
            
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(addButton.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    func bindViewModel(){
        viewModel.todoList.addObserver  { [weak self] todoList in
            guard let self = self else {return}
            if todoList.count != 0 {
                for i in 0..<todoList.count{
                    titleLabel.text = todoList[i].title
                }
            }
            tableView.reloadData()
        }
        
    }
    @objc func addButtonTapped(){
        viewModel.addAction()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewModel.loadData()
    }
    
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTodoCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCustomCell") as? TableCustomCell else {
            return UITableViewCell()
        }
        let todoList = viewModel.getTodoList()
        if indexPath.row < todoList.count {
            let todo = todoList[indexPath.row]
            cell.titleLabel.text = todo.title
            cell.createDateLabel.text = "Create Date: \(todo.createDate ?? Date())"
            if let modifyDate = todo.modifyDate {
                cell.updateDateLabel.text = "Update Date: \(modifyDate)"
            } else {
                cell.updateDateLabel.text = "Update Date: "
            }
            cell.completedLabel.text = "Completed: \(todo.isCompleted)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            viewModel.deleteTodo(index: indexPath.row)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") {  [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            viewModel.editTodo(index: indexPath.row,isCompleted : true)
            completionHandler(true)
        }
        editAction.image = UIImage(systemName: "pencil")
        return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    }
}
class TableCustomCell : UITableViewCell
{
    
    var titleLabel : CLabel = {
        let label = CLabel(fontSize: .medium, isBold: true)
        return label
    }()
    var createDateLabel : CLabel = {
        let label = CLabel(fontSize: .medium, isBold: true)
        return label
    }()
    var updateDateLabel : CLabel = {
        let label = CLabel(fontSize: .medium, isBold: true)
        return label
    }()
    var completedLabel : CLabel = {
        let label = CLabel(fontSize: .medium, isBold: true)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("음뭬에에에")
    }
    func configUI() {
        [titleLabel, createDateLabel, updateDateLabel, completedLabel].forEach(contentView.addSubview)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
        }
        
        createDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        updateDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(createDateLabel.snp.bottom).offset(5)
        }
        
        completedLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(updateDateLabel.snp.bottom).offset(5)
        }
    }
}

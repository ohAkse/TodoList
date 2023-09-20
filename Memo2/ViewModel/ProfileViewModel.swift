//
//  ProfileViewModel.swift
//  Memo2
//
//  Created by 박유경 on 2023/09/20.
//

protocol ProfileViewModelProtocol{
    func addAction()
    func loadData()
    func getTodoList() -> [Todo]
    func getTodoCount() -> Int
    func deleteTodo(index cellIndex: Int)
    func editTodo(index cellIndex: Int, isCompleted: Bool)
}

class ProfileViewModel : ProfileViewModelProtocol
{
    var coreDataManager : CoreDataManager!
    var todoList : Observable<[Todo]> = Observable<[Todo]>([])
    init(coreDataManager : CoreDataManager){
        self.coreDataManager = coreDataManager
    }
    func addAction(){
        coreDataManager.createTodo(title: "Todo", isCompleted: false)
        loadData()
    }
    func loadData(){
        let todo = coreDataManager.fetchAllTodos()
        todoList.value = todo
    }
    func getTodoList() -> [Todo] {
        return todoList.value
    }
    func getTodoCount() -> Int {
        return todoList.value.count
    }
    func deleteTodo(index cellIndex: Int) {
        guard cellIndex >= 0, cellIndex < todoList.value.count else {
            return
        }
        let todoToDelete = todoList.value[cellIndex]
        coreDataManager.deleteTodo(todoToDelete)
        loadData()
    }
    
    func editTodo(index cellIndex: Int, isCompleted: Bool) {
        guard cellIndex >= 0, cellIndex < todoList.value.count else {
            return
        }
        let todoToEdit = todoList.value[cellIndex]
        coreDataManager.updateTodo(todoToEdit, isCompleted: isCompleted)
        loadData()
    }
}

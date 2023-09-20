//
//  CoreDataManager.swift
//  Memo2
//
//  Created by 박유경 on 2023/09/20.
//
import CoreData
class CoreDataManager {
    init() {}
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoCoreData")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func createTodo(title: String, isCompleted: Bool) {
        let newTodo = Todo(context: mainContext)
        newTodo.id = UUID()
        newTodo.title = title
        newTodo.isCompleted = isCompleted
        newTodo.createDate = Date()
        saveContext()
    }
    func deleteTodo(_ todo: Todo) {
         mainContext.delete(todo)
         saveContext()
     }
    
    func updateTodo(_ todo: Todo, isCompleted: Bool) {
        todo.isCompleted = isCompleted
        todo.modifyDate = Date()
        saveContext()
    }
    func saveContext() {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                print("저장 중 오류 발생: \(error)")
            }
        }
    }
    func fetchAllTodos() -> [Todo] {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        do {
            let todos = try mainContext.fetch(fetchRequest)
            return todos
        } catch {
            print("데이터를 가져오는 중 오류 발생: \(error)")
            return []
        }
    }
}

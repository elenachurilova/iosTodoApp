import Foundation 

public final class TodoManager {

    private let cache: Cache
    private var todos = [Todo]()

    public init(cache: Cache) {
        self.cache = cache
        self.todos = cache.load() ?? []
    }

    public func listTodos() -> [Todo] {
        return todos
    }

    public func addTodo(with title: String) {
        let todo = Todo(id: UUID(), title: title, isCompleted: false)
        todos.append(todo)
        cache.save(todos: todos)
    }

    public func toggleCompletion(forTodoAtIndex index: Int) {
        if isValidIndex(index) {
            todos[index].isCompleted.toggle()
            cache.save(todos: todos)
        } else {
            print("Unable to toggle the todo: invalid index")
        }
    }

    public func deleteTodo(atIndex index: Int) {
        if isValidIndex(index) {
            todos.remove(at: index)
            cache.save(todos: todos)
        } else {
            print("Unable to delete the todo: invalid index")
        }
    }

    public func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < todos.count
    } 

}
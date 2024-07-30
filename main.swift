import Foundation

struct Todo : CustomStringConvertible, Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var description: String {
        return "\(title) - \(isCompleted ? "Completed" : "Pending")"
    }
}

protocol Cache {
    func save(todos: [Todo])
    func load() -> [Todo]?
}


final class JSONFileManagerCache: Cache {

    // Initilize FileManager first, and then create a new directory -> return its URL
    func getFileURL() -> URL {
        let fileManager = FileManager.default
        let currentDirectoryURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
        
        // create UserData folder in the current directory
        let userDataURL = currentDirectoryURL.appendingPathComponent("UserData")

        do {
            try FileManager.default.createDirectory(at: userDataURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("JSONFileManagerCache: error creating directory: \(error)")
        }

        // create json file in the UserData directory
        let userTodoListURL = userDataURL.appendingPathComponent("todoList.json")
        return userTodoListURL
    }
    
    func save(todos: [Todo]) {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(todos)
            let fileURL = getFileURL()
            try jsonData.write(to: fileURL)
        } catch {
            print("JSONFileManagerCache: error writing to file: \(error)")
        }
    }

    func load() -> [Todo]? { 
        let fileURL = getFileURL()
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let todoList = try decoder.decode([Todo].self, from: data)
            return todoList
        } catch {
            print("JSONFileManagerCache: error reading or decoding file: \(error)")
            return nil
        }
    }

}

final class InMemoryCache: Cache {

    private var inMemoryTodos = [Todo]()

    func save(todos: [Todo]) {
        inMemoryTodos = todos
    }

    func load() -> [Todo]? {
        return inMemoryTodos
    }
}

final class TodoManager {

    private let cache: Cache
    private var todos = [Todo]()

    init(cache: Cache) {
        self.cache = cache
        self.todos = cache.load() ?? []
    }

    func listTodos() -> [Todo] {
        return todos
    }

    func addTodo(with title: String) {
        let todo = Todo(id: UUID(), title: title, isCompleted: false)
        todos.append(todo)
        cache.save(todos: todos)
    }

    func toggleCompletion(forTodoAtIndex index: Int) {
        if isValidIndex(index) {
            todos[index].isCompleted.toggle()
            cache.save(todos: todos)
        } else {
            print("Unable to toggle the todo: invalid index")
        }
    }

    func deleteTodo(atIndex index: Int) {
        if isValidIndex(index) {
            todos.remove(at: index)
            cache.save(todos: todos)
        } else {
            print("Unable to delete the todo: invalid index")
        }
    }

    private func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < todos.count
    } 

}

final class App {

    private let todoManager: TodoManager

    init(cache: Cache) {
        self.todoManager = TodoManager(cache: cache)
    }

    func run() {
        var iterate = true
        let welcome = "\n🌟 Welcome to To Do CLI 🌟"
        let question = "\nWhat would you like to do? (add, list, toggle, delete, exit): \n"
        let enterTodoTitle = "\nEnter To Do Title: "
        let todoAdded = "\n📌 Todo added! "
        let unknownInput = "\n🤔 I'm not quite sure I know this command.\nTry again? -> "
        let kBye = "\nOkay bye! 👋"
        let yourTodos = "\n📝 Your Todos:\n"
        let enterNumberToToggle = "\nEnter the number of the todo to toggle: "
        let enterNumberToDelete = "\nEnter the number of the todo to delete: "

        print(welcome)
        
        while iterate == true {
            print(question)
            if let response = readLine(), let command = Command(rawValue: response) {
                switch command {
                case .add:
                    print(enterTodoTitle)
                    if let addition = readLine() {
                        todoManager.addTodo(with: addition)
                        print(todoAdded)
                    } else {
                        print(unknownInput)
                    }
                case .list:
                    prettyListTodos(yourTodos)
                case .toggle:
                    prettyListTodos(yourTodos)
                    print(enterNumberToToggle)
                    if let todoIndex = readLine(), let index = Int(todoIndex) {
                        todoManager.toggleCompletion(forTodoAtIndex: index - 1)
                        prettyListTodos(yourTodos)
                    } else {
                        print(unknownInput)
                    }
                case .delete:
                    prettyListTodos(yourTodos)
                    print(enterNumberToDelete)
                    if let todoIndex = readLine(), let index = Int(todoIndex) {
                        todoManager.deleteTodo(atIndex: index - 1)
                        prettyListTodos(yourTodos)
                    } else {
                        print(unknownInput)
                    }
                case .exit:
                    print(kBye)
                    iterate = false
                }
            } else {
                print(unknownInput)
            }
        }
    }

    private func prettyListTodos(_ message: String) {
        print(message)
        let todos = todoManager.listTodos()
        for (index, todo) in todos.enumerated() {
            let status = todo.isCompleted ? "✅" : "❌"
            print("\(status) \(index + 1). \(todo.title)")
        }
    }


    enum Command: String {
        case add
        case list
        case toggle
        case delete
        case exit
    }
}


let app = App(cache: JSONFileManagerCache()) // can change to InMemoryCache()
app.run()

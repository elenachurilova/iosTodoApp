import Foundation

// * Create the `Todo` struct.
// * Ensure it has properties: id (UUID), title (String), and isCompleted (Bool).
struct Todo : CustomStringConvertible, Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var description: String 
}

// Create the `Cache` protocol that defines the following method signatures:
//  `func save(todos: [Todo])`: Persists the given todos.
//  `func load() -> [Todo]?`: Retrieves and returns the saved todos, or nil if none exist.
protocol Cache {

    func save(todos: [Todo]) {

    }

    func load() -> [Todo]? {

    }
}

// `FileSystemCache`: This implementation should utilize the file system 
// to persist and retrieve the list of todos. 
// Utilize Swift's `FileManager` to handle file operations.
final class JSONFileManagerCache: Cache {

    // Initilize FileManager first, and then create a new directory -> return its URL
    func getFileURL() -> String {
        let fileManager = FileManager.default
        let currentDirectoryURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
        // 
        print(currentDirectoryURL)
        
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
    
    func writeToFile(fileURL: String, toDoItem: Todo) {

        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(toDoItem)

        do {
            try data.write(to: userTodoListURL)
            print("Successfully wrote to file!")
        } catch {
            print("JSONFileManagerCache: error writing to file: \(error)")
        }
    }

    func readFromFile(userTodoListURL: String) -> [Todo]? {

        do {
            let data = try Data(contentsOf: userTodoListURL)
            let decoder = JSONDecoder()
            let todoList = try decoder.decode([Todo].self, from: data)
            return todoList
        } catch {
            print("JSONFileManagerCache: error reading or decoding file: \(error)")
        }
    }
    
}

// `InMemoryCache`: : Keeps todos in an array or similar structure during the session. 
// This won't retain todos across different app launches, 
// but serves as a quick in-session cache.
final class InMemoryCache: Cache {

}

// The `TodosManager` class should have:
// * A function `func listTodos()` to display all todos.
// * A function named `func addTodo(with title: String)` to insert a new todo.
// * A function named `func toggleCompletion(forTodoAtIndex index: Int)` 
//   to alter the completion status of a specific todo using its index.
// * A function named `func deleteTodo(atIndex index: Int)` to remove a todo using its index.
final class TodoManager {

    let fileURL = JSONFileManagerCache.getFileURL()

    func listTodos() {
        JSONFileManagerCache.readFromFile(userTodoListURL: fileURL)
        
    }

    func addTodo(with title: String) {
        let todoData = Todo(id: UUID(), title: title, isCompleted: false, description: "todo item")
        do {
            JSONFileManagerCache.writeToFile(fileURL: fileURL, toDoItem: todoData)
        } catch {
            print("TodoManager: error encoding data in addTodo: \(error)")
        }
    }

    func toggleCompletion(forTodoAtIndex index: Int) {

    }

    func deleteTodo(atIndex index: Int) {

    }

}


// * The `App` class should have a `func run()` method, this method should perpetually 
//   await user input and execute commands.
//  * Implement a `Command` enum to specify user commands. Include cases 
//    such as `add`, `list`, `toggle`, `delete`, and `exit`.
//  * The enum should be nested inside the definition of the `App` class
final class App {

    func run() {
        var iterate = true
        let welcome = "🌟 Welcome to To Do CLI 🌟"
        let question = "\nWhat would you like to do? \n(add, list, toggle, delete, exit): "
        let enterTodoTitle = "Enter To Do Title: "
        let todoAdded = "\n📌 Todo added! "
        let unknownInput = "I'm not quite sure I know this command 🤔.\nTry again? -> "
        let kBye = "Okay bye! 👋"
        let yourTodos = "\n📝 Your Todos:\n"
        let enterNumberToToggle = "\nEnter the number of the todo to toggle: "
        let enterNumberToDelete = "\nEnter the number of the todo to delete: "

        print(welcome, question)

        while iterate != false {

            if let response = readLine() {
                case add:
                    print(enterTodoTitle)
                    if let addition = readLine() {
                        TodoManager.addTodo(with: addition)
                        print(todoAdded)
                    } else {
                        print(unknownInput)
                    }
                case list:
                    prettyListTodos()
                case toggle:
                    prettyListTodos()
                    print(enterNumberToToggle)
                    if let todoIndex = readLine() {
                        TodoManager.toggleCompletion(forTodoAtIndex: todoIndex)
                    } else {
                        print(unknownInput)
                    }
                case delete:
                    prettyListTodos()
                    if let todoIndex = readLine() {
                        TodoManager.deleteTodo(atIndex: todoIndex)
                    } else {
                        print(unknownInput)
                    }
                case exit: 
                    print(kBye)
                    iterate = false
            } else {
                print(unknownInput)
            }
        }
    }   
    

    private func prettyListTodos() {
        print(yourTodos)
        TodoManager.listTodos()
    }

    enum Command {
        case add
        case list
        case toggle
        case delete
        case exit
    }
}


// TODO: Write code to set up and run the app.


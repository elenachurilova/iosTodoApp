import Foundation 

public final class App {

    public let todoManager: TodoManager

    public init(cache: Cache) {
        self.todoManager = TodoManager(cache: cache)
    }

    public func run() {
        var iterate = true
        let welcome = "\n🌟 Welcome to To Do CLI 🌟"
        let question = "\nWhat would you like to do? (add, list, toggle, delete, exit): \n"
        let enterTodoTitle = "\nEnter To Do Title: "
        let todoAdded = "\n📌 Todo added! "
        let unknownInput = "\n🤔 I'm not quite sure I know this command. Try again?"
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


    public enum Command: String {
        case add
        case list
        case toggle
        case delete
        case exit
    }
}

import XCTest
@testable import TodoAppCore

final class TodoAppTests: XCTestCase {

    func testAddTodo() {
        let cache = InMemoryCache()
        let todoManager = TodoManager(cache: cache)

        todoManager.addTodo(with: "Test Task")
        let todos = todoManager.listTodos()

        XCTAssertEqual(todos.count, 1)
        XCTAssertEqual(todos.first?.title, "Test Task")
        XCTAssertEqual(todos.first?.isCompleted, false)
    }

    func testToggleCompletion() {
        let cache = InMemoryCache()
        let todoManager = TodoManager(cache: cache)

        todoManager.addTodo(with: "Test Task")
        todoManager.toggleCompletion(forTodoAtIndex: 0)
        let todos = todoManager.listTodos()

        XCTAssertEqual(todos.first?.isCompleted, true)
    }

    func testDeleteTodo() {
        let cache = InMemoryCache()
        let todoManager = TodoManager(cache: cache)

        todoManager.addTodo(with: "Test Task")
        todoManager.deleteTodo(atIndex: 0)
        let todos = todoManager.listTodos()

        XCTAssertEqual(todos.count, 0)
    }

    func testIsValidIndex() {
        let cache = InMemoryCache()
        let todoManager = TodoManager(cache: cache)

        todoManager.addTodo(with: "Test Task")
        XCTAssertTrue(todoManager.isValidIndex(0))
        XCTAssertFalse(todoManager.isValidIndex(1))
    }
}

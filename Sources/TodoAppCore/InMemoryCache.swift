import Foundation

public final class InMemoryCache: Cache {

    public var inMemoryTodos = [Todo]()

    public func save(todos: [Todo]) {
        inMemoryTodos = todos
    }

    public func load() -> [Todo]? {
        return inMemoryTodos
    }
}
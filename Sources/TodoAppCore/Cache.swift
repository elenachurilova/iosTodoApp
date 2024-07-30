import Foundation

public protocol Cache {
    func save(todos: [Todo])
    func load() -> [Todo]?
}
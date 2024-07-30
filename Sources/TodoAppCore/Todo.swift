import Foundation

public struct Todo : CustomStringConvertible, Codable {
    public var id: UUID
    public var title: String
    public var isCompleted: Bool
    public var description: String {
        return "\(title) - \(isCompleted ? "Completed" : "Pending")"
    }
}
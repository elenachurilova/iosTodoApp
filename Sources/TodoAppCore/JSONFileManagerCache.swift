import Foundation

public final class JSONFileManagerCache: Cache {

    public init() {} // Make the initializer public for tests
    
    // Initilize FileManager first, and then create a new directory -> return its URL
    public func getFileURL() -> URL {
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
    
    public func save(todos: [Todo]) {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(todos)
            let fileURL = getFileURL()
            try jsonData.write(to: fileURL)
        } catch {
            print("JSONFileManagerCache: error writing to file: \(error)")
        }
    }

    public func load() -> [Todo]? { 
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
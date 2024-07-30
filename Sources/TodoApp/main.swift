import Foundation
import TodoAppCore

let app = App(cache: JSONFileManagerCache()) // Change to InMemoryCache() if needed
app.run()

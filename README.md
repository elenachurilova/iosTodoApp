# Swift TodoApp

## Overview

TodoApp is a simple command-line interface (CLI) application for managing your to-do list. You can add, list, toggle, and delete tasks. The app uses Swift and supports persistent storage with JSON files, as well as an in-memory option for temporary sessions.

## Features

- Add new tasks
- List all tasks
- Toggle task completion status
- Delete tasks
- Persistent storage with JSON files
- In-memory storage option

## Getting Started

### Prerequisites

- Swift 5.3 or later
- Git

### Installation

1. **Clone the repository:**

    ```sh
    git clone git@github.com:elenachurilova/iosTodoApp.git
    cd TodoApp
    ```

2. **Build the project:**

    ```sh
    swift build
    ```

3. **Run the application:**

    ```sh
    swift run
    ```

### Usage

When you run the application, you will see a welcome message and a prompt to enter commands:

```text
🌟 Welcome to To Do CLI 🌟

What would you like to do?
(add, list, toggle, delete, exit):
```


You can use the following commands:

- `add`: Add a new task.
- `list`: List all tasks.
- `toggle`: Toggle the completion status of a task.
- `delete`: Delete a task.
- `exit`: Exit the application.

### Running Tests

To run the tests for the project, use the following command:

```sh
swift test
```

### Using In-Memory Cache

By default, the application uses JSON files for persistent storage. If you prefer to use in-memory storage (which does not create files on your computer), you can update the `main.swift` file to use the `InMemoryCache` instead of the `JSONFileManagerCache`.

Example:

Update the `main.swift` file as follows:

```swift
import Foundation
import TodoAppCore

let app = App(cache: InMemoryCache()) 
app.run()
```

### Project structure 

```css
TodoApp/
├── Package.swift
├── README.md
├── Sources/
│   ├── TodoApp/
│   │   └── main.swift
│   └── TodoAppCore/
│       ├── App.swift
│       ├── Cache.swift
│       ├── InMemoryCache.swift
│       ├── JSONFileManagerCache.swift
│       ├── Todo.swift
│       └── TodoManager.swift
├── Tests/
│   └── TodoAppTests/
│       └── Tests.swift
```


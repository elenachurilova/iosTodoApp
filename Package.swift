// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TodoApp",
    products: [
        .executable(name: "TodoApp", targets: ["TodoApp"]),
        .library(name: "TodoAppCore", targets: ["TodoAppCore"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TodoAppCore",
            dependencies: []),
        .target(
            name: "TodoApp",
            dependencies: ["TodoAppCore"]),
        .testTarget(
            name: "TodoAppTests",
            dependencies: ["TodoAppCore"]),
    ]
)

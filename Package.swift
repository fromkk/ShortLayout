// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "ShortLayout",
    products: [
        .library(name: "ShortLayout", targets: ["ShortLayout"])
    ],
    targets: [
        .target(
            name: "ShortLayout",
            path: "Sources",
            exclude: []
        )
    ]
)

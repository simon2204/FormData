// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FormData",
    products: [
        .library(
            name: "FormData",
            targets: ["FormData"]
        ),
    ],
    targets: [
        .target(
            name: "FormData",
            dependencies: []
        ),
        .testTarget(
            name: "FormDataTests",
            dependencies: ["FormData"],
            resources: [.process("Resources")]
        ),
    ]
)

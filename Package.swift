// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Formdata",
    products: [
        .library(
            name: "Formdata",
            targets: ["Formdata"]
        ),
    ],
    targets: [
        .target(
            name: "Formdata",
            dependencies: []
        ),
        .testTarget(
            name: "FormdataTests",
            dependencies: ["Formdata"],
            resources: [.process("Resources")]
        ),
    ]
)

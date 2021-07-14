// swift-tools-version:5.4
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
            exclude: ["FormData.docc"]
        ),
        .testTarget(
            name: "FormDataTests",
            dependencies: ["FormData"]
        ),
    ]
)

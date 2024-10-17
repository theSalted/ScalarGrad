// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ScalarGrad",
    products: [
        .library(
            name: "ScalarGrad",
            targets: ["ScalarGrad"]),
        .executable(
            name: "ScalarGradExample",
            targets: ["ScalarGradExample"]),
    ],
    targets: [
        .target(
            name: "ScalarGrad",
            dependencies: []),
        .executableTarget(
            name: "ScalarGradExample",
            dependencies: ["ScalarGrad"]),
    ]
)

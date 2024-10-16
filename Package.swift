// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TinyGrad",
    products: [
        .library(
            name: "TinyGrad",
            targets: ["TinyGrad"]),
        .executable(
            name: "TinyGradExample",
            targets: ["TinyGradExample"]),
    ],
    targets: [
        .target(
            name: "TinyGrad",
            dependencies: []),
        .executableTarget(
            name: "TinyGradExample",
            dependencies: ["TinyGrad"]),
    ]
)

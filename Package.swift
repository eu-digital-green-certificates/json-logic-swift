// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "jsonfunctions",
    platforms: [
        .macOS(.v10_13), .iOS(.v11), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(
            name: "jsonfunctions",
            targets: ["jsonfunctions"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/Flight-School/AnyCodable",
            from: "0.6.0"
        ),
    ],
    targets: [
        .target(
            name: "jsonfunctions",
            dependencies: ["JSON", "AnyCodable"]),
        .target(
            name: "JSON",
            dependencies: []),
        .testTarget(
            name: "jsonfunctionsTests",
            dependencies: ["jsonfunctions", "AnyCodable"],
            resources: [.process("jfn-common-test-cases.json")]),
        .testTarget(
            name: "JSONTests",
            dependencies: ["JSON"])
    ],
    swiftLanguageVersions: [.v5, .v4_2, .v4]
)

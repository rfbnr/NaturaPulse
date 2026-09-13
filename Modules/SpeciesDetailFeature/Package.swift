// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpeciesDetailFeature",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SpeciesDetailFeature",
            targets: ["SpeciesDetailFeature"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SpeciesDetailFeature"
        ),
        .testTarget(
            name: "SpeciesDetailFeatureTests",
            dependencies: ["SpeciesDetailFeature"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "SpeciesDetailFeature",
    platforms: [
        .iOS("26.5")
    ],
    products: [
        .library(
            name: "SpeciesDetailFeature",
            targets: ["SpeciesDetailFeature"]
        )
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.10.0")
    ],
    targets: [
        .target(
            name: "SpeciesDetailFeature",
            dependencies: [
                "Common",
                "Swinject"
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        ),
        .testTarget(
            name: "SpeciesDetailFeatureTests",
            dependencies: [
                "SpeciesDetailFeature",
                "Common",
                .product(name: "CommonTestSupport", package: "Common")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)

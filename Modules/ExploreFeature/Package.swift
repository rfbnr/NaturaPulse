// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "ExploreFeature",
    platforms: [
        .iOS("26.5")
    ],
    products: [
        .library(
            name: "ExploreFeature",
            targets: ["ExploreFeature"]
        )
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(path: "../SpeciesDetailFeature"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.10.0")
    ],
    targets: [
        .target(
            name: "ExploreFeature",
            dependencies: [
                "Common",
                "SpeciesDetailFeature",
                "Swinject"
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        ),
        .testTarget(
            name: "ExploreFeatureTests",
            dependencies: [
                "ExploreFeature",
                "Common",
                .product(name: "CommonTestSupport", package: "Common")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)

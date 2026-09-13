// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "FieldGuideFeature",
    platforms: [
        .iOS("26.5")
    ],
    products: [
        .library(
            name: "FieldGuideFeature",
            targets: ["FieldGuideFeature"]
        )
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(path: "../SpeciesDetailFeature"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.10.0")
    ],
    targets: [
        .target(
            name: "FieldGuideFeature",
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
            name: "FieldGuideFeatureTests",
            dependencies: [
                "FieldGuideFeature",
                "Common",
                .product(name: "CommonTestSupport", package: "Common")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)

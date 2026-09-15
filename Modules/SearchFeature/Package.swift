// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "SearchFeature",
    platforms: [
        .iOS("26.5")
    ],
    products: [
        .library(
            name: "SearchFeature",
            targets: ["SearchFeature"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/rfbnr/NaturaPulse-Common.git", from: "1.0.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.10.0")
    ],
    targets: [
        .target(
            name: "SearchFeature",
            dependencies: [
                .product(name: "Common", package: "NaturaPulse-Common"),
                "Swinject"
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        ),
        .testTarget(
            name: "SearchFeatureTests",
            dependencies: [
                "SearchFeature",
                .product(name: "Common", package: "NaturaPulse-Common"),
                .product(name: "CommonTestSupport", package: "NaturaPulse-Common")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)

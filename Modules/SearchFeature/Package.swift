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
        .package(path: "../Common"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.10.0")
    ],
    targets: [
        .target(
            name: "SearchFeature",
            dependencies: [
                "Common",
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
                "Common",
                .product(name: "CommonTestSupport", package: "Common")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)

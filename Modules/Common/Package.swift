// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "Common",
    defaultLocalization: "en",
    platforms: [
        .iOS("26.5")
    ],
    products: [
        .library(
            name: "Common",
            targets: ["Common"]
        ),
        .library(
            name: "CommonTestSupport",
            targets: ["CommonTestSupport"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.12.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.10.0"),
        .package(url: "https://github.com/realm/realm-swift.git", exact: "20.0.5"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", exact: "8.12.0")
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [
                "Alamofire",
                "Swinject",
                .product(name: "RealmSwift", package: "realm-swift"),
                "Kingfisher"
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        ),
        .target(
            name: "CommonTestSupport",
            dependencies: [
                "Common"
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        ),
        .testTarget(
            name: "CommonTests",
            dependencies: [
                "Common",
                "CommonTestSupport",
                "Alamofire",
                .product(name: "RealmSwift", package: "realm-swift")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)

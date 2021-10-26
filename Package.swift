// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "blockchain-web-api",
    platforms: [
       .macOS(.v10_15)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.49.2"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.3.1"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.2.1"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.1.3"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.32.3"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
              .product(name: "Vapor", package: "vapor"),
              .product(name: "Fluent", package: "fluent"),
              .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
              .product(name: "Leaf", package: "leaf")
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)

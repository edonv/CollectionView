// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CollectionView",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14),
        .tvOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CollectionView",
            targets: ["CollectionView"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMajor(from: "1.0.0")
        ),
        .package(
            url: "https://github.com/edonv/CompositionalLayoutBuilder.git",
            .upToNextMajor(from: "0.0.0")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CollectionView",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
                .product(name: "CompositionalLayoutBuilder", package: "CompositionalLayoutBuilder")
            ],
            resources: [.copy("PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "CollectionViewTests",
            dependencies: ["CollectionView"]),
    ]
)

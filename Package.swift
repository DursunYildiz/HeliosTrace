// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "HeliosTrace",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "HeliosTrace",
            targets: ["HeliosTrace"]
        ),
    ],
    targets: [
        .target(
            name: "HeliosTrace",
            path: "Sources",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [.define("ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS")]
        ),
    ],
    swiftLanguageModes: [.v5]
)

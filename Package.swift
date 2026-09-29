// swift-tools-version:6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

internal import PackageDescription

let name = "MacroTester"

let swiftSettings: [SwiftSetting] = [
  .enableUpcomingFeature("InternalImportsByDefault")
]

let package = Package(
  name: name,
  platforms: [.macOS(.v13), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    .library(
      name: name,
      targets: [name]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "603.0.0")
  ],
  targets: [
    .target(
      name: name,
      dependencies: [
        .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacrosGenericTestSupport", package: "swift-syntax"),
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "\(name)Tests",
      dependencies: [
        .target(name: name),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
      ],
      resources: [.copy("Resources")],
      swiftSettings: swiftSettings
    ),
  ]
)

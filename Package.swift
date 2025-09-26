// swift-tools-version:6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let name = "MacroTester"

let package = Package(
  name: name,
  platforms: [.macOS(.v12), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    .library(
      name: name,
      targets: [name]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0")
  ],
  targets: [
    .target(
      name: name,
      dependencies: [
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
      ]
    )
  ]
)

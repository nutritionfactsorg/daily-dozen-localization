// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UrlCheckLib",
    defaultLocalization: "en",
    platforms: [
        // specify each minimum deployment requirement, 
        // otherwise the platform default minimum is used.
        SupportedPlatform.macOS(.v10_15), // .v10_13 High Sierra .v10_14 Mojave, .v10_15 Catalina
        // Note: .v10_15 and .v11_x are not enumerated on struct MacOSVersion
        // can also be a string like .macOS("11.3") or .macOS("10.10.1")
    ],
    products: [
        // Products define the executables and libraries produced by a package, 
        // and make them visible to other packages.
        Product.executable(
            name: "UrlCheckTool",
            targets: ["UrlCheckTool"]),
        Product.library(
            name: "UrlCheckLib",
            type: Product.Library.LibraryType.static,
            targets: ["UrlCheckLib"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        // .package( url: " ", .branch("master") )
    ],
    targets: [
        // Targets are the basic building blocks of a package. 
        // A target can define a module or a test suite.
        // Targets can depend on other targets in this package, 
        // and on products in packages which this package depends on.
        Target.target(
            name: "UrlCheckLib",
            dependencies: [],
            resources: [.copy("Resources/"),]
        ),
        Target.executableTarget(
            name: "UrlCheckTool",
            dependencies: ["UrlCheckLib"],
            resources: [.copy("Resources/"),]
        ),
        // Test UrlCheckLib directly instead of UrlCheckTool main.swift
        Target.testTarget(
            name: "UrlCheckLibTests",
            dependencies: ["UrlCheckLib"],
            resources: [.copy("Resources/"),]
        ),
    ],
    swiftLanguageVersions: [.v5],
    cLanguageStandard: .c11, // gnu11, iso9899_2011
    cxxLanguageStandard: .cxx14 // cxx11, gnucxx11, cxx14, gnucxx14, cxx1z, gnucxx1z
)

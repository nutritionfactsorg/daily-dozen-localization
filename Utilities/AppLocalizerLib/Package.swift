// swift-tools-version:5.4
// The swift-tools-version declares the minimum required Swift version.

import PackageDescription

let package = Package(
    name: "AppLocalizerLib",
    defaultLocalization: "en",
    platforms: [
        // specify each minimum deployment requirement, 
        // otherwise the platform default minimum is used.
        .macOS(.v10_15), // .v10_13 High Sierra .v10_14 Mojave, .v10_15 Catalina 
    ],
    products: [
        Product.executable(
            name: "AppLocalizerTool",
            targets: ["AppLocalizerTool"]),
        Product.library(
            name: "AppLocalizerLib",
            type: Product.Library.LibraryType.dynamic, // .static | .dynamic
            targets: ["AppLocalizerLib"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AppLocalizerLib",
            dependencies: [],
            // from: Sources/AppLocalizerLib/Resources/*
            //   to: AppLocalizerLib_AppLocalizerLib.bundle/Resources/*
            resources: [.copy("Resources/BatchCommands")]
        ),
        .executableTarget(
            name: "AppLocalizerTool",
            dependencies: ["AppLocalizerLib"]
        ),
        // Test AppLocalizerLib directly instead of AppLocalizerTool main.swift
        .testTarget(
            name: "AppLocalizerLibTests",
            dependencies: ["AppLocalizerLib"]
        ),
    ],
    swiftLanguageVersions: [.v5] //,
    //cLanguageStandard: .c11, // gnu11, iso9899_2011
    //cxxLanguageStandard: .cxx14 // cxx11, gnucxx11, cxx14, gnucxx14, cxx1z, gnucxx1z
)

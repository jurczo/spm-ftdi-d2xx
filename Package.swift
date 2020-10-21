// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FTDI",
    products: [
        .library(name: "FTDI", targets: ["FTDI"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "FTDI", dependencies: [], linkerSettings: [.unsafeFlags(["-LSources/FTDI/lib"])]),
        .testTarget(name: "FTDITests", dependencies: ["FTDI"]),
    ]
)

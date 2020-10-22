// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FTDI",
    platforms: [ .macOS("10.13") ],
    products: [
        .library(name: "FTDI", type: .dynamic, targets: ["FTDI"]),
    ],
    dependencies: [],
    targets: [
        .target(
		name: "FTDI",
		dependencies: [],
		resources: [.process("FTDI/lib")]
	),
        .testTarget(name: "FTDITests", dependencies: ["FTDI"]),
    ]
)

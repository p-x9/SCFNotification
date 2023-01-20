// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SCFNotification",
    products: [
        .library(
            name: "SCFNotification",
            targets: ["SCFNotification"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SCFNotification",
            dependencies: []
        ),
        .testTarget(
            name: "SCFNotificationTests",
            dependencies: ["SCFNotification"]
        ),
    ]
)

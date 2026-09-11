// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "swift-authentication-x509",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "AuthenticationX509",
            targets: ["AuthenticationX509"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-microservices/swift-authentication.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-certificates.git", from: "1.20.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "4.0.0"),
        .package(url: "https://github.com/apple/swift-service-context.git", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "AuthenticationX509",
            dependencies: [
                .product(name: "Authentication", package: "swift-authentication"),
                .product(name: "X509", package: "swift-certificates"),
            ]
        ),
        .testTarget(
            name: "AuthenticationX509Tests",
            dependencies: [
                .target(name: "AuthenticationX509"),
                .product(name: "Authentication", package: "swift-authentication"),
                .product(name: "X509", package: "swift-certificates"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "ServiceContextModule", package: "swift-service-context"),
            ]
        ),
    ]
)

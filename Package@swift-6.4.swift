// swift-tools-version: 6.0

// NB: This manifest is used by Swift 6.4+ toolchains (Xcode 27 and later). It turns this package
//     into a thin forwarding shim over 'swift-issue-reporting', so that both package identities can
//     coexist in one dependency graph. Older toolchains use 'Package.swift' instead, which is the
//     original, self-contained 1.x library: Xcode 26 and earlier cannot build a graph in which two
//     packages vend same-named products, so forwarding is only enabled where it works.

import Foundation
import PackageDescription

let package = Package(
  name: "xctest-dynamic-overlay",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],

  products: [
    .library(name: "IssueReporting", targets: ["_IssueReporting"]),
    .library(name: "IssueReportingTestSupport", targets: ["_IssueReportingTestSupport"]),
    .library(name: "XCTestDynamicOverlay", targets: ["XCTestDynamicOverlay"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-issue-reporting", from: "2.1.0")
  ],
  targets: [
    .target(
      name: "_IssueReporting",
      dependencies: [
        .product(name: "IssueReporting", package: "swift-issue-reporting")
      ]
    ),
    .target(
      name: "_IssueReportingTestSupport",
      dependencies: [
        .product(name: "IssueReportingTestSupport", package: "swift-issue-reporting")
      ]
    ),
    .target(
      name: "XCTestDynamicOverlay",
      dependencies: [
        .product(name: "IssueReporting", package: "swift-issue-reporting")
      ],
      path: "Sources/_XCTestDynamicOverlay"
    ),
  ],
  swiftLanguageModes: [.v6]
)

for target in package.targets {
  target.swiftSettings = target.swiftSettings ?? []
  target.swiftSettings?.append(contentsOf: [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
  ])
}

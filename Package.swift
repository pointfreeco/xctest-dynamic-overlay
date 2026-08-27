// swift-tools-version: 6.4

import Foundation
import PackageDescription

let package = Package(
  name: "xctest-dynamic-overlay",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
    .tvOS(.v15),
    .watchOS(.v9),
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
      dependencies: ["_IssueReporting"]
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

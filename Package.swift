// swift-tools-version: 6.0

// NB: This manifest is used by toolchains older than Swift 6.4 (Xcode 26 and earlier). It is the
//     original, self-contained 1.x library, unchanged. Swift 6.4+ toolchains (Xcode 27 and later)
//     use 'Package@swift-6.4.swift' instead, which forwards to 'swift-issue-reporting'. See README.

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
    .library(name: "IssueReporting", targets: ["IssueReporting"]),
    .library(
      name: "IssueReportingTestSupport",
      type: ProcessInfo.processInfo.environment["OMIT_DYNAMIC_TEST_SUPPORT"] == nil
        ? .dynamic
        : nil,
      targets: ["IssueReportingTestSupport"]
    ),
    .library(name: "XCTestDynamicOverlay", targets: ["XCTestDynamicOverlay"]),
  ],
  targets: [
    .target(
      name: "IssueReporting"
    ),
    .testTarget(
      name: "IssueReportingTests",
      dependencies: [
        "IssueReporting",
        "IssueReportingTestSupport",
      ]
    ),
    .testTarget(
      name: "IssueReportingTestsNoSupport",
      dependencies: [
        "IssueReporting"
      ]
    ),
    .target(
      name: "IssueReportingTestSupport"
    ),
    .target(
      name: "XCTestDynamicOverlay",
      dependencies: ["IssueReporting"]
    ),
    .testTarget(
      name: "XCTestDynamicOverlayTests",
      dependencies: [
        "IssueReportingTestSupport",
        "XCTestDynamicOverlay",
      ]
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

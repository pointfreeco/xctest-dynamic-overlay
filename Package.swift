// swift-tools-version: 6.0

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
    .library(name: "IssueReporting", targets: ["IssueReportingForwarding"]),
    // NB: This product must/Users/brandon/Library/Developer/Xcode/DerivedData/coexistence-demo-dyojeqontcsktqbbklqcglvbiwqo/SourcePackages/checkouts/swift-issue-reporting not be '.dynamic': the real 'IssueReportingTestSupport' dylib from
    //     'swift-issue-reporting' is already in the graph, and a second dynamic product with the
    //     same name would collide with it on the built artifact's file name.
    .library(
      name: "IssueReportingTestSupport",
      targets: ["IssueReportingTestSupportForwarding"]
    ),
    .library(name: "XCTestDynamicOverlay", targets: ["XCTestDynamicOverlay"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-issue-reporting", from: "2.0.0")
  ],
  targets: [
    .target(
      name: "IssueReportingForwarding",
      dependencies: [
        .product(name: "IssueReporting", package: "swift-issue-reporting")
      ]
    ),
    .target(
      name: "IssueReportingTestSupportForwarding",
      dependencies: [
        .product(name: "IssueReportingTestSupport", package: "swift-issue-reporting")
      ]
    ),
    .target(
      name: "XCTestDynamicOverlay",
      dependencies: [
        .product(name: "IssueReporting", package: "swift-issue-reporting")
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

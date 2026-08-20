# Testing in release mode

Learn about extra steps that must be taken when writing tests in release mode.

## Overview

Running your test suite in release mode can be helpful in tracking down even more potential issues
in your app since it exercises the exact code that will run on your users' devices. However, many of
the techniques employed by this package to allow for triggering test failures from app code are not
safe for release builds (or App Store submissions), and so they are hidden behind an `#if DEBUG`
flag. This means that test failures will not be triggered properly when running your tests in
release mode.

To fix this, you can have your _test targets_ depend on the "IssueReportingTestSupport" library that
comes with this package:

```swift
.testTarget(
  name: "FeatureTests",
  dependencies: [
    "Feature",
    .product(name: "IssueReportingTestSupport", package: "swift-issue-reporting"),
  ]
)
```

With that library linked the "IssueReporting" library will now be able to trigger test failures even
in release mode.

> Important: **Do not** link the "IssueReportingTestSupport" product to any target that is intended
> to be used in an app target. This will result in a variety of linker errors such as:
> 
> ```
> Undefined symbol: __swift_FORCE_LOAD_$_XCTestSwiftSupport
> Undefined symbol: XCTest.XCTExpectFailure<A>(_: Swift.String?, enabled: Swift.Bool?, strict: Swift.Bool?, failingBlock: () throws -> A, issueMatcher: ((XCTest.XCTIssue) -> Swift.Bool)?) throws -> A
> Undefined symbol: XCTest.XCTFail(_: Swift.String, file: Swift.StaticString, line: Swift.UInt) -> ()
> ```

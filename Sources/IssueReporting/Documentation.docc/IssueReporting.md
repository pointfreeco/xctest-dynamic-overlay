# ``IssueReporting``

Report issues in your application and library code as Xcode runtime warnings, breakpoints, 
assertions, and do so in a testable manner.

## Overview

> Important:
> Issue Reporting is an evolution of our previous library, XCTestDynamicOverlay. As such,
> to use this library you must depend on the old repository URL:
>
> ```
> https://github.com/pointfreeco/xctest-dynamic-overlay
> ```

This library provides robust tools for reporting issues in your application with a customizable
degree of granularity and severity. In its most basic form you use the unified
[`reportIssue`](<doc:reportIssue(_:fileID:filePath:line:column:)>) function anywhere in your
application to flag an issue in your code, such as a code path that you think should never be
executed:

```swift
guard let lastItem = items.last
else {
  reportIssue("'items' should never be empty.")
  return 
}
// ...
```

By default, [`reportIssue`](<doc:reportIssue(_:fileID:filePath:line:column:)>) will trigger an
unobtrusive, purple runtime warning when running your app in Xcode (simulator and device):

![A purple runtime warning in Xcode showing that an issue has been reported.](runtime-warning)

This provides a very visible way to see when an issue has occurred in your application without
stopping the app's execution and interrupting your workflow.

The [`reportIssue`](<doc:reportIssue(_:fileID:filePath:line:column:)>) tool can also be customized
to allow for other ways of reporting issues. It can be configured to trigger a breakpoint if you
want to do some debugging when an issue is reported, or a precondition or fatal error if you want
to truly stop execution. And you can create your own custom issue reporter to send issues to OSLog 
or an external server. 

Further, when running your code in a testing context (both XCTest and Swift's native Testing
framework), all reported issues become _test failures_. This helps you get test coverage that
problematic code paths are not executed, and makes it possible to build testing tools for libraries
that ship in the same target as the library itself.

![A test failure in Xcode where an issue has been reported.](test-failure)

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:ReleaseMode>
- <doc:CreatingTestHelpers>

### Reporting issues

- ``reportIssue(_:severity:fileID:filePath:line:column:)``
- ``withExpectedIssue(_:isIntermittent:fileID:filePath:line:column:_:)``
- ``withErrorReporting(_:to:fileID:filePath:line:column:catching:)``

### Issue reporters

- ``IssueReporter/breakpoint``
- ``IssueReporter/fatalError``
- ``IssueReporter/runtimeWarning``

### Custom reporting

- ``IssueReporter``
- ``withIssueReporters(_:operation:)``
- ``withIssueContext(fileID:filePath:line:column:operation:)``
- ``IssueReporters``

### Testing

- ``isTesting``
- ``TestContext``

### Unimplemented

- ``unimplemented(_:placeholder:fileID:filePath:function:line:column:)``

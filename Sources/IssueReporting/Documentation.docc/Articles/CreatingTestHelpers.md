# Creating testing tools

Learn how to build testing tools in your libraries using Issue Reporting.

## Overview

It is common for libraries to provide a set of tools that help one test code that is using said
library. One can use this library to power those testing tools, and that comes with two big 
benefits:

  * Your testing tools will simultaneously work in both XCTest and [swift-testing][testing-gh] with
    no further work from you. The Issue Reporting library detects which testing framework is being
    used, and correctly invokes either `XCTFail` or `Issue.record`.

  * You can put your testing tools in the same library as the core tools, without the need of a
    dedicated "test support" library. Typically testing tools need their own "test support" library
    because you cannot invoke `XCTFail` (or `Issue.record`) from app targets. Our library
    dynamically loads the symbols necessary to invoke those functions, and this makes it simpler for
    people to use your library since they only have one single target to think about.

## Case studies

We have two main uses cases for Issue Reporting in our libraries:

  * In the [Composable Architecture][tca-gh] we provide a `TestStore` tool that allows one to test
    their features. It allows you to send actions to the store and assert on how state changes, and
    further assert how effects feed data back into the system. These testing tools need to invoke
    `XCTFail` (or `Issue.record`), but instead they can simply invoke
    [`reportIssue`](<doc:reportIssue(_:fileID:filePath:line:column:)>). This will trigger a test
    failure in tests, all without needing a dedicated "ComposableArchitectureTestSupport" library.

  * In our [Dependencies][deps-gh] library, we trigger a test failure when dependencies are accessed
    in a test environment that have not been explicitly overridden. That helps to make sure people
    do not accidentally access live dependencies in tests. However, that does mean we must invoke
    `XCTFail` (or `Issue.record`) from within library to support this functionality, and generally
    speaking that is not possible. That is why we instead use `reportIssue` in Dependencies, and
    then everything works just fine.

## Your own libraries

To build more robust testing tools for your libraries, or to be able to report issues from your 
library that are very customizable, simply depend on "IssueReporting" and use the 
 [`reportIssue`](<doc:reportIssue(_:fileID:filePath:line:column:)>) tool.

[tca-gh]: https://github.com/pointfreeco/swift-composable-architecture
[deps-gh]: https://github.com/pointfreeco/swift-dependencies
[testing-gh]: https://github.com/apple/swift-testing

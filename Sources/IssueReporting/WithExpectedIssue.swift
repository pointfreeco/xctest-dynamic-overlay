/// Invoke a function that has an issue that is expected to occur during its execution.
///
/// A generalized version of Swift Testing's [`withKnownIssue`][withKnownIssue] that works with this
/// library's [`reportIssue`](<doc:reportIssue(_:fileID:filePath:line:column:)>) instead of just
/// Swift Testing's tools.
///
/// At runtime it can be used to lower the log level of reported issues:
///
/// ```swift
/// // Emits a "purple" warning to Xcode and logs a fault-level message to console
/// reportIssue("Failed")
///
/// withExpectedIssue {
///   // Simply logs an info-level message
///   reportIssue("Failed")
/// }
/// ```
///
/// During test runs, the issue will be sent to Swift Testing's [`withKnownIssue`][withKnownIssue]
/// _or_ XCTest's [`XCTExpectFailure`][XCTExpectFailure] accordingly, which means you can use it to
/// drive custom assertion helpers that you want to work in both Swift Testing and XCTest.
///
/// Errors thrown from the function are automatically caught and reported as issues:
///
/// ```swift
/// withExpectedIssue {
///   // If this function throws an error, it will be caught and reported as an issue
///   try functionThatCanFail()
/// }
/// ```
///
/// [withKnownIssue]: https://developer.apple.com/documentation/testing/withknownissue(_:isintermittent:sourcelocation:_:)
/// [XCTExpectFailure]: https://developer.apple.com/documentation/xctest/xctexpectfailure(_:options:failingblock:)
///
/// - Parameters:
///   - message: An optional message describing the expected issue.
///   - isIntermittent: Whether or not the expected issue occurs intermittently. If this argument is
///     `true` and the expected issue does not occur, no secondary issue is recorded.
///   - fileID: The source `#fileID` associated with the issue.
///   - filePath: The source `#filePath` associated with the issue.
///   - line: The source `#line` associated with the issue.
///   - column: The source `#column` associated with the issue.
///   - body: The function to invoke.
@_transparent
public func withExpectedIssue(
  _ message: String? = nil,
  isIntermittent: Bool = false,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column,
  _ body: () throws -> Void
) {
  guard let context = TestContext.current else {
    guard !isTesting else { return }
    let observer = FailureObserver()
    FailureObserver.$current.withValue(observer) {
      do {
        try body()
        if observer.withLock({ $0 == 0 }), !isIntermittent {
          for reporter in IssueReporters.current {
            reporter.reportIssue(
              "Known issue was not recorded\(message.map { ": \($0)" } ?? "")",
              fileID: IssueContext.current?.fileID ?? fileID,
              filePath: IssueContext.current?.filePath ?? filePath,
              line: IssueContext.current?.line ?? line,
              column: IssueContext.current?.column ?? column
            )
          }
        }
      } catch {
        for reporter in IssueReporters.current {
          reporter.expectIssue(
            error,
            message,
            fileID: IssueContext.current?.fileID ?? fileID,
            filePath: IssueContext.current?.filePath ?? filePath,
            line: IssueContext.current?.line ?? line,
            column: IssueContext.current?.column ?? column
          )
        }
      }
    }
    return
  }

  switch context {
  case .swiftTesting:
    _withKnownIssue(
      message,
      isIntermittent: isIntermittent,
      fileID: fileID.description,
      filePath: filePath.description,
      line: Int(line),
      column: Int(column),
      body
    )
  case .xcTest:
    _XCTExpectFailure(
      message.withAppHostWarningIfNeeded(),
      strict: !isIntermittent,
      file: filePath,
      line: line
    ) {
      do {
        try body()
      } catch {
        reportIssue(error, fileID: fileID, filePath: filePath, line: line, column: column)
      }
    }
  @unknown default: break
  }
}

#if compiler(>=6.0.2)
  /// Invoke an asynchronous function that has an issue that is expected to occur during its
  /// execution.
  ///
  /// An asynchronous version of
  /// ``withExpectedIssue(_:isIntermittent:fileID:filePath:line:column:_:)``.
  ///
  /// > Warning: The asynchronous version of this function is incompatible with XCTest and will
  /// > unconditionally report an issue when used, instead.
  ///
  /// - Parameters:
  ///   - message: An optional message describing the expected issue.
  ///   - isIntermittent: Whether or not the known expected occurs intermittently. If this argument
  ///     is `true` and the expected issue does not occur, no secondary issue is recorded.
  ///   - fileID: The source `#fileID` associated with the issue.
  ///   - filePath: The source `#filePath` associated with the issue.
  ///   - line: The source `#line` associated with the issue.
  ///   - column: The source `#column` associated with the issue.
  ///   - body: The asynchronous function to invoke.
  @_transparent
  public func withExpectedIssue(
    _ message: String? = nil,
    isIntermittent: Bool = false,
    isolation: isolated (any Actor)? = #isolation,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    _ body: _AsyncThrowingBody
  ) async {
    guard let context = TestContext.current else {
      guard !isTesting else { return }
      let observer = FailureObserver()
      await FailureObserver.$current.withValue(observer) {
        do {
          try await body()
          if observer.withLock({ $0 == 0 }), !isIntermittent {
            for reporter in IssueReporters.current {
              reporter.reportIssue(
                "Known issue was not recorded\(message.map { ": \($0)" } ?? "")",
                fileID: IssueContext.current?.fileID ?? fileID,
                filePath: IssueContext.current?.filePath ?? filePath,
                line: IssueContext.current?.line ?? line,
                column: IssueContext.current?.column ?? column
              )
            }
          }
        } catch {
          for reporter in IssueReporters.current {
            reporter.expectIssue(
              error,
              message,
              fileID: IssueContext.current?.fileID ?? fileID,
              filePath: IssueContext.current?.filePath ?? filePath,
              line: IssueContext.current?.line ?? line,
              column: IssueContext.current?.column ?? column
            )
          }
        }
      }
      return
    }

    switch context {
    case .swiftTesting:
      await _withKnownIssue(
        message,
        isIntermittent: isIntermittent,
        isolation: isolation,
        fileID: fileID.description,
        filePath: filePath.description,
        line: Int(line),
        column: Int(column),
        body
      )
    case .xcTest:
      reportIssue(
        """
        Asynchronously expecting failures is unavailable in XCTest.

        Omit this test from your XCTest suite, or consider using Swift Testing, instead.
        """,
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
      try? await body()
    @unknown default: break
    }
  }
#else
  @_transparent
  public func withExpectedIssue(
    _ message: String? = nil,
    isIntermittent: Bool = false,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    _ body: _AsyncThrowingBody
  ) async {
    guard let context = TestContext.current else {
      guard !isTesting else { return }
      let observer = FailureObserver()
      await FailureObserver.$current.withValue(observer) {
        do {
          try await body()
          if observer.withLock({ $0 == 0 }), !isIntermittent {
            for reporter in IssueReporters.current {
              reporter.reportIssue(
                "Known issue was not recorded\(message.map { ": \($0)" } ?? "")",
                fileID: IssueContext.current?.fileID ?? fileID,
                filePath: IssueContext.current?.filePath ?? filePath,
                line: IssueContext.current?.line ?? line,
                column: IssueContext.current?.column ?? column
              )
            }
          }
        } catch {
          for reporter in IssueReporters.current {
            reporter.expectIssue(
              error,
              message,
              fileID: IssueContext.current?.fileID ?? fileID,
              filePath: IssueContext.current?.filePath ?? filePath,
              line: IssueContext.current?.line ?? line,
              column: IssueContext.current?.column ?? column
            )
          }
        }
      }
      return
    }

    switch context {
    case .swiftTesting:
      await _withKnownIssue(
        message,
        isIntermittent: isIntermittent,
        fileID: fileID.description,
        filePath: filePath.description,
        line: Int(line),
        column: Int(column),
        body
      )
    case .xcTest:
      reportIssue(
        """
        Asynchronously expecting failures is unavailable in XCTest.

        Omit this test from your XCTest suite, or consider using Swift Testing, instead.
        """,
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
      try? await body()
    @unknown default: break
    }
  }
#endif

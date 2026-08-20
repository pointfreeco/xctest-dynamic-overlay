/// A type that can report issues.
public protocol IssueReporter: Sendable {
  /// Called when an issue is reported.
  ///
  /// - Parameters:
  ///   - message: A message describing the issue.
  ///   - severity: The severity of the issue.
  ///   - fileID: The source `#fileID` associated with the issue.
  ///   - filePath: The source `#filePath` associated with the issue.
  ///   - line: The source `#line` associated with the issue.
  ///   - column: The source `#column` associated with the issue.
  func reportIssue(
    _ message: @autoclosure () -> String?,
    severity: IssueSeverity,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  )

  /// Called when an error is caught.
  ///
  /// The default implementation of this conformance simply calls
  /// ``reportIssue(_:severity:fileID:filePath:line:column:)`` with a description of the error and
  /// `.error` severity.
  ///
  /// - Parameters:
  ///   - error: An error.
  ///   - message: A message describing the issue.
  ///   - fileID: The source `#fileID` associated with the issue.
  ///   - filePath: The source `#filePath` associated with the issue.
  ///   - line: The source `#line` associated with the issue.
  ///   - column: The source `#column` associated with the issue.
  func reportIssue(
    _ error: any Error,
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  )

  /// Called when an expected issue is reported.
  ///
  /// The default implementation of this conformance simply ignores the issue.
  ///
  /// - Parameters:
  ///   - message: A message describing the issue.
  ///   - fileID: The source `#fileID` associated with the issue.
  ///   - filePath: The source `#filePath` associated with the issue.
  ///   - line: The source `#line` associated with the issue.
  ///   - column: The source `#column` associated with the issue.
  func expectIssue(
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  )

  /// Called when an expected error is reported.
  ///
  /// The default implementation of this conformance simply ignores the error.
  ///
  /// - Parameters:
  ///   - error: An error.
  ///   - message: A message describing the issue.
  ///   - fileID: The source `#fileID` associated with the issue.
  ///   - filePath: The source `#filePath` associated with the issue.
  ///   - line: The source `#line` associated with the issue.
  ///   - column: The source `#column` associated with the issue.
  func expectIssue(
    _ error: any Error,
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  )

  /// Called when an issue is reported.
  ///
  /// > Important: This requirement has been deprecated in favor of
  /// > ``IssueReporter/reportIssue(_:severity:fileID:filePath:line:column:)``.
  ///
  /// - Parameters:
  ///   - message: A message describing the issue.
  ///   - fileID: The source `#fileID` associated with the issue.
  ///   - filePath: The source `#filePath` associated with the issue.
  ///   - line: The source `#line` associated with the issue.
  ///   - column: The source `#column` associated with the issue.
  func reportIssue(
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  )
}

extension IssueReporter {
  @_transparent
  public func reportIssue(
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    reportIssue(
      message(),
      severity: .error,
      fileID: fileID,
      filePath: filePath,
      line: line,
      column: column
    )
  }

  @_transparent
  public func reportIssue(
    _ error: any Error,
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    reportIssue(
      "Caught error: \(error)\(message().map { ": \($0)" } ?? "")",
      severity: .error,
      fileID: fileID,
      filePath: filePath,
      line: line,
      column: column
    )
  }

  public func expectIssue(
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {}

  public func expectIssue(
    _ error: any Error,
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    expectIssue(
      "Caught error: \(error)\(message().map { ": \($0)" } ?? "")",
      fileID: fileID,
      filePath: filePath,
      line: line,
      column: column
    )
  }
}

public enum IssueReporters {
  /// The task's current issue reporters.
  ///
  /// Assigning this directly will override the which issue reporters are notified in the current
  /// task. This is generally useful at the entry point of your application, should you want to
  /// replace the default reporting:
  ///
  /// ```swift
  /// import IssueReporting
  ///
  /// @main
  /// struct MyApp: App {
  ///   init() {
  ///     IssueReporters.current = [.fatalError]
  ///   }
  ///
  ///   var body: some Scene {
  ///     // ...
  ///   }
  /// }
  /// ```
  ///
  /// Issue reporters are fed issues in order.
  ///
  /// To override the task's issue reporters for a scoped operation, prefer
  /// ``withIssueReporters(_:operation:)``.
  public static var current: [any IssueReporter] {
    get { _current.withLock { $0 } }
    set { _current.withLock { $0 = newValue } }
  }

  @TaskLocal fileprivate static var _current = LockIsolated<[any IssueReporter]>([.default])
}

/// Overrides the task's issue reporters for the duration of the synchronous operation.
///
/// For example, you can ignore all reported issues by passing an empty array of reporters:
///
/// ```swift
/// withIssueReporters([]) {
///   // Reported issues will be ignored here...
/// }
/// ```
///
/// Or, to temporarily add a custom reporter, you can append it to ``IssueReporters/current``:
///
/// ```swift
/// withIssueReporters(IssueReporters.current + [MyCustomReporter()]) {
///   // Reported issues will be fed to the
/// }
/// ```
///
/// - Parameters:
///   - reporters: Issue reporters to notify during the operation.
///   - operation: A synchronous operation.
public func withIssueReporters<R>(
  _ reporters: [any IssueReporter],
  operation: () throws -> R
) rethrows -> R {
  try IssueReporters.$_current.withValue(LockIsolated(reporters), operation: operation)
}

/// Overrides the task's issue reporters for the duration of the asynchronous operation.
///
/// An asynchronous version of ``withIssueReporters(_:operation:)``.
///
/// - Parameters:
///   - reporters: Issue reporters to notify during the operation.
///   - isolation: The isolation associated with the operation.
///   - operation: An asynchronous operation.
public func withIssueReporters<R>(
  _ reporters: [any IssueReporter],
  isolation: isolated (any Actor)? = #isolation,
  operation: () async throws -> R
) async rethrows -> R {
  try await IssueReporters.$_current.withValue(LockIsolated(reporters), operation: operation)
}

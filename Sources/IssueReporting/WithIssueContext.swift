/// Sets the context for issues reported for the duration of the synchronous operation.
///
/// This context will override the implicit context from the call sites of
/// ``reportIssue(_:fileID:filePath:line:column:)`` and
/// ``withExpectedIssue(_:isIntermittent:fileID:filePath:line:column:_:)``, and can be leveraged by
/// custom test helpers that want to associate reported issues with specific source code.
///
/// - Parameters:
///   - fileID: The source `#fileID` to associate with issues reported during the operation.
///   - filePath: The source `#filePath` to associate with issues reported during the operation.
///   - line: The source `#line` to associate with issues reported during the operation.
///   - column: The source `#column` to associate with issues reported during the operation.
///   - operation: A synchronous operation.
public func withIssueContext<R>(
  fileID: StaticString,
  filePath: StaticString,
  line: UInt,
  column: UInt,
  operation: () throws -> R
) rethrows -> R {
  try IssueContext.$current.withValue(
    IssueContext(fileID: fileID, filePath: filePath, line: line, column: column),
    operation: operation
  )
}

/// Sets the context for issues reported for the duration of the asynchronous operation.
///
/// An asynchronous version of ``withIssueContext(fileID:filePath:line:column:operation:)``.
///
/// - Parameters:
///   - fileID: The source `#fileID` to associate with issues reported during the operation.
///   - filePath: The source `#filePath` to associate with issues reported during the operation.
///   - line: The source `#line` to associate with issues reported during the operation.
///   - column: The source `#column` to associate with issues reported during the operation.
///   - operation: An asynchronous operation.
public func withIssueContext<R>(
  fileID: StaticString,
  filePath: StaticString,
  line: UInt,
  column: UInt,
  isolation: isolated (any Actor)? = #isolation,
  operation: () async throws -> R
) async rethrows -> R {
  try await IssueContext.$current.withValue(
    IssueContext(fileID: fileID, filePath: filePath, line: line, column: column),
    operation: operation,
    isolation: isolation
  )
}

@usableFromInline
struct IssueContext: Sendable {
  @TaskLocal public static var current: Self?
  @usableFromInline
  let fileID: StaticString
  @usableFromInline
  let filePath: StaticString
  @usableFromInline
  let line: UInt
  @usableFromInline
  let column: UInt
}

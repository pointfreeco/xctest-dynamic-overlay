#if canImport(Testing)
  import Testing
#endif

public func _recordIssue() -> Any { __recordIssue }
@Sendable
private func __recordIssue(
  message: String?,
  severity: Int,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int
) {
  #if canImport(Testing)
    let message = message == "" ? nil : message
    #if compiler(>=6.3)
      let issueSeverity: Issue.Severity = severity == 0 ? .warning : .error
      Issue.record(
        message.map(Comment.init(rawValue:)),
        severity: issueSeverity,
        sourceLocation: SourceLocation(
          fileID: fileID,
          filePath: filePath,
          line: line,
          column: column
        )
      )
    #else
      Issue.record(
        message.map(Comment.init(rawValue:)),
        sourceLocation: SourceLocation(
          fileID: fileID,
          filePath: filePath,
          line: line,
          column: column
        )
      )
    #endif
  #endif
}

public func _recordError() -> Any { __recordError }
@Sendable
private func __recordError(
  error: any Error,
  message: String?,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int
) {
  #if canImport(Testing)
    Issue.record(
      error,
      message.map(Comment.init(rawValue:)),
      sourceLocation: SourceLocation(
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
    )
  #endif
}

public func _withKnownIssue() -> Any { __withKnownIssue }
@Sendable
private func __withKnownIssue(
  _ message: String?,
  isIntermittent: Bool,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int,
  _ body: () throws -> Void
) {
  #if canImport(Testing)
    withKnownIssue(
      message.map(Comment.init(rawValue:)),
      isIntermittent: isIntermittent,
      sourceLocation: SourceLocation(
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      ),
      body
    )
  #endif
}

public func _withKnownIssueAsync() -> Any {
  __withKnownIssueAsync(_:isIntermittent:fileID:filePath:line:column:_:)
}
@Sendable
private func __withKnownIssueAsync(
  _ message: String?,
  isIntermittent: Bool,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int,
  _ body: () async throws -> Void
) async {
  #if canImport(Testing)
    await withKnownIssue(
      message.map(Comment.init(rawValue:)),
      isIntermittent: isIntermittent,
      sourceLocation: SourceLocation(
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      ),
      body
    )
  #endif
}

#if compiler(>=6.0.2)
  public func _withKnownIssueAsyncIsolated() -> Any {
    __withKnownIssueAsync(_:isIntermittent:isolation:fileID:filePath:line:column:_:)
  }
  @Sendable
  private func __withKnownIssueAsync(
    _ message: String?,
    isIntermittent: Bool,
    isolation: isolated (any Actor)?,
    fileID: String,
    filePath: String,
    line: Int,
    column: Int,
    _ body: () async throws -> Void
  ) async {
    #if canImport(Testing)
      await withKnownIssue(
        message.map(Comment.init(rawValue:)),
        isIntermittent: isIntermittent,
        isolation: isolation,
        sourceLocation: SourceLocation(
          fileID: fileID,
          filePath: filePath,
          line: line,
          column: column
        ),
        body
      )
    #endif
  }
#endif

public func _currentTest() -> Any { __currentTest }
@Sendable
private func __currentTest() -> _Test? {
  #if canImport(Testing)
    return Test.current.map { _Test(id: $0.id, traits: $0.traits) }
  #else
    return nil
  #endif
}

#if canImport(Testing) && !os(Windows)
  import IssueReporting
  import Testing

  @Suite
  struct UnimplementedTests {
    @Test func unimplemented_ReturningVoid() {
      final class Model: Sendable {
        let line = #line + 1
        let callback: @Sendable (Int) -> Void = unimplemented()
      }

      let model = Model()
      withKnownIssue {
        model.callback(42)
      } matching: { issue in
        issue.description == """
          Issue recorded\(issueDescriptionSuffix): Unimplemented …

            Defined in 'Model' at:
              IssueReportingTests/UnimplementedTests.swift:\(model.line)

            Invoked with:
              42
          """
      }
    }

    @Test func unimplemented_VoidToVoid() {
      final class Model: Sendable {
        let line = #line + 1
        let callback: @Sendable () -> Void = unimplemented()
      }

      let model = Model()
      withKnownIssue {
        model.callback()
      } matching: { issue in
        issue.description == """
          Issue recorded\(issueDescriptionSuffix): Unimplemented …

            Defined in 'Model' at:
              IssueReportingTests/UnimplementedTests.swift:\(model.line)

            Invoked with:
              ()
          """
      }
    }

    @Test func unimplemented_NonVoidReturning() {
      final class Model: Sendable {
        let line = #line + 1
        let callback: @Sendable () -> Int = unimplemented(placeholder: 42)
      }

      let model = Model()
      withKnownIssue {
        _ = model.callback()
      } matching: { issue in
        issue.description == """
          Issue recorded\(issueDescriptionSuffix): Unimplemented …

            Defined in 'Model' at:
              IssueReportingTests/UnimplementedTests.swift:\(model.line)

            Invoked with:
              ()
          """
      }
    }

    @Test func unimplemented_ThrowingFunction() throws {
      final class Model: Sendable {
        let line = #line + 1
        let callback: @Sendable () throws -> Void = unimplemented()
      }

      let model = Model()
      try withKnownIssue {
        _ = try model.callback()
      } matching: { issue in
        issue.description == """
          Issue recorded\(issueDescriptionSuffix): Unimplemented …

            Defined in 'Model' at:
              IssueReportingTests/UnimplementedTests.swift:\(model.line)

            Invoked with:
              ()
          """
          || issue.description == """
            Caught error: UnimplementedFailure(description: "")\(issueDescriptionSuffix)
            """
      }
    }

    @Test func throwing() throws {
      final class Model: Sendable {
        let line = #line + 1
        let callback: @Sendable () throws -> Void = IssueReporting.unimplemented()
      }

      let model = Model()
      try withKnownIssue {
        try withKnownIssue {
          _ = try model.callback()
        } matching: { issue in
          issue.description == """
            Issue recorded\(issueDescriptionSuffix): Unimplemented …

              Defined in 'Model' at:
                IssueReportingTests/UnimplementedTests.swift:\(model.line)

              Invoked with:
                ()
            """
        }
      } matching: { issue in
        issue.description == """
          Caught error: UnimplementedFailure(description: "")\(issueDescriptionSuffix)
          """
      }
    }

    @MainActor
    @Test func mainActor() throws {
      final class Model: Sendable {
        let line = #line + 1
        let callback: @Sendable @MainActor () throws -> Void = IssueReporting.unimplemented()
      }

      let model = Model()
      try withKnownIssue {
        try withKnownIssue {
          _ = try model.callback()
        } matching: { issue in
          issue.description == """
            Issue recorded\(issueDescriptionSuffix): Unimplemented …

              Defined in 'Model' at:
                IssueReportingTests/UnimplementedTests.swift:\(model.line)

              Invoked with:
                ()
            """
        }
      } matching: { issue in
        issue.description == """
          Caught error: UnimplementedFailure(description: "")\(issueDescriptionSuffix)
          """
      }
    }
  }
#endif

#if canImport(Testing)
  import IssueReporting
  import Testing

  @Suite struct WithExpectedIssueTests {
    @Test func sync() {
      withExpectedIssue {
        reportIssue("Oops!")
      }
    }

    @Test func syncThrows() throws {
      withExpectedIssue {
        reportIssue("Oops!")
        throw SomeError()
      }
    }

    @Test func asyncAwaitBefore() async {
      await withExpectedIssue {
        await Task.yield()
        reportIssue("Oops!")
      }
    }

    @Test func asyncAwaitAfter() async {
      await withExpectedIssue {
        reportIssue("Oops!")
        await Task.yield()
      }
    }

    @Test func asyncAwaitBeforeThrows() async throws {
      await withExpectedIssue {
        await Task.yield()
        reportIssue("Oops!")
        throw SomeError()
      }
    }

    @Test func asyncAwaitAfterThrows() async throws {
      await withExpectedIssue {
        reportIssue("Oops!")
        await Task.yield()
        throw SomeError()
      }
    }
  }

  private struct SomeError: Error {}
#endif

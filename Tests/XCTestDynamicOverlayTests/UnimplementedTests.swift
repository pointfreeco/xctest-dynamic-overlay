#if !os(Linux) && !os(WASI) && !os(Windows) && !os(Android)
  import XCTest

  final class UnimplementedTests: XCTestCase {

    @available(*, deprecated)
    @MainActor
    func testXCTReferencingUnimplementedClosureDoesNotEvaluateIt() async throws {
      _ = fm00
      _ = fm01
    }

    func testXCTFailShouldFail() async throws {
      _ = XCTExpectFailure {
        f00()
      } issueMatcher: {
        $0.compactDescription == """
          failed - Unimplemented: f00 …

            Defined in 'XCTestDynamicOverlayTests' at:
              XCTestDynamicOverlayTests/TestHelpers.swift:99

            Invoked with:
              ()
          """
      }

      _ = XCTExpectFailure {
        f01("")
      } issueMatcher: {
        $0.compactDescription == """
          failed - Unimplemented: f01 …

            Defined in 'XCTestDynamicOverlayTests' at:
              XCTestDynamicOverlayTests/TestHelpers.swift:100

            Invoked with:
              ""
          """
      }

      _ = XCTExpectFailure {
        f02("", 42)
      } issueMatcher: {
        $0.compactDescription == """
          failed - Unimplemented: f02 …

            Defined in 'XCTestDynamicOverlayTests' at:
              XCTestDynamicOverlayTests/TestHelpers.swift:101

            Invoked with:
              ("", 42)
          """
      }

      _ = XCTExpectFailure {
        f03("", 42, 1.2)
      } issueMatcher: {
        $0.compactDescription == """
          failed - Unimplemented: f03 …

            Defined in 'XCTestDynamicOverlayTests' at:
              XCTestDynamicOverlayTests/TestHelpers.swift:102

            Invoked with:
              ("", 42, 1.2)
          """
      }

      _ = XCTExpectFailure {
        f04("", 42, 1.2, [1, 2])
      } issueMatcher: {
        $0.compactDescription == """
          failed - Unimplemented: f04 …

            Defined in 'XCTestDynamicOverlayTests' at:
              XCTestDynamicOverlayTests/TestHelpers.swift:103

            Invoked with:
              ("", 42, 1.2, [1, 2])
          """
      }

      _ = XCTExpectFailure {
        f05(
          "", 42, 1.2, [1, 2], User(id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!)
        )
      } issueMatcher: {
        $0.compactDescription == """
          failed - Unimplemented: f05 …

            Defined in 'XCTestDynamicOverlayTests' at:
              XCTestDynamicOverlayTests/TestHelpers.swift:104

            Invoked with:
              ("", 42, 1.2, [1, 2], XCTestDynamicOverlayTests.User(id: DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF))
          """
      }
    }
  }
#endif

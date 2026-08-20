import XCTest
import XCTestDynamicOverlay

#if canImport(ObjectiveC)
  final class XCTExpectFailureTests: XCTestCase {
    func testXCTDynamicOverlayWithBlockShouldFail() async throws {
      MyXCTExpectFailure("This is expected to pass.", strict: false) {
        XCTAssertEqual(42, 42)
      }

      MyXCTExpectFailure("This is expected to pass.", strict: true) {
        XCTAssertEqual(42, 1729)
      } issueMatcher: {
        $0.compactDescription == #"XCTAssertEqual failed: ("42") is not equal to ("1729")"#
      }

      if ProcessInfo.processInfo.environment["TEST_FAILURE"] != nil {
        MyXCTExpectFailure("This is expected to fail!", strict: true) {
          XCTAssertEqual(42, 42)
        }
      }
    }

    func testXCTDynamicOverlayShouldFail() async throws {
      MyXCTExpectFailure("This is expected to pass.", strict: true) {
        $0.compactDescription == #"XCTAssertEqual failed: ("42") is not equal to ("1729")"#
      }
      XCTAssertEqual(42, 1729)
    }
  }
#endif

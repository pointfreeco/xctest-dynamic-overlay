import XCTest

final class XCTFailTests: XCTestCase {
  func testXCTFailShouldFail() async throws {
    if ProcessInfo.processInfo.environment["TEST_FAILURE"] != nil {
      MyXCTFail("This is expected to fail!")
    }
  }
}

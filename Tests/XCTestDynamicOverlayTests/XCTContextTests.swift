#if !os(Linux) && !os(WASI) && !os(Windows) && !os(Android)
  import XCTest
  import XCTestDynamicOverlay

  final class XCTContextTests: XCTestCase {
    func testContext() {
      XCTExpectFailure {
        $0.compactDescription == "failed - Failed"
          && $0.sourceCodeContext.location
            == XCTSourceCodeLocation(filePath: "unknown", lineNumber: 1)
      }
      XCTFailContext.$current.withValue(XCTFailContext(file: "unknown", line: 1)) {
        XCTestDynamicOverlay.XCTFail("Failed")
      }
    }
  }
#endif

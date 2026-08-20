import XCTest
import XCTestDynamicOverlay

// This ensures `XCTest.XCTFail` takes precedence over `XCTestDynamicOverlay.XCTFail` when both are imported.
//
// For full details, see https://github.com/pointfreeco/swift-dependencies/issues/13
public enum Foo {
  func exampleHelper(
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTFail(
      "This should compile.",
      file: file, line: line
    )
  }
}

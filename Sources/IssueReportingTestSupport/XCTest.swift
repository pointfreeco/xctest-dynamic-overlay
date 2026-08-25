#if canImport(XCTest)
  import XCTest
#endif

public func _XCTFail() -> Any { __XCTFail }
@Sendable
private func __XCTFail(_ message: String, file: StaticString, line: UInt) {
  #if canImport(XCTest)
    XCTFail(message, file: file, line: line)
  #endif
}

public func _XCTExpectFailure() -> Any { __XCTExpectFailure }
@_transparent
@Sendable
private func __XCTExpectFailure(
  _ failureReason: String?,
  enabled: Bool?,
  strict: Bool?,
  failingBlock: () throws -> Void
) rethrows {
  #if canImport(XCTest)
    #if _runtime(_ObjC)
      try XCTExpectFailure(
        failureReason,
        enabled: enabled,
        strict: strict,
        failingBlock: failingBlock
      )
    #else
      try failingBlock()
    #endif
  #endif
}

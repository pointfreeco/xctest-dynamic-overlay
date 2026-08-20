#if DEBUG
  #if _runtime(_ObjC)
    public import Foundation
  #endif

  #if canImport(Darwin)
    public import Darwin
  #elseif canImport(Glibc)
    public import Glibc
  #elseif canImport(WinSDK)
    public import WinSDK
  #endif
#endif

@usableFromInline
func _XCTFail(
  _ message: String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) {
  #if !_runtime(_ObjC)
    guard !_XCTExpectedFailure.isInFailingBlock else { return }
  #endif
  guard let function = function(for: "$s25IssueReportingTestSupport8_XCTFailypyF")
  else {
    #if DEBUG
      if let XCTFail = unsafeBitCast(
        symbol: "$s6XCTest7XCTFail_4file4lineySS_s12StaticStringVSutF",
        in: "XCTest",
        to: (@convention(thin) (String, StaticString, UInt) -> Void).self
      ) {
        XCTFail(message, file, line)
        return
      }
    #endif
    printError(
      """
      \(file):\(line): A failure was recorded without linking the XCTest framework\
      \(message.isEmpty ? "" : ": \(message)")

      To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
      """
    )
    return
  }
  let XCTFail = function as! @Sendable (String, StaticString, UInt) -> Void
  XCTFail(message, file, line)
}

@_transparent
@usableFromInline
func _XCTExpectFailure<R>(
  _ failureReason: String? = nil,
  enabled: Bool? = nil,
  strict: Bool? = nil,
  file: StaticString,
  line: UInt,
  failingBlock: () throws -> R
) rethrows -> R {
  #if _runtime(_ObjC)
    guard let function = function(for: "$s25IssueReportingTestSupport17_XCTExpectFailureypyF")
    else {
      #if DEBUG
        guard enabled != false
        else { return try failingBlock() }
        if let pointer = dlsym(dlopen(nil, RTLD_NOW), "XCTExpectFailureWithOptionsInBlock"),
          let XCTExpectedFailureOptions = NSClassFromString("XCTExpectedFailureOptions")
            as Any as? any NSObjectProtocol,
          let options = strict ?? true
            ? XCTExpectedFailureOptions
              .perform(NSSelectorFromString("alloc"))?.takeUnretainedValue()
              .perform(NSSelectorFromString("init"))?.takeUnretainedValue()
            : XCTExpectedFailureOptions
              .perform(NSSelectorFromString("nonStrictOptions"))?.takeUnretainedValue()
        {
          let XCTExpectFailureInBlock = unsafeBitCast(
            pointer,
            to: (@convention(c) (String?, AnyObject, () -> Void) -> Void).self
          )
          var result: Result<R, any Error>?
          XCTExpectFailureInBlock(failureReason, options) {
            result = Result { try failingBlock() }
          }
          return try result!._rethrowGet()
        }
      #else
        printError(
          """
          \(file):\(line): An expected failure was recorded without linking the XCTest framework.

          To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
          """
        )
      #endif
      return try failingBlock()
    }
    let XCTExpectFailure =
      function
      as! @Sendable (String?, Bool?, Bool?, () throws -> Void) throws -> Void
    var result: Result<R, any Error>!
    do {
      try XCTExpectFailure(failureReason, enabled, strict) {
        result = Result { try failingBlock() }
      }
    } catch {
      fatalError()
    }
    return try result._rethrowGet()
  #else
    _XCTFail(
      """
      Expecting failures is unavailable in XCTest on this platform.

      Omit this test from your suite by wrapping it in '#if canImport(Darwin)', or consider using \
      Swift Testing and 'withKnownIssue', instead.
      """
    )
    return try _XCTExpectedFailure.$isInFailingBlock.withValue(true) {
      try failingBlock()
    }
  #endif
}

#if !_runtime(_ObjC)
  @usableFromInline
  enum _XCTExpectedFailure {
    @TaskLocal public static var isInFailingBlock = false
  }
#endif

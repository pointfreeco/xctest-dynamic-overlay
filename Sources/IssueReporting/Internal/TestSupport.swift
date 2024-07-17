import Foundation

#if os(Windows)
  import WinSDK
#endif

@usableFromInline
func _recordIssue(
  message: String?,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int
) {
  guard let pointer = pointer(for: "IssueReportingTestSupport_RecordIssue")
  else { return }

  let recordIssue = withUnsafePointer(to: pointer) {
    UnsafeRawPointer($0).assumingMemoryBound(to: DynamicFunction.self)
      .pointee() as! (String?, String, String, Int, Int) -> Void
  }

  recordIssue(message, fileID, filePath, line, column)
}

@usableFromInline
func _withKnownIssue(
  _ message: String?,
  isIntermittent: Bool,
  _ body: () throws -> Void
) {
  guard let pointer = pointer(for: "IssueReportingTestSupport_WithKnownIssue")
  else { return }

  let withKnownIssue = withUnsafePointer(to: pointer) {
    UnsafeRawPointer($0).assumingMemoryBound(to: DynamicFunction.self)
      .pointee() as! (String?, Bool, () throws -> Void) -> Void
  }

  withKnownIssue(message, isIntermittent, body)
}


@usableFromInline
func _currentTestIsNotNil() -> Bool {
  guard let pointer = pointer(for: "IssueReportingTestSupport_CurrentTestIsNotNil")
  else { return false }

  let currentTestIsNotNil = withUnsafePointer(to: pointer) {
    UnsafeRawPointer($0).assumingMemoryBound(to: DynamicFunction.self)
      .pointee() as! () -> Bool
  }

  return currentTestIsNotNil()
}

@usableFromInline
func _XCTFail(_ message: String, file: StaticString, line: UInt) {
  guard let pointer = pointer(for: "IssueReportingTestSupport_XCTFail")
  else { return }

  let XCTFail = withUnsafePointer(to: pointer) {
    UnsafeRawPointer($0).assumingMemoryBound(to: DynamicFunction.self)
      .pointee() as! (String, StaticString, UInt) -> Void
  }

  XCTFail(message, file, line)
}

@usableFromInline
func _XCTExpectFailure(
  _ failureReason: String?,
  strict: Bool?,
  failingBlock: () throws -> Void
) rethrows {
  guard let pointer = pointer(for: "IssueReportingTestSupport_XCTExpectFailure")
  else { return }

  let XCTExpectFailure = withUnsafePointer(to: pointer) {
    UnsafeRawPointer($0).assumingMemoryBound(to: DynamicFunction.self)
      .pointee() as! (String?, Bool?, () throws -> Void) throws -> Void
  }

  try Result { try XCTExpectFailure(failureReason, strict, failingBlock) }._rethrowGet()
}

#if os(Linux) || os(Windows)
  private typealias DynamicFunction = @convention(thin) () -> Any
#else
  private typealias DynamicFunction = @convention(c) () -> Any
#endif

private func pointer(for symbol: String) -> UnsafeMutableRawPointer? {
  #if os(Linux)
    let symbol = symbolMap[symbol] ?? symbol
    guard
      let handle = dlopen("libIssueReportingTestSupport.so", RTLD_LAZY),
      let pointer = dlsym(handle, symbol)
    else { return nil }
    return pointer
  #elseif os(Windows)
    let symbol = symbolMap[symbol]
    guard
      let handle = LoadLibraryA("IssueReportingTestSupport.dll"),
      let pointer = GetProcAddress(handle, symbol)
    else { return nil }
    return pointer
  #else
    guard
      let prefix,
      let path = Bundle.module
        .path(forResource: "\(prefix)_IssueReportingTestSupport", ofType: nil),
      let handle = dlopen(path, RTLD_LAZY),
      let pointer = dlsym(handle, symbol)
    else { return nil }
    return pointer
  #endif
}

private let prefix: String? = {
  #if targetEnvironment(macCatalyst)
    return "ios-arm64_x86_64-maccatalyst"
  #elseif os(iOS)
    #if targetEnvironment(simulator)
      return "ios-arm64_x86_64-simulator"
    #else
      return "ios-arm64"
    #endif
  #elseif os(macOS)
    return "macos-arm64_x86_64"
  #elseif os(tvOS)
    #if targetEnvironment(simulator)
      return "tvos-arm64_x86_64-simulator"
    #else
      return "tvos-arm64"
    #endif
  #elseif os(visionOS)
    #if targetEnvironment(simulator)
      return "xros-arm64_x86_64-simulator"
    #else
      return "xros-arm64"
    #endif
  #elseif os(watchOS)
    #if targetEnvironment(simulator)
      return "watchos-arm64_x86_64-simulator"
    #else
      return "watchos-arm64_arm64_32_armv7k"
    #endif
  #else
    return nil
  #endif
}()

#if os(Linux) || os(Windows)
  private let symbolMap: [String: String] = [
    "IssueReportingTestSupport_RecordIssue": "$s25IssueReportingTestSupport07_recordA0ypyF",
    "IssueReportingTestSupport_WithKnownIssue": "$s25IssueReportingTestSupport010_withKnownA0ypyF",
    "IssueReportingTestSupport_CurrentTestIsNotNil":
      "$s25IssueReportingTestSupport08_currentC8IsNotNilypyF",
    "IssueReportingTestSupport_XCTFail": "$s25IssueReportingTestSupport8_XCTFailypyF",
    "IssueReportingTestSupport_XCTExpectFailure":
      "$s25IssueReportingTestSupport17_XCTExpectFailureypyF",
  ]
#endif

import Foundation

// NB: Deprecated after 1.1.2

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "reportIssue")
@available(macOS, deprecated: 9999, renamed: "reportIssue")
@available(tvOS, deprecated: 9999, renamed: "reportIssue")
@available(watchOS, deprecated: 9999, renamed: "reportIssue")
public func XCTFail(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
  reportIssue(
    message,
    filePath: XCTFailContext.current?.file ?? file,
    line: XCTFailContext.current?.line ?? line
  )
}

@available(iOS, deprecated: 9999, renamed: "IssueContext")
@available(macOS, deprecated: 9999, renamed: "IssueContext")
@available(tvOS, deprecated: 9999, renamed: "IssueContext")
@available(watchOS, deprecated: 9999, renamed: "IssueContext")
public struct XCTFailContext: Sendable {
  @TaskLocal public static var current: Self?

  public var file: StaticString
  public var line: UInt

  public init(file: StaticString, line: UInt) {
    self.file = file
    self.line = line
  }
}

@available(iOS, deprecated: 9999, renamed: "isTesting")
@available(macOS, deprecated: 9999, renamed: "isTesting")
@available(tvOS, deprecated: 9999, renamed: "isTesting")
@available(watchOS, deprecated: 9999, renamed: "isTesting")
public var _XCTIsTesting: Bool {
  isTesting
}

#if _runtime(_ObjC)
  @_disfavoredOverload
  @available(iOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  @available(macOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  @available(tvOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  @available(watchOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  public func XCTExpectFailure<R>(
    _ failureReason: String? = nil,
    enabled: Bool? = nil,
    strict: Bool? = nil,
    failingBlock: () throws -> R,
    issueMatcher: ((_XCTIssue) -> Bool)? = nil
  ) rethrows -> R {
    guard enabled ?? true
    else { return try failingBlock() }
    guard
      let XCTExpectedFailureOptions = NSClassFromString("XCTExpectedFailureOptions")
        as Any as? any NSObjectProtocol,
      let options = strict ?? true
        ? XCTExpectedFailureOptions
          .perform(NSSelectorFromString("alloc"))?.takeUnretainedValue()
          .perform(NSSelectorFromString("init"))?.takeUnretainedValue()
        : XCTExpectedFailureOptions
          .perform(NSSelectorFromString("nonStrictOptions"))?.takeUnretainedValue(),
      let functionBlockPointer = dlsym(dlopen(nil, RTLD_LAZY), "XCTExpectFailureWithOptionsInBlock")
    else {
      let errorString =
        dlerror().map { charPointer in String(cString: charPointer) }
        ?? "Unknown error"
      assertionFailure(
        "Failed to get symbol for XCTExpectFailureWithOptionsInBlock with error: \(errorString)."
      )
      return try failingBlock()
    }

    if let issueMatcher {
      let issueMatcher: @convention(block) (AnyObject) -> Bool = { issue in
        issueMatcher(_XCTIssue(issue))
      }
      options.setValue(issueMatcher, forKey: "issueMatcher")
    }

    let XCTExpectFailureWithOptionsInBlock = unsafeBitCast(
      functionBlockPointer,
      to: (@convention(c) (String?, AnyObject, () -> Void) -> Void).self
    )

    var result: Result<R, any Error>!
    XCTExpectFailureWithOptionsInBlock(failureReason, options) {
      result = Result { try failingBlock() }
    }
    return try result._rethrowGet()
  }

  @rethrows
  @usableFromInline
  protocol _ErrorMechanism {
    associatedtype Output
    func get() throws -> Output
  }
  extension _ErrorMechanism {
    func _rethrowError() rethrows -> Never {
      _ = try _rethrowGet()
      fatalError()
    }
    @usableFromInline
    func _rethrowGet() rethrows -> Output {
      return try get()
    }
  }
  extension Result: _ErrorMechanism {}

  @_disfavoredOverload
  @available(iOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  @available(macOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  @available(tvOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  @available(watchOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  public func XCTExpectFailure(
    _ failureReason: String? = nil,
    enabled: Bool? = nil,
    strict: Bool? = nil,
    issueMatcher: ((_XCTIssue) -> Bool)? = nil
  ) {
    guard enabled ?? true
    else { return }
    guard
      let XCTExpectedFailureOptions = NSClassFromString("XCTExpectedFailureOptions")
        as Any as? any NSObjectProtocol,
      let options = strict ?? true
        ? XCTExpectedFailureOptions
          .perform(NSSelectorFromString("alloc"))?.takeUnretainedValue()
          .perform(NSSelectorFromString("init"))?.takeUnretainedValue()
        : XCTExpectedFailureOptions
          .perform(NSSelectorFromString("nonStrictOptions"))?.takeUnretainedValue(),
      let functionBlockPointer = dlsym(dlopen(nil, RTLD_LAZY), "XCTExpectFailureWithOptions")
    else {
      let errorString =
        dlerror().map { charPointer in String(cString: charPointer) }
        ?? "Unknown error"
      assertionFailure(
        "Failed to get symbol for XCTExpectFailureWithOptionsInBlock with error: \(errorString)."
      )
      return
    }

    if let issueMatcher {
      let issueMatcher: @convention(block) (AnyObject) -> Bool = { issue in
        issueMatcher(_XCTIssue(issue))
      }
      options.setValue(issueMatcher, forKey: "issueMatcher")
    }

    let XCTExpectFailureWithOptions = unsafeBitCast(
      functionBlockPointer,
      to: (@convention(c) (String?, AnyObject) -> Void).self
    )

    XCTExpectFailureWithOptions(failureReason, options)
  }

  @available(iOS, deprecated: 9999)
  @available(macOS, deprecated: 9999)
  @available(tvOS, deprecated: 9999)
  @available(watchOS, deprecated: 9999)
  public struct _XCTIssue: /*CustomStringConvertible, */ Equatable, Hashable {
    public var type: IssueType
    public var compactDescription: String
    public var detailedDescription: String?

    // NB: This surface are has been left unimplemented for now. We can consider adopting more of it
    //     in the future:
    //
    // var sourceCodeContext: XCTSourceCodeContext
    // var associatedError: Error?
    // var attachments: [XCTAttachment]
    // mutating func add(XCTAttachment)
    //
    // public var description: String {
    //   """
    //   \(self.type.description) \
    //   at \
    //   \(self.sourceCodeContext.location.fileURL.lastPathComponent):\
    //   \(self.sourceCodeContext.location.lineNumber): \
    //   \(self.compactDescription)
    //   """
    // }

    init(_ issue: AnyObject) {
      self.type = IssueType(rawValue: issue.value(forKey: "type") as! Int)!
      self.compactDescription = issue.value(forKey: "compactDescription") as! String
      self.detailedDescription = issue.value(forKey: "detailedDescription") as? String
    }

    public enum IssueType: Int, Sendable {
      case assertionFailure = 0
      case performanceRegression = 3
      case system = 4
      case thrownError = 1
      case uncaughtException = 2
      case unmatchedExpectedFailure = 5

      var description: String {
        switch self {
        case .assertionFailure:
          return "Assertion Failure"
        case .performanceRegression:
          return "Performance Regression"
        case .system:
          return "System Error"
        case .thrownError:
          return "Thrown Error"
        case .uncaughtException:
          return "Uncaught Exception"
        case .unmatchedExpectedFailure:
          return "Unmatched ExpectedFailure"
        }
      }
    }
  }
#endif

@_spi(CurrentTestCase)
@available(iOS, deprecated: 9999)
@available(macOS, deprecated: 9999)
@available(tvOS, deprecated: 9999)
@available(watchOS, deprecated: 9999)
public var XCTCurrentTestCase: AnyObject? {
  #if _runtime(_ObjC)
    guard
      let XCTestObservationCenter = NSClassFromString("XCTestObservationCenter"),
      let XCTestObservationCenter = XCTestObservationCenter as Any as? any NSObjectProtocol,
      let shared = XCTestObservationCenter.perform(Selector(("sharedTestObservationCenter")))?
        .takeUnretainedValue(),
      let observers = shared.perform(Selector(("observers")))?
        .takeUnretainedValue() as? [AnyObject],
      let observer =
        observers
        .first(where: { NSStringFromClass(type(of: $0)) == "XCTestMisuseObserver" }),
      let currentTestCase = observer.perform(Selector(("currentTestCase")))?
        .takeUnretainedValue()
    else { return nil }
    return currentTestCase
  #else
    return nil
  #endif
}

@_disfavoredOverload
@available(*, unavailable, renamed: "unimplemented(_:placeholder:)")
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file filePath: StaticString = #filePath,
  fileID: StaticString = #fileID,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) -> Result {
  fatalError()
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented(_:placeholder:)")
public func unimplemented<each Argument, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file filePath: StaticString = #filePath,
  fileID: StaticString = #fileID,
  function: StaticString = #function,
  line: UInt = #line
) -> @Sendable (repeat each Argument) -> Result {
  return { (argument: repeat each Argument) in
    let description = description()
    _fail(
      description,
      (repeat each argument),
      fileID: fileID,
      filePath: filePath,
      function: function,
      line: line,
      column: 0
    )
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: filePath, line: line)
    }
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented(_:placeholder:)")
public func unimplemented<each Argument, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file filePath: StaticString = #filePath,
  fileID: StaticString = #fileID,
  function: StaticString = #function,
  line: UInt = #line
) -> _UnimplementedAsyncClosure<repeat each Argument, Result> {
  return { (argument: repeat each Argument) in
    let description = description()
    _fail(
      description,
      (repeat each argument),
      fileID: fileID,
      filePath: filePath,
      function: function,
      line: line,
      column: 0
    )
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: filePath, line: line)
    }
  }
}

@available(*, deprecated)
private func _unimplementedFatalError(_ message: String, file: StaticString, line: UInt) -> Never {
  fatalError(
    """
    unimplemented(\(message.isEmpty ? "" : message.debugDescription))

    To suppress this crash, provide an explicit "placeholder".
    """,
    file: file,
    line: line
  )
}

@available(*, deprecated)
extension _DefaultInitializable { fileprivate static var placeholder: Self { Self() } }
extension AdditiveArithmetic { fileprivate static var placeholder: Self { .zero } }
extension ExpressibleByArrayLiteral { fileprivate static var placeholder: Self { [] } }
extension ExpressibleByBooleanLiteral { fileprivate static var placeholder: Self { false } }
extension ExpressibleByDictionaryLiteral { fileprivate static var placeholder: Self { [:] } }
extension ExpressibleByFloatLiteral { fileprivate static var placeholder: Self { 0.0 } }
extension ExpressibleByIntegerLiteral { fileprivate static var placeholder: Self { 0 } }
extension ExpressibleByUnicodeScalarLiteral { fileprivate static var placeholder: Self { " " } }
extension RangeReplaceableCollection { fileprivate static var placeholder: Self { Self() } }

@available(*, deprecated)
private protocol _OptionalProtocol { static var none: Self { get } }
@available(*, deprecated)
extension Optional: _OptionalProtocol {}
@available(*, deprecated)
private func _optionalPlaceholder<Result>() throws -> Result {
  if let result = (Result.self as? any _OptionalProtocol.Type) {
    return result.none as! Result
  }
  throw PlaceholderGenerationFailure()
}

@available(*, deprecated)
private func _placeholder<Result>() -> Result? {
  switch Result.self {
  case let type as any _DefaultInitializable.Type: return type.placeholder as? Result
  case is Void.Type: return () as? Result
  case let type as any RangeReplaceableCollection.Type: return type.placeholder as? Result
  case let type as any AdditiveArithmetic.Type: return type.placeholder as? Result
  case let type as any ExpressibleByArrayLiteral.Type: return type.placeholder as? Result
  case let type as any ExpressibleByBooleanLiteral.Type: return type.placeholder as? Result
  case let type as any ExpressibleByDictionaryLiteral.Type: return type.placeholder as? Result
  case let type as any ExpressibleByFloatLiteral.Type: return type.placeholder as? Result
  case let type as any ExpressibleByIntegerLiteral.Type: return type.placeholder as? Result
  case let type as any ExpressibleByUnicodeScalarLiteral.Type: return type.placeholder as? Result
  default: return nil
  }
}

@available(*, deprecated)
private func _rawRepresentable<Result>() -> Result? {
  func posiblePlaceholder<T: RawRepresentable>(for type: T.Type) -> T? {
    (_placeholder() as T.RawValue?).flatMap(T.init(rawValue:))
  }

  return (Result.self as? any RawRepresentable.Type).flatMap {
    posiblePlaceholder(for: $0) as? Result
  }
}

@available(*, deprecated)
private func _caseIterable<Result>() -> Result? {
  func firstCase<T: CaseIterable>(for type: T.Type) -> Result? {
    T.allCases.first as? Result
  }

  return (Result.self as? any CaseIterable.Type).flatMap {
    firstCase(for: $0)
  }
}

@available(*, deprecated)
struct PlaceholderGenerationFailure: Error {}
@available(*, deprecated)
func _generatePlaceholder<Result>() throws -> Result {
  if let result = _placeholder() as Result? {
    return result
  }

  if let result = _rawRepresentable() as Result? {
    return result
  }

  if let result = _caseIterable() as Result? {
    return result
  }

  return try _optionalPlaceholder()
}

@available(*, deprecated)
private protocol _DefaultInitializable {
  init()
}

@available(*, deprecated) extension Array: _DefaultInitializable {}
@available(*, deprecated) extension Bool: _DefaultInitializable {}
@available(*, deprecated) extension Character: _DefaultInitializable { init() { self.init(" ") } }
@available(*, deprecated) extension Dictionary: _DefaultInitializable {}
@available(*, deprecated) extension Double: _DefaultInitializable {}
@available(*, deprecated) extension Float: _DefaultInitializable {}
@available(*, deprecated) extension Int: _DefaultInitializable {}
@available(*, deprecated) extension Int8: _DefaultInitializable {}
@available(*, deprecated) extension Int16: _DefaultInitializable {}
@available(*, deprecated) extension Int32: _DefaultInitializable {}
@available(*, deprecated) extension Int64: _DefaultInitializable {}
@available(*, deprecated) extension Set: _DefaultInitializable {}
@available(*, deprecated) extension String: _DefaultInitializable {}
@available(*, deprecated) extension Substring: _DefaultInitializable {}
@available(*, deprecated) extension UInt: _DefaultInitializable {}
@available(*, deprecated) extension UInt8: _DefaultInitializable {}
@available(*, deprecated) extension UInt16: _DefaultInitializable {}
@available(*, deprecated) extension UInt32: _DefaultInitializable {}
@available(*, deprecated) extension UInt64: _DefaultInitializable {}

@available(*, deprecated)
extension AsyncStream: _DefaultInitializable {
  init() { self.init { $0.finish() } }
}

@available(*, deprecated)
extension AsyncThrowingStream: _DefaultInitializable where Failure == any Error {
  init() { self.init { $0.finish(throwing: CancellationError()) } }
}

#if canImport(Foundation)
  @available(*, deprecated) extension Data: _DefaultInitializable {}
  @available(*, deprecated) extension Date: _DefaultInitializable {}
  @available(*, deprecated) extension Decimal: _DefaultInitializable {}
  @available(*, deprecated) extension UUID: _DefaultInitializable {}
  @available(*, deprecated) extension URL: _DefaultInitializable {
    init() { self.init(string: "/")! }
  }
#endif

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<each Argument, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) -> @Sendable (repeat each Argument) -> Result {
  unimplemented(
    description(),
    placeholder: placeholder(),
    fileID: fileID,
    filePath: filePath,
    function: function,
    line: line,
    column: column
  )
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<each Argument, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line
) -> @Sendable (repeat each Argument) -> Result {
  unimplemented(
    description(),
    file: filePath,
    fileID: fileID,
    function: function,
    line: line
  )
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<each Argument, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) -> @Sendable (repeat each Argument) throws -> Result {
  unimplemented(
    description(),
    fileID: fileID,
    filePath: filePath,
    function: function,
    line: line,
    column: column
  )
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<each Argument, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line
) -> _UnimplementedAsyncClosure<repeat each Argument, Result> {
  unimplemented(
    description(),
    file: filePath,
    fileID: fileID,
    function: function,
    line: line
  )
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<each Argument, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line
) -> _UnimplementedAsyncClosure<repeat each Argument, Result> {
  unimplemented(
    description(),
    file: filePath,
    fileID: fileID,
    function: function,
    line: line
  )
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<each Argument, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> _UnimplementedAsyncThrowingClosure<repeat each Argument, Result> {
  unimplemented(description())
}

@available(*, deprecated, renamed: "UnimplementedFailure")
public typealias XCTUnimplementedFailure = UnimplementedFailure

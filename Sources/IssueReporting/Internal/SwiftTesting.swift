import Foundation

#if canImport(Android)
  import Android
#endif

#if canImport(WinSDK)
  import WinSDK
#endif

// NB: We can drop this when we bump to swift-tools-version 6.2
#if hasFeature(NonisolatedNonsendingByDefault)
  public typealias _AsyncThrowingBody = @concurrent () async throws -> Void
#else
  public typealias _AsyncThrowingBody = () async throws -> Void
#endif

@usableFromInline
func _recordIssue(
  message: String?,
  severity: IssueSeverity = .error,
  fileID: String = #fileID,
  filePath: String = #filePath,
  line: Int = #line,
  column: Int = #column
) {
  guard let function = function(for: "$s25IssueReportingTestSupport07_recordA0ypyF")
  else {
    #if DEBUG && canImport(Darwin)
      #if compiler(>=6.2)
        guard
          let record = unsafeBitCast(
            symbol: """
              $s7Testing5IssueV6record_8severity14sourceLocationAcA7CommentVSg_AC8SeverityOAA06Sour\
              ceF0VtFZ
              """,
            in: "Testing",
            to: (@convention(thin) (Any?, Any, SourceLocation) -> Issue).self
          )
        else { return }

        var comment: Any?
        if let message {
          comment = Comment(rawValue: message)
        }
        let issueSeverity: Any
        switch severity {
        #if compiler(>=6.2)
          case .warning:
            issueSeverity = Issue.Severity.warning
        #endif
        case .error:
          issueSeverity = Issue.Severity.error
        }
        _ = record(
          comment,
          issueSeverity,
          SourceLocation(fileID: fileID, _filePath: filePath, line: line, column: column)
        )
      #else
        guard
          let record = unsafeBitCast(
            symbol: "$s7Testing5IssueV6record_14sourceLocationAcA7CommentVSg_AA06SourceE0VtFZ",
            in: "Testing",
            to: (@convention(thin) (Any?, SourceLocation) -> Issue).self
          )
        else { return }

        var comment: Any?
        if let message {
          comment = Comment(rawValue: message)
        }
        _ = record(
          comment,
          SourceLocation(fileID: fileID, _filePath: filePath, line: line, column: column)
        )
      #endif
    #else
      printError(
        """
        \(fileID):\(line): An issue was recorded without linking the Testing framework.

        To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
        """
      )
    #endif
    return
  }

  if let recordIssue = function as? @Sendable (String?, Int, String, String, Int, Int) -> Void {
    recordIssue(message, severity.rawValue, fileID, filePath, line, column)
    return
  }
  let recordIssue = function as! @Sendable (String?, String, String, Int, Int) -> Void
  recordIssue(message, fileID, filePath, line, column)
}

@usableFromInline
func _recordError(
  error: any Error,
  message: String?,
  fileID: String = #fileID,
  filePath: String = #filePath,
  line: Int = #line,
  column: Int = #column
) {
  guard let function = function(for: "$s25IssueReportingTestSupport12_recordErrorypyF")
  else {
    #if DEBUG && canImport(Darwin)
      var comment: Any?
      if let message {
        comment = Comment(rawValue: message)
      }
      let sourceLocation = SourceLocation(
        fileID: fileID,
        _filePath: filePath,
        line: line,
        column: column
      )

      #if compiler(>=6.2)
        if let record = unsafeBitCast(
          symbol: """
            $s7Testing5IssueV6record__8severity14sourceLocationACs5Error_p_AA7CommentVSgAC8Severi\
            tyOAA06SourceF0VtFZ
            """,
          in: "Testing",
          to: (@convention(thin) (any Error, Any?, Any, SourceLocation) -> Issue).self
        ) {
          _ = record(
            error,
            comment,
            Issue.Severity.error,
            sourceLocation
          )
          return
        }
      #endif

      guard
        let record = unsafeBitCast(
          symbol: """
            $s7Testing5IssueV6record__14sourceLocationACs5Error_p_AA7CommentVSgAA06SourceE0VtFZ
            """,
          in: "Testing",
          to: (@convention(thin) (any Error, Any?, SourceLocation) -> Issue).self
        )
      else { return }

      _ = record(error, comment, sourceLocation)
    #else
      printError(
        """
        \(fileID):\(line): An issue was recorded without linking the Testing framework.

        To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
        """
      )
    #endif
    return
  }

  let recordError = function as! @Sendable (any Error, String?, String, String, Int, Int) -> Void
  recordError(error, message, fileID, filePath, line, column)
}

@usableFromInline
func _withKnownIssue(
  _ message: String? = nil,
  isIntermittent: Bool = false,
  fileID: String = #fileID,
  filePath: String = #filePath,
  line: Int = #line,
  column: Int = #column,
  _ body: () throws -> Void
) {
  guard let function = function(for: "$s25IssueReportingTestSupport010_withKnownA0ypyF")
  else {
    #if DEBUG && canImport(Darwin)
      var comment: Any?
      if let message {
        comment = Comment(rawValue: message)
      }
      let sourceLocation = SourceLocation(
        fileID: fileID,
        _filePath: filePath,
        line: line,
        column: column
      )

      if let withKnownIssue = unsafeBitCast(
        symbol: """
          $s7Testing14withKnownIssue_14isIntermittent14sourceLocation_yAA7CommentVSg_SbAA06Source\
          H0VyyKXEtF
          """,
        in: "Testing",
        to: (@convention(thin) (
          Any?,
          Bool,
          SourceLocation,
          () throws -> Void
        ) -> Void)
        .self
      ) {
        withKnownIssue(comment, isIntermittent, sourceLocation, body)
        return
      }

    #else
      printError(
        """
        \(fileID):\(line): A known issue was recorded without linking the Testing framework.

        To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
        """
      )
      try? body()
    #endif
    return
  }

  let withKnownIssue =
    function
    as! @Sendable (
      String?,
      Bool,
      String,
      String,
      Int,
      Int,
      () throws -> Void
    ) -> Void
  withKnownIssue(message, isIntermittent, fileID, filePath, line, column, body)
}

#if compiler(>=6.0.2)
  @usableFromInline
  func _withKnownIssue(
    _ message: String?,
    isIntermittent: Bool,
    isolation: isolated (any Actor)?,
    fileID: String,
    filePath: String,
    line: Int,
    column: Int,
    _ body: _AsyncThrowingBody
  ) async {
    guard
      let function = function(for: "$s25IssueReportingTestSupport010_withKnownA13AsyncIsolatedypyF")
    else {
      #if DEBUG && canImport(Darwin)
        var comment: Any?
        if let message {
          comment = Comment(rawValue: message)
        }
        let sourceLocation = SourceLocation(
          fileID: fileID,
          _filePath: filePath,
          line: line,
          column: column
        )
        guard
          let withKnownIssue = unsafeBitCast(
            symbol: """
              $s7Testing14withKnownIssue_14isIntermittent9isolation14sourceLocation_yAA7CommentVSg_\
              SbScA_pSgYiAA06SourceI0VyyYaKXEtYaFTu
              """,
            in: "Testing",
            to: (@convention(thin) (
              Any?,
              Bool,
              isolated (any Actor)?,
              SourceLocation,
              _AsyncThrowingBody
            ) async -> Void)
            .self
          )
        else { return }
        await withKnownIssue(comment, isIntermittent, isolation, sourceLocation, body)
      #else
        printError(
          """
          \(fileID):\(line): A known issue was recorded without linking the Testing framework.

          To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
          """
        )
        try? await body()
      #endif
      return
    }

    let withKnownIssue =
      function
      as! @Sendable (
        String?,
        Bool,
        isolated (any Actor)?,
        String,
        String,
        Int,
        Int,
        () async throws -> Void
      ) async -> Void
    await withKnownIssue(message, isIntermittent, isolation, fileID, filePath, line, column, body)
  }
#else
  @usableFromInline
  func _withKnownIssue(
    _ message: String?,
    isIntermittent: Bool,
    fileID: String,
    filePath: String,
    line: Int,
    column: Int,
    _ body: () async throws -> Void
  ) async {
    guard let function = function(for: "$s25IssueReportingTestSupport010_withKnownA5AsyncypyF")
    else {
      #if DEBUG && canImport(Darwin)
        var comment: Any?
        if let message {
          comment = Comment(rawValue: message)
        }
        let sourceLocation = SourceLocation(
          fileID: fileID,
          _filePath: filePath,
          line: line,
          column: column
        )

        guard
          let withKnownIssue = unsafeBitCast(
            symbol: """
              $s7Testing14withKnownIssue_14isIntermittent14sourceLocation_yAA7CommentVSg_SbAA06Sour\
              ceH0VyyYaKXEtYaFTu
              """,
            in: "Testing",
            to: (@convention(thin) (
              Any?,
              Bool,
              SourceLocation,
              () async throws -> Void
            ) async -> Void)
            .self
          )
        else { return }
        await withKnownIssue(comment, isIntermittent, sourceLocation, body)
      #else
        printError(
          """
          \(fileID):\(line): A known issue was recorded without linking the Testing framework.

          To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
          """
        )
      #endif
      return
    }

    let withKnownIssue =
      function
      as! @Sendable (
        String?,
        Bool,
        String,
        String,
        Int,
        Int,
        () async throws -> Void
      ) async -> Void
    await withKnownIssue(message, isIntermittent, fileID, filePath, line, column, body)
  }

#endif

@usableFromInline
func _currentTest() -> _Test? {
  guard let function = function(for: "$s25IssueReportingTestSupport08_currentC0ypyF")
  else {
    #if DEBUG
      return Test.current.map { _Test(id: $0.id, traits: $0.traits) }
    #else
      return nil
    #endif
  }

  return withUnsafePointer(to: function) {
    $0.withMemoryRebound(to: (@Sendable () -> _Test?).self, capacity: 1) {
      $0.pointee()
    }
  }
}

#if DEBUG
  #if _runtime(_ObjC)
    import ObjectiveC

    private typealias __XCTestCompatibleSelector = Selector
  #else
    private typealias __XCTestCompatibleSelector = Never
  #endif

  private struct __Expression: Sendable {
    enum Kind: Sendable {
      case generic(_ sourceCode: String)
      case stringLiteral(sourceCode: String, stringValue: String)
      indirect case binaryOperation(lhs: __Expression, `operator`: String, rhs: __Expression)
      struct FunctionCallArgument: Sendable {
        var label: String?
        var value: __Expression
      }
      indirect case functionCall(
        value: __Expression?,
        functionName: String,
        arguments: [FunctionCallArgument]
      )
      indirect case propertyAccess(value: __Expression, keyPath: __Expression)
      indirect case negation(_ expression: __Expression, isParenthetical: Bool)
    }
    var kind: Kind
    struct Value: Sendable {
      var description: String
      var debugDescription: String
      var typeInfo: TypeInfo
      var label: String?
      var isCollection: Bool
      var children: [Self]?
    }
    var runtimeValue: Value?
  }

  private struct Backtrace: Sendable {
    typealias Address = UInt64
    var addresses: [Address]
  }

  private struct Comment: RawRepresentable, Sendable {
    var rawValue: String
    init(rawValue: String) {
      self.rawValue = rawValue
      self.kind = nil
    }
    enum Kind: Sendable {
      case line
      case block
      case documentationLine
      case documentationBlock
      case trait
      case stringLiteral
    }
    var kind: Kind?
  }

  private struct Confirmation: Sendable {
  }
  private protocol ExpectedCount: Sendable, RangeExpression<Int> {}

  private struct Expectation: Sendable {
    var evaluatedExpression: __Expression
    var mismatchedErrorDescription: String?
    var differenceDescription: String?
    var mismatchedExitConditionDescription: String?
    var isPassing: Bool
    var isRequired: Bool
    var sourceLocation: SourceLocation
  }

  private struct Issue: Sendable {
    enum Kind: Sendable {
      case unconditional
      indirect case expectationFailed(_ expectation: Expectation)
      #if compiler(>=6.2)
        indirect case confirmationMiscounted(actual: Int, expected: any RangeExpression & Sendable)
      #else
        indirect case confirmationMiscounted(actual: Int, expected: Int)
        indirect case confirmationOutOfRange(actual: Int, expected: any ExpectedCount)
      #endif
      indirect case errorCaught(_ error: any Error)
      indirect case timeLimitExceeded(timeLimitComponents: (seconds: Int64, attoseconds: Int64))
      case knownIssueNotRecorded
      case apiMisused
      case system
    }
    var kind: Kind
    #if compiler(>=6.2)
      enum Severity: Sendable {
        case warning
        case error
      }
      var severity: Severity
    #endif
    var comments: [Comment]
    var sourceContext: SourceContext
    #if compiler(>=6.2)
      struct KnownIssueContext: Sendable {
        public var comment: Comment?
      }
      var knownIssueContext: KnownIssueContext? = nil
    #endif
  }

  private struct SourceContext: Sendable {
    var backtrace: Backtrace?
    var sourceLocation: SourceLocation?
  }

  private struct SourceLocation: Hashable, Sendable {
    var fileID: String
    var _filePath: String
    var line: Int
    var column: Int
    var moduleName: String {
      let firstSlash = fileID.firstIndex(of: "/")!
      return String(fileID[..<firstSlash])
    }
  }

  struct Test: @unchecked Sendable {
    static var current: Self? {
      guard
        let current = unsafeBitCast(
          symbol: "$s7Testing4TestV7currentACSgvgZ",
          in: "Testing",
          to: (@convention(thin) () -> Test?).self
        )
      else { return nil }
      return current()
    }

    struct Case {}
    fileprivate enum TestCasesState: @unchecked Sendable {
      #if compiler(>=6.3)
        case unevaluated(
          _ function: @Sendable () async throws -> any Sequence<Test.Case> & Sendable
        )
        case evaluated(_ testCases: any Sequence<Test.Case> & Sendable)
      #else
        case unevaluated(_ function: @Sendable () async throws -> AnySequence<Test.Case>)
        case evaluated(_ testCases: AnySequence<Test.Case>)
      #endif
      case failed(_ error: any Error)
    }
    private struct Parameter: Sendable {
      var index: Int
      var firstName: String
      var secondName: String?
      var typeInfo: TypeInfo
    }

    #if compiler(>=6.4)
      private struct SourceBounds: Sendable {
        var lowerBound: SourceLocation
        var _upperBound: (line: Int, column: Int)
      }
      private struct _Properties {
        var name: String
        var displayName: String?
        var traits: [any Trait]
        var sourceBounds: SourceBounds
        var containingTypeInfo: TypeInfo?
        var xcTestCompatibleSelector: __XCTestCompatibleSelector?
        var testCasesState: TestCasesState?
        var parameters: [Parameter]?
        var isSynthesized: Bool
      }
      private final class Allocated: @unchecked Sendable {
        let value: _Properties
        init(_ value: _Properties) { self.value = value }
      }
      private var _properties: Allocated
      private var _padding: (UInt, UInt, UInt, UInt, UInt, UInt, UInt, UInt)

      private var name: String { _properties.value.name }
      fileprivate var traits: [any Trait] { _properties.value.traits }
      private var sourceLocation: SourceLocation { _properties.value.sourceBounds.lowerBound }
      private var containingTypeInfo: TypeInfo? { _properties.value.containingTypeInfo }
      fileprivate var testCasesState: TestCasesState? { _properties.value.testCasesState }
    #else
      private var name: String
      private var displayName: String?
      fileprivate var traits: [any Trait]
      private var sourceLocation: SourceLocation
      private var containingTypeInfo: TypeInfo?
      private var xcTestCompatibleSelector: __XCTestCompatibleSelector?
      fileprivate var testCasesState: TestCasesState?
      private var parameters: [Parameter]?
      private var isSynthesized = false
    #endif

    private var isSuite: Bool {
      containingTypeInfo != nil && testCasesState == nil
    }
    fileprivate var id: ID {
      var result =
        containingTypeInfo.map(ID.init)
        ?? ID(moduleName: sourceLocation.moduleName, nameComponents: [], sourceLocation: nil)

      if !isSuite {
        result.nameComponents.append(name)
        result.sourceLocation = sourceLocation
      }

      return result
    }
    fileprivate struct ID: Hashable {
      var moduleName: String
      var nameComponents: [String]
      var sourceLocation: SourceLocation?
      init(moduleName: String, nameComponents: [String], sourceLocation: SourceLocation?) {
        self.moduleName = moduleName
        self.nameComponents = nameComponents
        self.sourceLocation = sourceLocation
      }
      init(_ fullyQualifiedNameComponents: some Collection<String>) {
        moduleName = fullyQualifiedNameComponents.first ?? ""
        if fullyQualifiedNameComponents.count > 0 {
          nameComponents = Array(fullyQualifiedNameComponents.dropFirst())
        } else {
          nameComponents = []
        }
      }
      init(typeInfo: TypeInfo) {
        self.init(typeInfo.fullyQualifiedNameComponents)
      }
    }
  }

  private protocol Trait: Sendable {}

  private struct TypeInfo: Sendable {
    enum _Kind: Sendable {
      case type(_ type: Any.Type)
      case nameOnly(fullyQualifiedComponents: [String], unqualified: String, mangled: String?)
    }
    var _kind: _Kind

    static let _fullyQualifiedNameComponentsCache:
      LockIsolated<
        [ObjectIdentifier: [String]]
      > = LockIsolated([:])
    var fullyQualifiedNameComponents: [String] {
      switch _kind {
      case .type(let type):
        if let cachedResult = Self
          ._fullyQualifiedNameComponentsCache.withLock({ $0[ObjectIdentifier(type)] })
        {
          return cachedResult
        }
        var result = String(reflecting: type)
          .split(separator: ".")
          .map(String.init)
        if let firstComponent = result.first, firstComponent.starts(with: "(extension in ") {
          result[0] = String(firstComponent.split(separator: ":", maxSplits: 1).last!)
        }
        result = result.filter { !$0.starts(with: "(unknown context at") }
        Self._fullyQualifiedNameComponentsCache.withLock { [result] in
          $0[ObjectIdentifier(type)] = result
        }
        return result

      case .nameOnly(let fullyQualifiedComponents, _, _):
        return fullyQualifiedComponents
      }
    }
  }
#endif

@usableFromInline
func function(for symbol: String) -> Any? {
  let function = unsafeBitCast(
    symbol: symbol,
    in: "IssueReportingTestSupport",
    to: (@convention(thin) () -> Any).self
  )
  return function?()
}

@usableFromInline
func unsafeBitCast<F>(symbol: String, in library: String, to function: F.Type) -> F? {
  #if os(Linux) || os(Android)
    guard
      let handle = dlopen("lib\(library).so", RTLD_LAZY) ?? dlopen(nil, RTLD_LAZY),
      let pointer = dlsym(handle, symbol)
    else { return nil }
    return unsafeBitCast(pointer, to: F.self)
  #elseif canImport(Darwin)
    guard
      let handle = dlopen(nil, RTLD_LAZY),
      let pointer = dlsym(handle, symbol)
    else { return nil }
    return unsafeBitCast(pointer, to: F.self)
  #elseif os(Windows)
    guard
      let handle = LoadLibraryA("\(library).dll"),
      let pointer = GetProcAddress(handle, symbol)
    else { return nil }
    return unsafeBitCast(pointer, to: F.self)
  #else
    return nil
  #endif
}

extension IssueSeverity {
  fileprivate var rawValue: Int {
    switch self {
    case .warning: return 0
    case .error: return 1
    }
  }
}

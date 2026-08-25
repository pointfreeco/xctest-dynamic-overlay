// NB: We can drop this when we bump to swift-tools-version 6.2
#if hasFeature(NonisolatedNonsendingByDefault)
  public typealias _UnimplementedAsyncClosure<each Argument, Result> =
    @concurrent @Sendable (repeat each Argument) async -> sending Result
  public typealias _UnimplementedAsyncThrowingClosure<each Argument, Result> =
    @concurrent @Sendable (repeat each Argument) async throws -> sending Result
#else
  public typealias _UnimplementedAsyncClosure<each Argument, Result> =
    @Sendable (repeat each Argument) async -> sending Result
  public typealias _UnimplementedAsyncThrowingClosure<each Argument, Result> =
    @Sendable (repeat each Argument) async throws -> sending Result
#endif

#if hasFeature(NonisolatedNonsendingByDefault)
  public typealias _UnimplementedAsyncTypedThrowingClosure<
    each Argument,
    Failure: Error,
    Result
  > =
    @concurrent @Sendable (repeat each Argument) async throws(Failure) -> sending Result
#else
  public typealias _UnimplementedAsyncTypedThrowingClosure<
    each Argument,
    Failure: Error,
    Result
  > =
    @Sendable (repeat each Argument) async throws(Failure) -> sending Result
#endif

/// Returns a closure that reports an issue when invoked.
///
/// Useful for creating closures that need to be overridden by users of your API, and if it is
/// ever invoked without being overridden an issue will be reported. See
/// <doc:GettingStarted#Unimplemented-closures> for more information.
///
/// - Parameters:
///   - description: An optional description of the unimplemented closure.
///   - placeholder: A placeholder value returned from the closure when left unimplemented.
///   - fileID: The fileID.
///   - filePath: The filePath.
///   - function: The function.
///   - line: The line.
///   - column: The column.
/// - Returns: A closure that reports an issue when invoked.
public func unimplemented<each Argument, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> sending Result = (),
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) -> @Sendable (repeat each Argument) -> sending Result {
  return { (argument: repeat each Argument) in
    _fail(
      description(),
      (repeat each argument),
      fileID: fileID,
      filePath: filePath,
      function: function,
      line: line,
      column: column
    )
    return placeholder()
  }
}

/// Returns a throwing closure that reports an issue and throws an error when invoked.
///
/// Useful for creating closures that need to be overridden by users of your API, and if it is
/// ever invoked without being overridden an issue will be reported. See
/// <doc:GettingStarted#Unimplemented-closures> for more information.
///
/// - Parameters:
///   - description: An optional description of the unimplemented closure.
///   - fileID: The fileID.
///   - filePath: The filePath.
///   - function: The function.
///   - line: The line.
///   - column: The column.
/// - Returns: A throwing closure that reports an issue and throws an error when invoked.
public func unimplemented<each Argument, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) -> @Sendable (repeat each Argument) throws -> sending Result {
  return { (argument: repeat each Argument) in
    let description = description()
    _fail(
      description,
      (repeat each argument),
      fileID: fileID,
      filePath: filePath,
      function: function,
      line: line,
      column: column
    )
    throw UnimplementedFailure(description: description)
  }
}

/// Returns a throwing closure that reports an issue and throws a given error when invoked.
///
/// Useful for creating closures that need to be overridden by users of your API, and if it is
/// ever invoked without being overridden an issue will be reported. See
/// <doc:GettingStarted#Unimplemented-closures> for more information.
///
/// - Parameters:
///   - description: An optional description of the unimplemented closure.
///   - failure: The error thrown by the unimplemented closure.
///   - fileID: The fileID.
///   - filePath: The filePath.
///   - function: The function.
///   - line: The line.
///   - column: The column.
/// - Returns: A throwing closure that reports an issue and throws an error when invoked.
public func unimplemented<each Argument, Failure: Error, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  throwing failure: @autoclosure @escaping @Sendable () -> Failure,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) -> @Sendable (repeat each Argument) throws(Failure) -> sending Result {
  return { (argument: repeat each Argument) throws(Failure) in
    let description = description()
    _fail(
      description,
      (repeat each argument),
      fileID: fileID,
      filePath: filePath,
      function: function,
      line: line,
      column: column
    )
    throw failure()
  }
}

/// Returns an asynchronous closure that reports an issue when invoked.
///
/// Useful for creating closures that need to be overridden by users of your API, and if it is
/// ever invoked without being overridden an issue will be reported. See
/// <doc:GettingStarted#Unimplemented-closures> for more information.
///
/// - Parameters:
///   - description: An optional description of the unimplemented closure.
///   - placeholder: A placeholder value returned from the closure when left unimplemented.
///   - fileID: The fileID.
///   - filePath: The filePath.
///   - function: The function.
///   - line: The line.
///   - column: The column.
/// - Returns: An asynchronous closure that reports an issue when invoked.
public func unimplemented<each Argument, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> sending Result = (),
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) -> _UnimplementedAsyncClosure<repeat each Argument, Result> {
  return { (argument: repeat each Argument) in
    _fail(
      description(),
      (repeat each argument),
      fileID: fileID,
      filePath: filePath,
      function: function,
      line: line,
      column: column
    )
    return placeholder()
  }
}

/// Returns a throwing, asynchronous closure that reports an issue and throws an error when invoked.
///
/// Useful for creating closures that need to be overridden by users of your API, and if it is
/// ever invoked without being overridden an issue will be reported. See
/// <doc:GettingStarted#Unimplemented-closures> for more information.
///
/// - Parameters:
///   - description: An optional description of the unimplemented closure.
///   - fileID: The fileID.
///   - filePath: The filePath.
///   - function: The function.
///   - line: The line.
///   - column: The column.
/// - Returns: A throwing, asynchronous closure that reports an issue and throws an error when
///   invoked.
public func unimplemented<each Argument, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) -> _UnimplementedAsyncThrowingClosure<repeat each Argument, Result> {
  return { (argument: repeat each Argument) in
    let description = description()
    _fail(
      description,
      (repeat each argument),
      fileID: fileID,
      filePath: filePath,
      function: function,
      line: line,
      column: column
    )
    throw UnimplementedFailure(description: description)
  }
}

/// Returns a throwing, asynchronous closure that reports an issue and throws a given error when
/// invoked.
///
/// Useful for creating closures that need to be overridden by users of your API, and if it is
/// ever invoked without being overridden an issue will be reported. See
/// <doc:GettingStarted#Unimplemented-closures> for more information.
///
/// - Parameters:
///   - description: An optional description of the unimplemented closure.
///   - failure: The error thrown by the unimplemented closure.
///   - fileID: The fileID.
///   - filePath: The filePath.
///   - function: The function.
///   - line: The line.
///   - column: The column.
/// - Returns: A throwing, asynchronous closure that reports an issue and throws an error when
///   invoked.
public func unimplemented<each Argument, Failure: Error, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  throwing failure: @autoclosure @escaping @Sendable () -> Failure,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) -> _UnimplementedAsyncTypedThrowingClosure<repeat each Argument, Failure, Result> {
  return { (argument: repeat each Argument) async throws(Failure) in
    let description = description()
    _fail(
      description,
      (repeat each argument),
      fileID: fileID,
      filePath: filePath,
      function: function,
      line: line,
      column: column
    )
    throw failure()
  }
}

@_disfavoredOverload
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> sending Result = (),
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) -> Result {
  _fail(
    description(),
    nil,
    fileID: fileID,
    filePath: filePath,
    function: function,
    line: line,
    column: column
  )
  return placeholder()
}

/// An error thrown from throwing `unimplemented` closures.
public struct UnimplementedFailure: Error {
  public let description: String

  public init(description: String) {
    self.description = description
  }
}

package func _fail(
  _ description: String,
  _ parameters: Any?,
  fileID: StaticString,
  filePath: StaticString,
  function: StaticString,
  line: UInt,
  column: UInt
) {
  var debugDescription = """
     …

      Defined in '\(function)' at:
        \(fileID):\(line)
    """
  if let parameters {
    var parametersDescription = ""
    debugPrint(parameters, terminator: "", to: &parametersDescription)
    debugDescription.append(
      """


        Invoked with:
          \(parametersDescription)
      """
    )
  }
  reportIssue(
    """
    Unimplemented\(description.isEmpty ? "" : ": \(description)")\(debugDescription)
    """,
    fileID: fileID,
    filePath: filePath,
    line: line,
    column: column
  )
}

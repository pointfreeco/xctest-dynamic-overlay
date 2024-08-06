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
  placeholder: @autoclosure @escaping @Sendable () -> Result = (),
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) -> @Sendable (repeat each Argument) -> Result {
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
) -> @Sendable (repeat each Argument) throws -> Result {
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
  placeholder: @autoclosure @escaping @Sendable () -> Result = (),
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) -> @Sendable (repeat each Argument) async -> Result {
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
) -> @Sendable (repeat each Argument) async throws -> Result {
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

@_disfavoredOverload
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result = (),
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

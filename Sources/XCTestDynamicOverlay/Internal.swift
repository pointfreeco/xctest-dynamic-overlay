import IssueReporting

// NB: Vendored from 'swift-issue-reporting', where this helper has 'package' access and so is not
//     visible to this package's deprecated 'unimplemented' overloads.
func _fail(
  _ description: String,
  _ parameters: Any?,
  fileID: StaticString,
  filePath: StaticString,
  function: StaticString,
  line: UInt,
  column: UInt
) {
  var debugDescription = """
     ...

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

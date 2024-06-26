import Foundation

#if DEBUG && canImport(os)
  import os
#endif

extension IssueReporter where Self == RuntimeWarningReporter {
  /// An issue reporter that emits "purple" runtime warnings to Xcode and logs fault-level messages
  /// to the console.
  ///
  /// This is the default issue reporter.
  ///
  /// If this issue reporter receives an expected issue, it will log an info-level message to the
  /// console, instead.
  public static var runtimeWarning: Self { Self() }
}

/// A type representing an issue reporter that emits "purple" runtime warnings to Xcode and logs
/// fault-level messages to the console.
///
/// Use ``IssueReporter/runtimeWarning`` to create one of these values.
public struct RuntimeWarningReporter: IssueReporter {
  #if DEBUG && canImport(os)
    @UncheckedSendable
    @usableFromInline var dso: UnsafeRawPointer

    init() {
      // NB: Xcode runtime warnings offer a much better experience than traditional assertions and
      //     breakpoints, but Apple provides no means of creating custom runtime warnings ourselves.
      //     To work around this, we hook into SwiftUI's runtime issue delivery mechanism, instead.
      //
      // Feedback filed: https://gist.github.com/stephencelis/a8d06383ed6ccde3e5ef5d1b3ad52bbc
      let count = _dyld_image_count()
      for i in 0..<count {
        if let name = _dyld_get_image_name(i) {
          let swiftString = String(cString: name)
          if swiftString.hasSuffix("/SwiftUI") {
            if let header = _dyld_get_image_header(i) {
              self.dso = UnsafeRawPointer(header)
              return
            }
          }
        }
      }
      self.dso = #dsohandle
    }
  #endif

  @_transparent
  public func reportIssue(
    _ message: @autoclosure () -> String = "",
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    #if DEBUG && canImport(os)
      let moduleName = String(
        Substring("\(fileID)".utf8.prefix(while: { $0 != UTF8.CodeUnit(ascii: "/") }))
      )
      os_log(
        .fault,
        dso: dso,
        log: OSLog(subsystem: "com.apple.runtime-issues", category: moduleName),
        "%@",
        message()
      )
    #else
      fputs("\(fileID):\(line): \(message())\n", stderr)
    #endif
  }

  public func expectIssue(
    _ message: @autoclosure () -> String,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    #if DEBUG
      #if canImport(os)
        let moduleName = String(
          Substring("\(fileID)".utf8.prefix(while: { $0 != UTF8.CodeUnit(ascii: "/") }))
        )
        os_log(
          .info,
          log: OSLog(subsystem: "co.pointfree.expected-issues", category: moduleName),
          "%@",
          message()
        )
      #else
        fputs("\(fileID):\(line): \(message())\n", stdout)
      #endif
    #endif
  }
}

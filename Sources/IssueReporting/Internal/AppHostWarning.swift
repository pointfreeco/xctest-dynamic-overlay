import Foundation

extension String? {
  @usableFromInline
  func withAppHostWarningIfNeeded() -> String? {
    guard let self
    else {
      let warning = "".withAppHostWarningIfNeeded()
      return warning.isEmpty ? nil : warning
    }
    return self.withAppHostWarningIfNeeded()
  }
}

extension String {
  @usableFromInline
  func withAppHostWarningIfNeeded() -> String {
    #if os(WASI)
      return self
    #else
      guard
        isTesting,
        Bundle.main.bundleIdentifier != "com.apple.dt.xctest.tool"
      else { return self }

      let callStack = Thread.callStackSymbols
      guard
        callStack.allSatisfy({ !$0.contains("  XCTestCore ") }),
        callStack.allSatisfy({ !$0.isTestFrame })
      else { return self }

      let warning = """
        This issue was emitted from tests running in a host application\
        \(Bundle.main.bundleIdentifier.map { " (\($0))" } ?? "").

        This can lead to false positives, where failures could have emitted from live application \
        code at launch time, and not from the current test.

        For more information (and workarounds), see "Testing gotchas":

        https://swiftpackageindex.com/pointfreeco/swift-dependencies/main/documentation/dependencies/testing#Testing-gotchas
        """

      return isEmpty
        ? warning
        : """
        \(self)

        ━━┉┅
        \(warning)
        """
    #endif
  }

  #if !os(WASI)
    @usableFromInline
    var isTestFrame: Bool {
      guard let xcTestCase = NSClassFromString("XCTestCase")
      else { return false }

      // Regular expression to detect and demangle an XCTest case frame:
      //
      //  1. `(?<=\$s)`: Starts with "$s" (stable mangling)
      //  2. `\d{1,3}`: Some numbers (the class name length or the module name length)
      //  3. `.*`: The class name, or module name + class name length + class name
      //  4. `C`: The class type identifier
      //  5. `(?=\d{1,3}test.*yy(Ya)?K?F)`: The function name length, a function that starts with
      //     `test`, has no arguments (`y`), returns Void (`y`), and is a function (`F`),
      //     potentially async (`Ya`), throwing (`K`), or both.
      return range(
        of: #"(?<=\$s)\d{1,3}.*C(?=\d{1,3}test.*yy(Ya)?K?F)"#, options: .regularExpression
      )
      .map {
        (_typeByName(String(self[$0])) as? NSObject.Type)?.isSubclass(of: xcTestCase) ?? false
      }
        ?? false
    }
  #endif
}

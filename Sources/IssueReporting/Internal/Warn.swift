#if os(Linux) || os(Android)
  @preconcurrency import Foundation
#else
  import Foundation
#endif

#if canImport(WinSDK)
  import WinSDK
#endif

@usableFromInline
func printError(_ message: String) {
  fputs("\(message)\n", stderr)
}

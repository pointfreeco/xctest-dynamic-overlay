import Foundation

@usableFromInline
final class FailureObserver: @unchecked Sendable {
  @TaskLocal public static var current: FailureObserver?

  private let lock = NSRecursiveLock()
  private var count = 0

  @usableFromInline
  init(count: Int = 0) {
    self.count = count
  }

  @usableFromInline
  func withLock<R>(_ body: (inout Int) -> R) -> R {
    lock.lock()
    defer { lock.unlock() }
    return body(&count)
  }
}

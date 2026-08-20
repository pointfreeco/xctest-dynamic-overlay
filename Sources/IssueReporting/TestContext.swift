/// A type representing the context in which a test is being run, _i.e._ either in Swift's native
/// Testing framework, or Xcode's XCTest framework.
public enum TestContext: Equatable, Sendable {
  /// The Swift Testing framework.
  case swiftTesting(Testing?)

  /// The XCTest framework.
  case xcTest

  /// The context associated with current test.
  ///
  /// How the test context is detected depends on the framework:
  ///
  ///   * If Swift Testing is running, _and_ this is called from the current test's task, this will
  ///     return ``swiftTesting`` with an associated value of the current test. You can invoke
  ///     ``isSwiftTesting`` to detect if the test is currently in the Swift Testing framework,
  ///     which is equivalent to checking `Test.current != nil`, but safe to do from library and
  ///     application code.
  ///
  ///   * If XCTest is running, _and_ this is called during the execution of a test _regardless_ of
  ///     task, this will return ``xcTest``.
  ///
  /// If executed outside of a test process, this will return `nil`.
  public static var current: Self? {
    guard isTesting else { return nil }
    if let currentTest = _currentTest() {
      return .swiftTesting(Testing(id: currentTest.id, traits: currentTest.traits))
    } else {
      return .xcTest
    }
  }

  /// Determines if the test context is Swift's native Testing framework.
  public var isSwiftTesting: Bool {
    guard case .swiftTesting = self
    else { return false }
    return true
  }

  public struct Testing: Equatable, Sendable {
    public let test: Test

    public struct Test: Equatable, Hashable, Identifiable, Sendable {
      public let id: ID
      public let traits: [any Sendable]

      public struct ID: Equatable, Hashable, @unchecked Sendable {
        public let rawValue: AnyHashable
      }

      public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
      }

      public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
      }
    }
  }

  @available(*, deprecated, message: "Test using pattern matching, instead.")
  public static func == (lhs: Self, rhs: Self) -> Bool {
    switch (lhs, rhs) {
    case (.swiftTesting(nil), .swiftTesting),
      (.swiftTesting, .swiftTesting(nil)),
      (.xcTest, .xcTest):
      return true
    case (.swiftTesting(let lhs), .swiftTesting(let rhs)):
      return lhs == rhs
    case (.swiftTesting, .xcTest), (.xcTest, .swiftTesting):
      return false
    }
  }

  @available(
    *, deprecated,
    message: "Test for '.swiftTesting' using pattern matching or 'isSwiftTesting', instead."
  )
  public static var swiftTesting: Self {
    .swiftTesting(nil)
  }
}

extension TestContext.Testing {
  fileprivate init(id: AnyHashable, traits: [any Sendable]) {
    self.init(test: Test(id: Test.ID(rawValue: id), traits: traits))
  }
}

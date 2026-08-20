import Foundation
import XCTestDynamicOverlay

func MyXCTFail(_ message: String) {
  XCTFail(message)
}

#if canImport(ObjectiveC)
  func MyXCTExpectFailure(
    _ failureReason: String,
    enabled: Bool = true,
    strict: Bool = true,
    failingBlock: () -> Void,
    issueMatcher: ((_XCTIssue) -> Bool)? = nil
  ) {
    XCTExpectFailure(
      failureReason,
      enabled: enabled,
      strict: strict,
      failingBlock: failingBlock,
      issueMatcher: issueMatcher
    )
  }

  func MyXCTExpectFailure(
    _ failureReason: String,
    enabled: Bool = true,
    strict: Bool = true,
    issueMatcher: ((_XCTIssue) -> Bool)? = nil
  ) {
    XCTExpectFailure(
      failureReason,
      enabled: enabled,
      strict: strict,
      issueMatcher: issueMatcher
    )
  }
#endif

@available(*, deprecated)
struct Client {
  var p00: () -> Int
  var p01: () throws -> Int
  var p02: () async -> Int
  var p03: () async throws -> Int
  var p04: (Int) -> Int
  var p05: (Int) throws -> Int
  var p06: (Int) async -> Int
  var p07: (Int) async throws -> Int
  var p08: (Int, Int) -> Int
  var p09: (Int, Int) throws -> Int
  var p10: (Int, Int) async -> Int
  var p11: (Int, Int) async throws -> Int
  var p12: (Int, Int, Int) -> Int
  var p13: (Int, Int, Int) throws -> Int
  var p14: (Int, Int, Int) async -> Int
  var p15: (Int, Int, Int) async throws -> Int
  var p16: (Int, Int, Int, Int) -> Int
  var p17: (Int, Int, Int, Int) throws -> Int
  var p18: (Int, Int, Int, Int) async -> Int
  var p19: (Int, Int, Int, Int) async throws -> Int
  var p20: (Int, Int, Int, Int, Int) -> Int
  var p21: (Int, Int, Int, Int, Int) throws -> Int
  var p22: (Int, Int, Int, Int, Int) async -> Int
  var p23: (Int, Int, Int, Int, Int) async throws -> Int

  static var testValue: Self {
    Self(
      p00: unimplemented("\(Self.self).p00"),
      p01: unimplemented("\(Self.self).p01"),
      p02: unimplemented("\(Self.self).p02"),
      p03: unimplemented("\(Self.self).p03"),
      p04: unimplemented("\(Self.self).p04"),
      p05: unimplemented("\(Self.self).p05"),
      p06: unimplemented("\(Self.self).p06"),
      p07: unimplemented("\(Self.self).p07"),
      p08: unimplemented("\(Self.self).p08"),
      p09: unimplemented("\(Self.self).p09"),
      p10: unimplemented("\(Self.self).p10"),
      p11: unimplemented("\(Self.self).p11"),
      p12: unimplemented("\(Self.self).p12"),
      p13: unimplemented("\(Self.self).p13"),
      p14: unimplemented("\(Self.self).p14"),
      p15: unimplemented("\(Self.self).p15"),
      p16: unimplemented("\(Self.self).p16"),
      p17: unimplemented("\(Self.self).p17"),
      p18: unimplemented("\(Self.self).p18"),
      p19: unimplemented("\(Self.self).p19"),
      p20: unimplemented("\(Self.self).p20"),
      p21: unimplemented("\(Self.self).p21"),
      p22: unimplemented("\(Self.self).p22"),
      p23: unimplemented("\(Self.self).p23")
    )
  }
}

struct User { let id: UUID }

@MainActor let f00: () -> Int = unimplemented("f00", placeholder: 42)
@MainActor let f01: (String) -> Int = unimplemented("f01", placeholder: 42)
@MainActor let f02: (String, Int) -> Int = unimplemented("f02", placeholder: 42)
@MainActor let f03: (String, Int, Double) -> Int = unimplemented("f03", placeholder: 42)
@MainActor let f04: (String, Int, Double, [Int]) -> Int = unimplemented("f04", placeholder: 42)
@MainActor let f05: (String, Int, Double, [Int], User) -> Int = unimplemented(
  "f05", placeholder: 42)

@available(*, deprecated)
@MainActor let fm00: () -> Int = unimplemented("fm00")

@available(*, deprecated)
@MainActor let fm01: @MainActor () -> Int = unimplemented("fm01")

private struct Autoclosing {
  init(
    _: @autoclosure () -> Int = unimplemented(placeholder: 0),
    _: @autoclosure () async -> Int = unimplemented(placeholder: 0),
    _: @autoclosure () throws -> Int = unimplemented(placeholder: 0),
    _: @autoclosure () async throws -> Int = unimplemented(placeholder: 0)
  ) async {}
}

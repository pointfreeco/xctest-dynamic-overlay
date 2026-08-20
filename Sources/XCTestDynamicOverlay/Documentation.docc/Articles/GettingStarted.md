# Getting Started

## Overview

A real world example of using this is in our library, the [Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture). That library vends a `TestStore` type whose purpose is to make it easy to write tests for your application's logic. The `TestStore` uses `XCTFail` internally, and so that forces us to move the code to a dedicated test support module. However, due to how SPM works you cannot currently have that module in the same package as the main module, and so we would be forced to extract it to a separate _repo_. By loading `XCTFail` dynamically we can keep the code where it belongs.

As another example, let's say you have an analytics dependency that is used all over your application:

```swift
struct AnalyticsClient {
  var track: (Event) -> Void

  struct Event: Equatable {
    var name: String
    var properties: [String: String]
  }
}
```

If you are disciplined about injecting dependencies, you probably have a lot of objects that take an analytics client as an argument (or maybe some other fancy form of DI):

```swift
class LoginViewModel: ObservableObject {
  // ...

  init(analytics: AnalyticsClient) {
    // ...
  }

  // ...
}
```

When testing this view model you will need to provide an analytics client. Typically this means you will construct some kind of "test" analytics client that buffers events into an array, rather than sending live events to a server, so that you can assert on what events were tracked during a test:

```swift
func testLogin() {
  var events: [AnalyticsClient.Event] = []
  let viewModel = LoginViewModel(
    analytics: .test { events.append($0) }
  )

  // ...

  XCTAssertEqual(events, [.init(name: "Login Success")])
}
```

This works really well, and it's a great way to get test coverage on something that is notoriously difficult to test.

However, some tests may not use analytics at all. It would make the test suite stronger if the tests that don't use the client could prove that it's never used. This would mean when new events are tracked you could be instantly notified of which test cases need to be updated.

One way to do this is to create an instance of the `AnalyticsClient` type that simply performs an `XCTFail` inside the `track` endpoint:

```swift
import XCTest

extension AnalyticsClient {
  static let unimplemented = Self(
    track: { _ in XCTFail("\(Self.self).track is unimplemented.") }
  )
}
```

With this you can write a test that proves analytics are never tracked, and even better you don't have to worry about buffering events into an array anymore:

```swift
func testValidation() {
  let viewModel = LoginViewModel(
    analytics: .unimplemented
  )

  // ...
}
```

However, you cannot ship this code with the target that defines `AnalyticsClient`. You either need to extract it out to a test support module (which means `AnalyticsClient` must also be extracted), or the code must be confined to a test target and thus not shareable.

However, with XCTest Dynamic Overlay we can have our cake and eat it too 😋. We can define both the client type and the unimplemented instance right next to each in application code without needing to extract out needless modules or targets:

```swift
struct AnalyticsClient {
  var track: (Event) -> Void

  struct Event: Equatable {
    var name: String
    var properties: [String: String]
  }
}

import XCTestDynamicOverlay

extension AnalyticsClient {
  static let unimplemented = Self(
    track: { _ in XCTFail("\(Self.self).track is unimplemented.") }
  )
}
```

XCTest Dynamic Overlay also comes with a helper that simplifies this exact pattern: `XCTUnimplemented`. It creates failing closures for you:

```swift
extension AnalyticsClient {
  static let unimplemented = Self(
    track: XCTUnimplemented("\(Self.self).track")
  )
}
```

And it can simplify the work of more complex dependency endpoints, which can throw or need to return a value:

```swift
struct AppDependencies {
  var date: () -> Date = Date.init,
  var fetchUser: (User.ID) async throws -> User,
  var uuid: () -> UUID = UUID.init
}

extension AppDependencies {
  static let unimplemented = Self(
    date: XCTUnimplemented("\(Self.self).date", placeholder: Date()),
    fetchUser: XCTUnimplemented("\(Self.self).fetchUser"),
    date: XCTUnimplemented("\(Self.self).uuid", placeholder: UUID())
  )
}
```

The above `placeholder` parameters can be left off, but will fatal error when the endpoint is called.

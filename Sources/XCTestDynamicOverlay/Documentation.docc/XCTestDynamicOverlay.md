# ``XCTestDynamicOverlay``

Define XCTest assertion helpers directly in your application and library code.

## Overview

> Important: This module is considered deprecated for `IssueReporting` and will be removed in the
> next major version of the library.

It is very common to write test support code for libraries and applications. This often comes in the 
form of little domain-specific functions or helpers that make it easier for users of your code to 
formulate assertions on behavior.

Currently there are only two options for writing test support code:

* Put it in a test target, but then you can't access it from multiple other test targets. For 
whatever reason test targets cannot be imported, and so the test support code will only be available 
in that one single test target.
* Create a dedicated test support module that ships just the test-specific code. Then you can import 
this module into as many test targets as you want, while never letting the module interact with your 
regular, production code.

Neither of these options is ideal. In the first case you cannot share your test support, and the 
second case will lead you to a proliferation of modules. For each feature you potentially need 3 
modules: `MyFeature`, `MyFeatureTests` and `MyFeatureTestSupport`. SPM makes managing this quite 
easy, but it's still a burden.

It would be far better if we could ship the test support code right along side or actual library or 
application code. After all, they are intimately related. You can even fence off the test support 
code in `#if DEBUG ... #endif` if you are worried about leaking test code into production.

However, as soon as you add `import XCTest` to a source file in your application or a library it 
loads, the target becomes unbuildable:

```swift
import XCTest
// 🛑 ld: warning: Could not find or use auto-linked library 'XCTestSwiftSupport'
// 🛑 ld: warning: Could not find or use auto-linked framework 'XCTest'
```

This is due to a confluence of problems, including test header search paths, linker issues, and 
more. XCTest just doesn't seem to be built to be loaded alongside your application or library code.

So, the XCTest Dynamic Overlay library is a microlibrary that dynamically loads the `XCTFail` symbol
at runtime and exposes it publicly so that it can be used from anywhere. This means you can import
this library instead of XCTest:

```swift
import XCTestDynamicOverlay // ✅
```

…and your application or library will continue to compile just fine.

> Important: The dynamically loaded `XCTFail` is only available in `DEBUG` builds in order
to prevent App Store rejections due to runtime loading of symbols.

## Topics

### Essentials

- <doc:GettingStarted>

### Overlays

- ``XCTFail(_:file:line:)``
- ``XCTExpectFailure(_:enabled:strict:failingBlock:issueMatcher:)``

### Unimplemented dependencies

- ``unimplemented(_:placeholder:fileID:line:)``
- ``unimplemented(_:fileID:line:)``

### Deprecated interfaces

- <doc:Deprecations>

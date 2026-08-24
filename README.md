# XCTestDynamicOverlay

> [!IMPORTANT]
> This library now lives at
> [**pointfreeco/swift-issue-reporting**](https://github.com/pointfreeco/swift-issue-reporting).
> This repository exists only to keep packages that depend on the old
> `https://github.com/pointfreeco/xctest-dynamic-overlay` URL working, forever, without breaking
> changes.

Do not depend on this library directly anymore, and instead update your dependencies to
[swift-issue-reporting]:

```diff
-.package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.0.0"),
+.package(url: "https://github.com/pointfreeco/swift-issue-reporting", from: "2.0.0"),
```

…and update any target dependencies accordingly:

```diff
-.product(name: "IssueReporting", package: "xctest-dynamic-overlay"),
+.product(name: "IssueReporting", package: "swift-issue-reporting"),
```

You can do this on your own time since this repo exists to make the transition easy.

## Migrating off of XCTestDyanmicOverlay

Version 1.13 of this library makes it possible for you to move your codebases and 
Swift packages to IssueReporting 2.0. This can be done with no breaking changes so that you and
your team can complete the transition whenever it is most convenient.

### Do you need to do anything?

  * If you depend on `xctest-dynamic-overlay` only transitively (for example through the
    ComposableArchitecture, SQLiteData, Dependencies, or CustomDump) there is nothing to do.

  * If you maintain a `Package.swift` that depends on 
    `github.com/pointfreeco/xctest-dynamic-overlay` directly, follow
    <doc:MigratingTo1.13#Updating-SwiftPM-packages>.

  * If you maintain an Xcode project that depends on `github.com/pointfreeco/xctest-dynamic-overlay`
    directly, follow
    <doc:MigratingTo1.13#Updating-Xcode-projects>.

### Updating SwiftPM packages

SwiftPM packages depending directly on `pointfreeco/xctest-dynamic-overlay` should split their 
manifest into one targeting Swift 6.4+ and one targeting Swift <6.4:

* `Package.swift` targets Swift 6.4 and depends on `pointfreeco/swift-issue-reporting` from `2.1` 
  on:
  ```diff
  +// swift-tools-version: 6.4
  
  …
  
  -.package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.13.0"),
  +.package(url: "https://github.com/pointfreeco/swift-issue-reporting", from: "2.1.0"),
  ```

  And update all target dependencies to use `swift-issue-reporting`:

  ```diff
  -.product(name: "IssueReporting", package: "xctest-dynamic-overlay")
  +.product(name: "IssueReporting", package: "swift-issue-reporting")
  ```

* `Package@swift-<version>.swift` targets anything less than Swift 6.4 and keeps depending on
  `pointfreeco/xctest-dynamic-overlay` from 1.13 on:
  ```swift
  .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.13.0"),
  ```

### Updating Xcode projects

An Xcode project cannot vary its dependencies by Swift toolchain, so there are a few things to keep
in mind to update in a non-breaking fashion:

* If using Xcode 27 you can immediately replace `pointfreeco/xctest-dynamic-overlay` 
with `pointfreeco/swift-issue-reporting` and everything should work fine.
* If using Xcode 26 or earlier, then you can replace `pointfreeco/xctest-dynamic-overlay`
with `pointfreeco/swift-issue-reporting` only once all other dependencies are using IssueReporting. 
You determine this by removing `xctest-dynamic-overlay` as a direct dependency and see if it is
removed from Xcode's list of resolved dependencies. If it is, then you can add 
`swift-issue-reporting` from 2.1 on, and if it is not then you must keep depending on 
`xctest-dynamic-overlay` directly.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.

[swift-issue-reporting]: https://github.com/pointfreeco/swift-issue-reporting

# XCTestDynamicOverlay

> [!IMPORTANT]
> This library now lives at
> [**pointfreeco/swift-issue-reporting**](https://github.com/pointfreeco/swift-issue-reporting).
> This repository exists only to keep packages that depend on the old
> `https://github.com/pointfreeco/xctest-dynamic-overlay` URL working, forever, without breaking
> changes.

## What is this repository?

This package was renamed to [swift-issue-reporting][sir] to match the `IssueReporting` library it
vends. Because Swift Package Manager derives a package's identity from its URL, the old and new
URLs are two different packages as far as SwiftPM is concerned, and for a while it was impossible
for both to appear in the same dependency graph.

Starting with version 1.12.0, this repository solves that problem by becoming a _forwarding
package_:

  * All versions up to and including 1.11.0 are the original, unchanged releases of the library.
  * Version 1.12.0 and later contain no library code of their own. They vend the same three
    products as before—`IssueReporting`, `IssueReportingTestSupport`, and `XCTestDynamicOverlay`—but
    each simply re-exports the real implementation from [swift-issue-reporting] 2.x.

This means packages that depend on this URL and packages that depend on [swift-issue-reporting] can
now coexist in the same dependency graph, sharing a single copy of the library at runtime.

## What should you do?

If you depend on this repository, update your `Package.swift` to point at the new URL whenever it
is convenient:

```diff
-.package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.0.0"),
+.package(url: "https://github.com/pointfreeco/swift-issue-reporting", from: "2.0.0"),
```

and update any target dependencies accordingly:

```diff
-.product(name: "IssueReporting", package: "xctest-dynamic-overlay"),
+.product(name: "IssueReporting", package: "swift-issue-reporting"),
```

There is no urgency: the old URL will continue to work indefinitely.

## Troubleshooting

> Error: multiple targets named 'IssueReporting' in: 'swift-issue-reporting',
> 'xctest-dynamic-overlay'

Your dependency graph has resolved this package to a version earlier than 1.12.0 alongside
[swift-issue-reporting]. Update your dependencies
(**File&nbsp;❯&nbsp;Packages&nbsp;❯&nbsp;Update&nbsp;to&nbsp;Latest&nbsp;Package&nbsp;Versions** in
Xcode, or `swift package update` on the command line) so that this package resolves to 1.12.0 or
later.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.

[swift-issue-reporting]: https://github.com/pointfreeco/swift-issue-reporting

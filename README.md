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

## How this repository works

Versions up to 1.11.0 are the original releases of the library. Starting with 1.12.1 this
repository behaves differently depending on your toolchain:

  * **Xcode 27 / Swift 6.4 and later:** the package is a thin forwarding shim. It vends the same
    products as before (`IssueReporting`, `IssueReportingTestSupport`, `XCTestDynamicOverlay`) but
    each simply re-exports the implementation from [swift-issue-reporting] 2.x. This lets packages
    that depend on the old URL and packages that depend on the new URL coexist in one dependency
    graph, sharing a single copy of the library.

  * **Xcode 26 / Swift 6.3 and earlier:** the package is the original, self-contained 1.x library,
    frozen at 1.11.0. These toolchains cannot build a dependency graph in which two packages vend
    same-named products, so on them the old URL and the new URL still cannot be mixed in one graph,
    exactly as before.

## Troubleshooting

> Error: multiple packages ('swift-issue-reporting', 'xctest-dynamic-overlay') declare targets with
> a conflicting name: 'IssueReporting'

Your dependency graph contains both the old and the new URL. On Xcode 27 or later, update your
dependencies (**File&nbsp;❯&nbsp;Packages&nbsp;❯&nbsp;Update&nbsp;to&nbsp;Latest&nbsp;Package&nbsp;Versions**
in Xcode, or `swift package update` on the command line) so that this package resolves to 1.12.1 or
later. On Xcode 26 or earlier, mixing the two URLs is not supported: make every dependency in your
graph use the same URL.

> Error: Could not compute dependency graph: unable to load transferred PIF: PIFLoader: GUID
> 'PRODUCTREF-PACKAGE-PRODUCT:IssueReporting-…-dynamic' has already been registered

You are on Xcode 26 or earlier and this package resolved to 1.12.0, which is not compatible with
those Xcode versions. Update your dependencies so that this package resolves to 1.12.1 or later.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.

[swift-issue-reporting]: https://github.com/pointfreeco/swift-issue-reporting

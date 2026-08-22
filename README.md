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

If you depend on this package _directly_, see the
[migration guide](Sources/XCTestDynamicOverlay/Documentation.docc/Articles/MigrationGuides/MigratingTo1.13.md)
for the steps to take.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.

[swift-issue-reporting]: https://github.com/pointfreeco/swift-issue-reporting

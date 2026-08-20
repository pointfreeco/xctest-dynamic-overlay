# XCTestDynamicOverlay

> [!IMPORTANT]
> This library now lives at
> [**pointfreeco/swift-issue-reporting**](https://github.com/pointfreeco/swift-issue-reporting).
> This repository exists only to keep packages that depend on the old
> `https://github.com/pointfreeco/xctest-dynamic-overlay` URL working, forever, without breaking
> changes.

Do not depend on this library directly anymore, and instead update your dependencies to
[swift-issue-reporting:]

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

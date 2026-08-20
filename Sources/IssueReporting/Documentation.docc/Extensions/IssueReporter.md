# ``IssueReporting/IssueReporter``

## Topics

### Custom issue reporting

- ``reportIssue(_:severity:fileID:filePath:line:column:)``

### Optional requirements

- ``reportIssue(_:_:fileID:filePath:line:column:)``
- ``expectIssue(_:fileID:filePath:line:column:)``

### Available reporters

- ``runtimeWarning``
- ``breakpoint``
- ``fatalError``

### Deprecated requirements

- ``reportIssue(_:fileID:filePath:line:column:)``

@propertyWrapper
@usableFromInline
struct UncheckedSendable<Value>: @unchecked Sendable {
  @usableFromInline
  var wrappedValue: Value
  init(wrappedValue value: Value) {
    self.wrappedValue = value
  }
}

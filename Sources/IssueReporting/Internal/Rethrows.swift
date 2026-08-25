@rethrows
@usableFromInline
protocol _ErrorMechanism {
  associatedtype Output
  func get() throws -> Output
}
extension _ErrorMechanism {
  func _rethrowError() rethrows -> Never {
    _ = try _rethrowGet()
    fatalError()
  }
  @usableFromInline
  func _rethrowGet() rethrows -> Output {
    return try get()
  }
}
extension Result: _ErrorMechanism {}

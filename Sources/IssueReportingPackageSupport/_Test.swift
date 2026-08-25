@usableFromInline
package struct _Test {
  @usableFromInline
  package let id: AnyHashable

  @usableFromInline
  package let traits: [any Sendable]

  @usableFromInline
  package init(id: AnyHashable, traits: [any Sendable]) {
    self.id = id
    self.traits = traits
  }
}

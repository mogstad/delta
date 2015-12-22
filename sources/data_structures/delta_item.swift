public protocol DeltaItem {
  typealias DeltaIdentifier: Hashable
  var deltaIdentifier: DeltaIdentifier { get }
}

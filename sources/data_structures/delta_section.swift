public protocol DeltaSection: DeltaItem {
  typealias Item: DeltaItem, Equatable
  var items: [Item] { get }
}

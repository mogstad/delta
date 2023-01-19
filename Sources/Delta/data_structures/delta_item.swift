/// To use Delta your data need to conform to the `DeltaItem` protocol. It 
/// allows delta to determine if the data is changes or a completely different 
/// item. Internally Delta checks if items has the same `deltaIdentifier` and if
/// the items are equal. If the `deltaIdentifier` are the same, but they are not
/// equal, a change record is generated instead of a remove and add change 
/// record.
public protocol DeltaItem {
  associatedtype DeltaIdentifier: Hashable

  /// Identifier to detemine if the data is the same or just changed. This is 
  /// typically the remote identifier of the item. If you implement this 
  /// incorretly you will see remove and add animation instead of change/reload 
  /// animation.
  var deltaIdentifier: DeltaIdentifier { get }
}

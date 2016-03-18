/// To animate changes for sections, your data need to conform to the 
/// `DeltaSection` protocol. It’s expected that your data structure is an array 
/// of `DeltaSection`s that has an array of `DeltaItem`s. `DeltaSection` extends
/// the DeltaItem protocol, meaning you have to provide an identifier foreach 
/// section as well. E.g. If your data is grouped by days, the identifier can be
/// a `NSDateComponent` with the year, month, and day compnents.
public protocol DeltaSection: DeltaItem {
  typealias Item: DeltaItem, Equatable

  /// Array of `DeltaItem`s in the section.
  var items: [Item] { get }
}

/// `DeltaChange` describe a single change between two flat arrays. One or more 
/// `DeltaChange` records describe the changes required to turn one flat array 
/// into another. 
public enum DeltaChange: Equatable {
  /// An item is added
  /// 
  /// - parameter index: Index of the new item
  case add(index: Int)

  /// An item is removed
  ///
  /// - parameter index: Index of the removed item
  case remove(index: Int)

  /// An item is moved
  ///
  /// - parameter index: The new index of the item
  /// - parameter from: The old index of the item
  case move(index: Int, from: Int)

  /// An item has changed. Due to internals in some UI components, we need to 
  /// know where the item was before the all applied changes.
  ///
  /// - parameter index: The index of the item, in the new dataset.
  /// - parameter from: The index of the item, in the old dataset.
  case change(index: Int, from: Int)
}

/// Returns whether the two `DeltaChange` records are equal.
///
/// - note: Mostly here to make it easier to write tests.
///
/// - parameter lhs: The left-hand side value to compare
/// - parameter rhs: The Right-hand side value to compare
/// - returns: Returns `true` iff `lhs` is identical to `rhs`.
public func ==(lhs: DeltaChange, rhs: DeltaChange) -> Bool {
  switch (lhs, rhs) {
  case (let .add(lhsIndex), let .add(rhsIndex)):
    return lhsIndex == rhsIndex
  case (let .remove(lhsIndex), let .remove(rhsIndex)):
    return lhsIndex == rhsIndex
  case (let .move(lhsIndex, lhsFrom), let .move(rhsIndex, rhsFrom)):
    return lhsIndex == rhsIndex && lhsFrom == rhsFrom
  case (let .change(lhsIndex, lhsFrom), let .change(rhsIndex, rhsFrom)):
    return lhsIndex == rhsIndex && lhsFrom == rhsFrom
  default:
    return false
  }
}

extension DeltaChange {

  /// Converts the `DeltaChange` record, into a `CollectionRecord` to describe
  /// changes of sections.
  func toCollectionSectionRecord() -> CollectionRecord {
    switch self {
    case let .add(index):
      return .addSection(section: index)
    case let .remove(index):
      return .removeSection(section: index)
    case let .move(index, from):
      return .moveSection(section: index, from: from)
    case let .change(_, from):
      return .reloadSection(section: from)
    }
  }

  /// Converts the `DeltaChange` record into a `CollectionRecord` to describe
  /// changes of items in a section.
  ///
  /// - parameter section: Index of the section the items are located.
  /// - parameter oldSection: Index of the section the items used to be located.
  func toCollectionItemRecord(section: Int, oldSection: Int) -> CollectionRecord {
    switch self {
    case let .add(index):
      return .addItem(section: section, index: index)
    case let .remove(index):
      return .removeItem(section: oldSection, index: index)
    case let .move(index, from):
      return .moveItem(
        from: (section: oldSection, index: from),
        to: (section: section, index: index))
    case let .change(index, from):
      return .changeItem(
        from: (section: oldSection, index: from),
        to: (section: section, index: index))
    }
  }

}

extension DeltaChange: CustomStringConvertible {

  /// The textual representation used when written to an output stream, which 
  /// includes the name of enum case, and its associated values.
  public var description: String {
    switch self {
    case let .add(index):
      return "DeltaChange type='add' index='\(index)'"
    case let .remove(index):
      return "DeltaChange type='remove' index='\(index)'"
    case let .move(index, from):
      return "DeltaChange type='move' index='\(index)' from='\(from)'"
    case let .change(index, from):
      return "DeltaChange type='change' index='\(index)' from='\(from)'"
    }
  }

}

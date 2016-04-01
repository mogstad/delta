/// `DeltaChange` describe a single change between two flat arrays. One or more 
/// `DeltaChange` records describe the changes required to turn one flat array 
/// into another. 
public enum DeltaChange: Equatable {
  /// An item is added
  /// 
  /// - parameter index: Index of the new item
  case Add(index: Int)

  /// An item is removed
  ///
  /// - parameter index: Index of the removed item
  case Remove(index: Int)

  /// An item is moved
  ///
  /// - parameter index: The new index of the item
  /// - parameter from: The old index of the item
  case Move(index: Int, from: Int)

  /// An item has changed. Due to internals in some UI components, we need to 
  /// know where the item was before the all applied changes.
  ///
  /// - parameter index: The index of the item, in the new dataset.
  /// - parameter from: The index of the item, in the old dataset.
  case Change(index: Int, from: Int)
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
  case (let .Add(lhsIndex), let .Add(rhsIndex)):
    return lhsIndex == rhsIndex
  case (let .Remove(lhsIndex), let .Remove(rhsIndex)):
    return lhsIndex == rhsIndex
  case (let .Move(lhsIndex, lhsFrom), let .Move(rhsIndex, rhsFrom)):
    return lhsIndex == rhsIndex && lhsFrom == rhsFrom
  case (let .Change(lhsIndex, lhsFrom), let .Change(rhsIndex, rhsFrom)):
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
    case let .Add(index):
      return .AddSection(section: index)
    case let .Remove(index):
      return .RemoveSection(section: index)
    case let .Move(index, from):
      return .MoveSection(section: index, from: from)
    case let .Change(_, from):
      return .ReloadSection(section: from)
    }
  }

  /// Converts the `DeltaChange` record into a `CollectionRecord` to describe
  /// changes of items in a section.
  ///
  /// - parameter section: Index of the section the items are located.
  /// - parameter oldSection: Index of the section the items used to be located.
  func toCollectionItemRecord(section section: Int, oldSection: Int) -> CollectionRecord {
    switch self {
    case let .Add(index):
      return .AddItem(section: section, index: index)
    case let .Remove(index):
      return .RemoveItem(section: oldSection, index: index)
    case let .Move(index, from):
      return .MoveItem(
        from: (section: oldSection, index: from),
        to: (section: section, index: index))
    case let .Change(index, from):
      return .ChangeItem(
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
    case let .Add(index):
      return "DeltaChange type='add' index='\(index)'"
    case let .Remove(index):
      return "DeltaChange type='remove' index='\(index)'"
    case let .Move(index, from):
      return "DeltaChange type='move' index='\(index)' from='\(from)'"
    case let .Change(index, from):
      return "DeltaChange type='change' index='\(index)' from='\(from)'"
    }
  }

}

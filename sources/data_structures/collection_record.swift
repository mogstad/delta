public typealias CollectionItem = (section: Int, index: Int)

/// A `CollectionRecord` describe one change in your dataset. Delta uses it to
/// describe the changes to perform to the old dataset to turn it into the new
/// dataset. Each case has assoicated values to best describe the change for 
/// that type of change.
public enum CollectionRecord: Equatable {

  /// Item is added into an existing section.
  ///
  /// - parameter section: The section the item is added to.
  /// - parameter index: Index the item is added to.
  case AddItem(section: Int, index: Int)

  /// Item is removed from an existing section.
  ///
  /// - parameter section: The section the item is removed from.
  /// - parameter index: Index the item is removed from.
  case RemoveItem(section: Int, index: Int)

  /// Describes that an item is moved in-between an existing section. Due to
  /// limitations with Delta, we don’t currently support creating move records 
  /// between sections. Instead we generate two record: one remove record from 
  /// the old section, and one add record to the new section.
  /// 
  /// - parameter from: A tuple, with the section and the index of the item
  ///   where it used to be.
  /// - parameter to: A tuple, with the section and the index of the item, 
  ///   where it’s move to.
  case MoveItem(from: CollectionItem, to: CollectionItem)

  /// Describes that an item has been changed. Its identifier is equal, but the 
  /// model’s equality test fails. Due to internals in Apple’s display classes, 
  /// it’s required to query for the old cell with the original index path, and
  /// update it with data from the new index path.
  ///
  /// - parameter from: A tuple, with the section and the index of the item
  ///   where it used to be. Depending on the UI implementation, you might want 
  ///   to query the cell with these values.
  /// - parameter to: A tuple, with the section and the index of the item,
  ///   where it’s ended up being. Use these values to query your data.
  case ChangeItem(from: CollectionItem, to: CollectionItem)

  /// Describes that a section is to be added.
  /// 
  /// - parameter section: Index of the newly inserted section.
  case AddSection(section: Int)

  /// Describes that a section is to be moved.
  ///
  /// - parameter section: Index of the sections new location.
  /// - parameter from: Index where the section used to be located.
  case MoveSection(section: Int, from: Int)

  /// Describes that a section is to be removed.
  /// 
  /// - parameter section: Index of the section to remove.
  case RemoveSection(section: Int)

  /// Describes a section that requires a reload. This is mainly needed when 
  /// using cells as empty states. As Delta won’t support multiple types of
  /// data in the same section. And therefor can’t generate an insert item 
  /// record for the empty state.
  /// 
  /// - parameter section: Index of the section to reload
  case ReloadSection(section: Int)

}

/// Returns whether the two `CollectionRecord` records are equal.
///
/// - note: Mostly here to make it easier to write tests.
///
/// - parameter lhs: The left-hand side value to compare
/// - parameter rhs: The Right-hand side value to compare
/// - returns: Returns `true` iff `lhs` is identical to `rhs`.
public func ==(lhs: CollectionRecord, rhs: CollectionRecord) -> Bool {
    switch (lhs, rhs) {
    case (let .AddItem(lhsSection, lhsIndex), let .AddItem(rhsSection, rhsIndex)):
      return lhsSection == rhsSection && lhsIndex == rhsIndex
    case (let .RemoveItem(lhsSection, lhsIndex), let .RemoveItem(rhsSection, rhsIndex)):
      return lhsSection == rhsSection && lhsIndex == rhsIndex
    case (let .MoveItem(lhsFrom, lhsTo), let .MoveItem(rhsFrom, rhsTo)):
      return (
        lhsFrom.section == rhsFrom.section &&
        lhsFrom.index == rhsFrom.index &&
        lhsTo.section == rhsTo.section &&
        lhsTo.index == rhsTo.index)

    case (let .ChangeItem(lhsFrom, lhsTo), let .ChangeItem(rhsFrom, rhsTo)):
      return (
        lhsFrom.section == rhsFrom.section &&
        lhsFrom.index == rhsFrom.index &&
        lhsTo.section == rhsTo.section &&
        lhsTo.index == rhsTo.index)

    case (let .AddSection(lhsIndex), let .AddSection(rhsIndex)):
      return lhsIndex == rhsIndex
    case (let .RemoveSection(lhsIndex), let .RemoveSection(rhsIndex)):
      return lhsIndex == rhsIndex
    case (let .MoveSection(lhsIndex, lhsFrom), let .MoveSection(rhsIndex, rhsFrom)):
      return lhsIndex == rhsIndex && lhsFrom == rhsFrom
    case (let .ReloadSection(lhsIndex), let .ReloadSection(rhsIndex)):
      return lhsIndex == rhsIndex

    default:
      return false
    }

}

extension CollectionRecord: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .AddItem(section: let section, index: let index):
      return "AddItem: \(section),\(index)"
    case .RemoveItem(section: let section, index: let index):
      return "RemoveItem: \(section),\(index)"
    case .MoveItem(from: let from, to: let to):
      return "MoveItem: from \(from.section),\(from.index) to \(to.section),\(to.index)"
    case .ChangeItem(from: let from, to: let to):
      return "ChangeItem: from \(from.section),\(from.index) to \(to.section),\(to.index)"
    case .AddSection(section: let section):
      return "AddSection: \(section)"
    case .MoveSection(section: let from, from: let to):
      return "MoveSection: from \(from) to \(to)"
    case .RemoveSection(section: let section):
      return "RemoveSection: \(section)"
    case .ReloadSection(section: let section):
      return "ReloadSection: \(section)"
    }
  }
}


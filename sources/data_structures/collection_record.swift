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
  case ChangeItem(section: Int, index: Int, from: Int)

  /// Section is added
  /// 
  /// - parameter section: Index of the newly inserted section.
  case AddSection(section: Int)

  /// Describes that a section is moved.
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

/// Equatable conformation, only here to make it easier to test.
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

    case (let .ChangeItem(lhsSection, lhsIndex, lhsFrom), let .ChangeItem(rhsSection, rhsIndex, rhsFrom)):
      return lhsSection == rhsSection && lhsIndex == rhsIndex && lhsFrom == rhsFrom

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

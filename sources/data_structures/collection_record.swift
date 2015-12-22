public enum CollectionRecord: Equatable {

  case AddItem(section: Int, index: Int)
  case RemoveItem(section: Int, index: Int)
  case MoveItem(section: Int, index: Int, from: Int)
  case ChangeItem(section: Int, index: Int, from: Int)

  case AddSection(section: Int)
  case MoveSection(section: Int, from: Int)
  case RemoveSection(section: Int)
  case ReloadSection(section: Int)

}

public func ==(lhs: CollectionRecord, rhs: CollectionRecord) -> Bool {
    switch (lhs, rhs) {
    case (let .AddItem(lhsSection, lhsIndex), let .AddItem(rhsSection, rhsIndex)):
      return lhsSection == rhsSection && lhsIndex == rhsIndex
    case (let .RemoveItem(lhsSection, lhsIndex), let .RemoveItem(rhsSection, rhsIndex)):
      return lhsSection == rhsSection && lhsIndex == rhsIndex
    case (let .MoveItem(lhsSection, lhsIndex, lhsFrom), let .MoveItem(rhsSection, rhsIndex, rhsFrom)):
      return lhsSection == rhsSection && lhsIndex == rhsIndex && lhsFrom == rhsFrom
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

extension DeltaChange {

  func toCollectionSectionRecord() -> CollectionRecord {
    switch self {
    case let .Add(index):
      return .AddSection(section: index)
    case let .Remove(index):
      return .RemoveSection(section: index)
    case let .Move(index, from):
      return .MoveSection(section: index, from: from)
    case let .Change(index, _):
      return .ReloadSection(section: index)
    }
  }

  func toCollectionItemRecord(section section: Int) -> CollectionRecord {
    switch self {
    case let .Add(index):
      return .AddItem(section: section, index: index)
    case let .Remove(index):
      return .RemoveItem(section: section, index: index)
    case let .Move(index, from):
      return .MoveItem(section: section, index: index, from: from)
    case let .Change(index, from):
      return .ChangeItem(section: section, index: index, from: from)
    }
  }
  
}

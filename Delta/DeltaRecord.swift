import Foundation

enum DeltaRecordAction: Int {
  case Add, Remove, Move, Change, Reload

  func toCollectionSectionRecordAction() -> DeltaCollectionRecordAction {
    switch self {
    case .Add:
      return .AddSection
    case .Remove:
      return .RemoveSection
    case .Move:
      return .MoveSection
    case .Change, .Reload:
      return .ReloadSection
    }
  }

  func toCollectionItemRecordAction() -> DeltaCollectionRecordAction {
    switch self {
    case .Add:
      return .AddItem
    case .Remove:
      return .RemoveItem
    case .Move:
      return .MoveItem
    case .Change:
      return .ChangeItem
    case .Reload:
      return .ReloadSection
    }
  }

}

public struct DeltaRecord<T: Equatable>: Equatable, Printable {

  let type: DeltaRecordAction
  let item: T?
  let index: Int
  let fromIndex: Int
  public var description: String {
    return "DeltaRecord type='\(self.type.rawValue)' index='\(self.index)' item='\(self.item)' fromIndex='\(self.fromIndex)'"
  }

  init(type: DeltaRecordAction, item: T?, index: Int, fromIndex: Int = Int.max) {
    self.type = type
    self.item = item
    self.index = index
    self.fromIndex = fromIndex
  }

  func toCollectionSectionAction() -> DeltaCollectionRecord {
    return DeltaCollectionRecord(
      type: self.type.toCollectionSectionRecordAction(),
      index: Int(self.index),
      fromIndex: Int(self.fromIndex))
  }

  func toCollectionItemAction(section: Int) -> DeltaCollectionRecord {
    return DeltaCollectionRecord(
      type: self.type.toCollectionItemRecordAction(),
      index: Int(self.index),
      section: section,
      fromIndex: Int(self.fromIndex))
  }

}

public func ==<T>(lhs: DeltaRecord<T>, rhs: DeltaRecord<T>) -> Bool {
  return (
    lhs.type == rhs.type &&
    lhs.item == rhs.item &&
    lhs.index == rhs.index &&
    lhs.fromIndex == rhs.fromIndex
  )
}

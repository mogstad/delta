import Foundation

enum DeltaCollectionRecordAction: Int {
  // Item actions
  case AddItem, RemoveItem, MoveItem, ChangeItem, ReloadItem
  // Section actions
  case RemoveSection, AddSection, ReloadSection, MoveSection
}

public struct DeltaCollectionRecord: Equatable, Printable {

  let type: DeltaCollectionRecordAction
  let index: Int
  let fromIndex: Int
  let section: Int

  init(type: DeltaCollectionRecordAction, index: Int, section: Int = Int.max, fromIndex: Int = Int.max) {
    self.type = type
    self.index = index
    self.fromIndex = fromIndex
    self.section = section
  }

}

public func ==(lhs: DeltaCollectionRecord, rhs: DeltaCollectionRecord) -> Bool {
  return (
    lhs.type == rhs.type &&
    lhs.index == rhs.index &&
    lhs.fromIndex == rhs.fromIndex &&
    lhs.section == rhs.section
  )
}

public extension DeltaCollectionRecord {
  public var description: String {
    return "DeltaRecord type='\(self.type.rawValue)' index='\(self.index)' section='\(self.section)' fromIndex='\(self.fromIndex)'"
  }

}
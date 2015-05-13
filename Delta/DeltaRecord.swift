import Foundation

enum DeltaRecordAction: Int {
  case Add, Remove, Move, Change, RemoveSection, ReloadSection
}

public struct DeltaRecord<T: Equatable>: Equatable, Printable {

  let type: DeltaRecordAction
  let item: T?
  let index: UInt
  let fromIndex: UInt
  public var description: String {
    get {
      return "DeltaRecord type='\(self.type.rawValue)' index='\(self.index)' item='\(self.item)' fromIndex='\(self.fromIndex)'"
    }
  }

  init(type: DeltaRecordAction, item: T?, index: UInt, fromIndex: UInt = UInt.max) {
    self.type = type
    self.item = item
    self.index = index
    self.fromIndex = fromIndex
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

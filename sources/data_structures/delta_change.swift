public enum DeltaChange: Equatable {
  case Add(index: Int)
  case Remove(index: Int)
  case Move(index: Int, from: Int)
  case Change(index: Int, from: Int)
}

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

extension DeltaChange: CustomStringConvertible {

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

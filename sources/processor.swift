/// Creates DeltaChange records for the difference between the `from` and `to`
/// array.
///
/// - parameter from: the original data structure.
/// - parameter to: the new data structure.
/// - returns: the required changes required to change the passed in `from`
///   array into the passed in `to` array.
func changes<Item: DeltaItem where Item: Equatable>(from from: [Item], to: [Item]) -> [DeltaChange] {

  typealias DeltaCache = [Item.DeltaIdentifier: (index: Int, item: Item)]

  func added(to: [Item], fromCache: DeltaCache) -> [DeltaChange] {
    return to.enumerate().flatMap { (index, element) -> DeltaChange? in
      if fromCache[element.deltaIdentifier] == nil {
        return .Add(index: index)
      }
      return nil
    }
  }

  func removed(from: [Item], toCache: DeltaCache) -> [DeltaChange] {
    return from.enumerate().flatMap { (index, item) -> DeltaChange? in
      if let cacheEntry = toCache[item.deltaIdentifier] {
        if cacheEntry.item != item {
          return .Change(index: cacheEntry.index, from: index)
        }
        return nil
      }
      return .Remove(index: index)
    }
  }

  func moved(from: [Item], to: [Item], fromCache: DeltaCache, toCache: DeltaCache) -> [DeltaChange] {
    var delta = 0
    var processed: [Int: Int] = Dictionary()
    var records: [DeltaChange] = []

    for (index, item) in to.enumerate() {
      while true {
        if processed[index] != nil {
          delta -= 1
          break
        }

        let identifier = item.deltaIdentifier

        // Check if item is removed
        if fromCache[identifier] == nil {
          delta -= 1
          break
        }

        let compareIndex = index + delta
        let compareItem = from[compareIndex]
        let compareIdentifer = compareItem.deltaIdentifier

        // Check if item is added
        if toCache[compareIdentifer] == nil {
          delta += 1
          break
        }

        if compareIdentifer != identifier {
          delta += 1
          let finalIndex = toCache[compareIdentifer]!.index
          processed[finalIndex] = index
          records.append(.Move(index: finalIndex, from: compareIndex))
          continue
        }
        break
      }
    }
    
    return records
  }

  let fromCache = createItemCache(items: from)
  let toCache = createItemCache(items: to)
  precondition(fromCache.count == from.count, "Multiple models with the same `deltaIdentifier` found in the passed in sequence `from`")
  precondition(toCache.count == to.count, "Multiple models with the same `deltaIdentifier` found in the passed in sequence `to`")

  return removed(from, toCache: toCache) +
    added(to, fromCache: fromCache) +
    moved(from, to: to, fromCache: fromCache, toCache: toCache)
}

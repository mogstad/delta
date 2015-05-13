import Foundation

/**
The `DeltaProcessor` produces a set of records to transform a set of data into
another. This is ideal to perform updates to a collection view or table view.

The `DeltaProcessor` can optionally produce `update` records for changed items.
The default implementation assumes that changed records has the same `hashValue`
but is not equal. If this isn’t the case for your data structure you’re required
to subclass the DeltaProcessor’s `identifier` method and return an identical int
for each record that should be updated, this should usually be the hashValue of
your remote model identifier.

DeltaProcessor provides extensions to both UITableView and UICollectionView to
apply the delta records to a section in the view.
*/

public class DeltaProcessor<T: Hashable> {
  private typealias DeltaCache = [Int: T]
  private typealias Record = DeltaRecord<T>

  private let from: [T]
  private let to: [T]

  public init(from: [T], to: [T]) {
    self.from = from
    self.to = to
  }

  public func generate() -> [Record] {
    if self.from.count == 0 || self.to.count == 0 {
      return [DeltaRecord(type: .ReloadSection, item: nil, index: 0, fromIndex: 0)]
    }
    let fromLookup = self.itemLookup(self.from)
    let toLookup = self.itemLookup(self.to)

    let (removed, changed) = self.removed(toLookup)
    let added = self.added(fromLookup)
    let moved = self.moved(fromLookup, toCache: toLookup)
    return removed + added + moved + changed
  }

  private func moved(fromCache: DeltaCache, toCache: DeltaCache) -> [Record] {
    var delta = 0
    var processed: [Int: Int] = Dictionary()

    var fromIndexCache = self.createIndexCache(self.from)
    var toIndexCache = self.createIndexCache(self.to)

    var records: [Record] = []

    for (index, item) in enumerate(self.to) {
      while true {
        if processed[index] != nil {
          delta -= 1
          break
        }

        let identifier = self.identifier(item)

        // Check if item is removed
        if fromCache[identifier] == nil {
          delta -= 1
          break
        }

        let compareIndex = index + delta
        let compareItem = self.from[compareIndex]
        let compareIdentifer = self.identifier(compareItem)

        // Check if item is added
        if toCache[compareIdentifer] == nil {
          delta += 1
          break
        }

        if compareIdentifer != identifier {
          delta += 1
          let finalIndex = toIndexCache[compareIdentifer]!
          processed[finalIndex] = index
          let record = Record(
            type: .Move,
            item: compareItem,
            index: UInt(finalIndex),
            fromIndex: UInt(compareIndex))

          records.append(record)
          continue
        }
        break
      }
    }

    return records
  }

  private func createIndexCache(collection: [T]) -> [Int: Int] {
    var cache = Dictionary<Int, Int>()
    for (index, item) in enumerate(collection) {
      cache[self.identifier(item)] = index
    }
    return cache
  }

  private func itemLookup(items: [T]) -> DeltaCache {
    var cache: DeltaCache = Dictionary()
    for (index, item) in enumerate(items) {
      let identifier = self.identifier(item)
      cache[identifier] = item
    }
    return cache
  }

  private func removed(toCache: DeltaCache) -> ([Record], [Record]) {
    var removed = Array<Record>()
    var changed = Array<Record>()

    for (index, item) in enumerate(self.from) {
      let identifier = self.identifier(item)
      let cachedItem = toCache[identifier]
      if cachedItem == nil {
        let record = Record(
          type: .Remove,
          item: item,
          index: UInt(index))
        
        removed.append(record)
      } else if cachedItem != item {
        let record = Record(
          type: .Change,
          item: item,
          index: UInt(index))

        changed.append(record)
      }
    }
    return (removed, changed)
  }

  private func added(fromCache: DeltaCache) -> [Record] {
    var added = Array<Record>()

    for (index, element) in enumerate(self.to) {
      let identifier = self.identifier(element)
      if fromCache[identifier] == nil {
        let record = Record(
          type: .Add,
          item: element,
          index: UInt(index))

        added.append(record)
      }
    }
    return added
  }

  /// Overridable to add support for changed records
  private func identifier(item: T) -> Int {
    return item.hashValue
  }

}
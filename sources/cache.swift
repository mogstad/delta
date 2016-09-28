/// Creates a lookup cache, from an identifier and the item and its index in 
/// the original set.
/// - Complexity: O(n) average
///
/// - parameter items: A set of `DeltaItem`s
/// - returns: dictionary with the `deltaIdentifier` as the key, and a tuple 
///   with the index and the item itself as the value.
func createItemCache<Item: DeltaItem>(items: [Item]) -> [Item.DeltaIdentifier: (index: Int, item: Item)] {
  var cache: [Item.DeltaIdentifier: (index: Int, item: Item)] = [:]
  for (index, item) in items.enumerated() {
    cache[item.deltaIdentifier] = (index, item)
  }
  return cache
}

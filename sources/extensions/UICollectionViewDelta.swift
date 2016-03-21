import UIKit

public extension UICollectionView {
  
  public typealias CollectionViewUpdateCallback = (from: NSIndexPath, to: NSIndexPath) -> Void

  /// Perform updates on the collection view.
  ///
  /// - parameter records: Array of `CollectionRecord` to perform on the 
  ///   collection view.
  /// - parameter update: An update callback that will be invoked for each 
  ///   update record. It will be invoked with the old and the new index path.
  ///   Note: due to internals in UITableView’s and UICollecitonView’s we need
  ///   to query the cell using the old index path, and update the cell with 
  ///   data from the new index path.
  public func performUpdates(records: [CollectionRecord], update: CollectionViewUpdateCallback? = nil) {
    self.performBatchUpdates({
      for record in records {
        switch record {
        case let .AddItem(section, index):
          let indexPath = NSIndexPath(forRow: index, inSection: section)
          self.insertItemsAtIndexPaths([indexPath])
        case let .RemoveItem(section, index):
          let indexPath = NSIndexPath(forRow: index, inSection: section)
          self.deleteItemsAtIndexPaths([indexPath])
        case let .MoveItem(from, to):
          let indexPath = NSIndexPath(forRow: to.index, inSection: to.section)
          let fromIndexPath = NSIndexPath(forRow: from.index, inSection: from.section)
          self.moveItemAtIndexPath(fromIndexPath, toIndexPath: indexPath)
        case let .ChangeItem(from, to):
          let fromIndexPath = NSIndexPath(forRow: from.index, inSection: from.section)
          if let updateCallback = update {
            let toIndexPath = NSIndexPath(forRow: to.index, inSection: to.section)
            updateCallback(from: fromIndexPath, to: toIndexPath)
          } else {
            self.reloadItemsAtIndexPaths([fromIndexPath])
          }
        case let .ReloadSection(section):
          self.reloadSections(NSIndexSet(index: section))
        case let .MoveSection(section, from):
          self.moveSection(from, toSection: section)
        case let .AddSection(section):
          self.insertSections(NSIndexSet(index: section))
        case let .RemoveSection(section):
          self.deleteSections(NSIndexSet(index: section))
        }
      }
    }, completion: nil)
  }

}

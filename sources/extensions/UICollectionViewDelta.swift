import UIKit

public extension UICollectionView {
  
  public typealias CollectionViewUpdateCallback = (_ from: IndexPath, _ to: IndexPath) -> Void

  /// Perform updates on the collection view.
  ///
  /// - parameter records: Array of `CollectionRecord` to perform on the 
  ///   collection view.
  /// - parameter update: An update callback that will be invoked for each 
  ///   update record. It will be invoked with the old and the new index path.
  ///   Note: due to internals in UITableView’s and UICollecitonView’s we need
  ///   to query the cell using the old index path, and update the cell with 
  ///   data from the new index path.
  public func performUpdates(_ records: [CollectionRecord], update: CollectionViewUpdateCallback? = nil) {
    self.performBatchUpdates({
      for record in records {
        switch record {
        case let .addItem(section, index):
          let indexPath = IndexPath(row: index, section: section)
          self.insertItems(at: [indexPath])
        case let .removeItem(section, index):
          let indexPath = IndexPath(row: index, section: section)
          self.deleteItems(at: [indexPath])
        case let .moveItem(from, to):
          let indexPath = IndexPath(row: to.index, section: to.section)
          let fromIndexPath = IndexPath(row: from.index, section: from.section)
          self.moveItem(at: fromIndexPath, to: indexPath)
        case let .changeItem(from, to):
          let fromIndexPath = IndexPath(row: from.index, section: from.section)
          if let updateCallback = update {
            let toIndexPath = IndexPath(row: to.index, section: to.section)
            updateCallback(fromIndexPath, toIndexPath)
          } else {
            self.reloadItems(at: [fromIndexPath])
          }
        case let .reloadSection(section):
          self.reloadSections(IndexSet(integer: section))
        case let .moveSection(section, from):
          self.moveSection(from, toSection: section)
        case let .addSection(section):
          self.insertSections(IndexSet(integer: section))
        case let .removeSection(section):
          self.deleteSections(IndexSet(integer: section))
        }
      }
    }, completion: nil)
  }

}

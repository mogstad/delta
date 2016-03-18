import UIKit

public extension UICollectionView {
  
  public typealias CollectionViewUpdateCallback = (NSIndexPath, NSIndexPath) -> Void

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
        case let .ChangeItem(section, index, from):
          let indexPath = NSIndexPath(forRow: index, inSection: section)
          if let updateCallback = update {
            let newIndexPath = NSIndexPath(forRow: from, inSection: section)
            updateCallback(indexPath, newIndexPath)
          } else {
            self.reloadItemsAtIndexPaths([indexPath])
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

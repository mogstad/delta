import UIKit

public extension UICollectionView {
  
  public typealias CollectionViewUpdateCallback = (NSIndexPath, NSIndexPath) -> Void

  public func performUpdates(records: [DeltaCollectionRecord], updateCallback: CollectionViewUpdateCallback? = nil) {
    self.performBatchUpdates({
      for record in records {
        let indexPath = NSIndexPath(forItem: record.index, inSection: record.section)
        switch record.type {
        case .AddItem:
          self.insertItemsAtIndexPaths([indexPath])
        case .RemoveItem:
          self.deleteItemsAtIndexPaths([indexPath])
        case .MoveItem:
          let fromIndexPath = NSIndexPath(forItem: record.fromIndex, inSection: record.section)
          self.moveItemAtIndexPath(fromIndexPath, toIndexPath: indexPath)
        case .ChangeItem, .ReloadItem:
          if let updateCallback = updateCallback {
            let newIndexPath = NSIndexPath(forItem: record.fromIndex, inSection: record.section)
            updateCallback(indexPath, newIndexPath)
          } else {
            self.reloadItemsAtIndexPaths([indexPath])
          }
        case .AddSection:
          self.insertSections(NSIndexSet(index: record.index))
        case .RemoveSection:
          self.deleteSections(NSIndexSet(index: record.index))
        case .ReloadSection:
          self.reloadSections(NSIndexSet(index: record.section))
        case .MoveSection:
          self.moveSection(record.fromIndex, toSection: record.index)
        }
      }
    }, completion: nil)
  }





}
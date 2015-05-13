import UIKit

public extension UICollectionView {
  
  public typealias CollectionViewUpdateCallback = (NSIndexPath) -> Void
  public func performUpdates<T>(records: [DeltaRecord<T>], section: Int, updateCallback: CollectionViewUpdateCallback? = nil) {
    self.performBatchUpdates({
      for record in records {
        let indexPath = NSIndexPath(forItem: Int(record.index), inSection: section)
        switch record.type {
        case .Add:
          self.insertItemsAtIndexPaths([indexPath])
        case .Remove:
          self.deleteItemsAtIndexPaths([indexPath])
        case .Move:
          let fromIndexPath = NSIndexPath(forItem: Int(record.fromIndex), inSection: section)
          self.moveItemAtIndexPath(fromIndexPath, toIndexPath: indexPath)
        case .Change:
          if let updateCallback = updateCallback {
            updateCallback(indexPath)
          } else {
            self.reloadItemsAtIndexPaths([indexPath])
          }
        case .ReloadSection, .RemoveSection:
          self.reloadSections(NSIndexSet(index: section))
        }
      }
    }, completion: nil)
  }

}
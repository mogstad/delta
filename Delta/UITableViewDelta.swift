import UIKit

public extension UITableView {

  public func performUpdates<T>(records: [DeltaRecord<T>], section: Int) {
    for record in records {
      let indexPath = NSIndexPath(forRow: Int(record.index), inSection: section)
      switch record.type {
      case .Add:
        self.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      case .Remove:
        self.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      case .Move:
        let fromIndexPath = NSIndexPath(forRow: Int(record.fromIndex), inSection: section)
        self.moveRowAtIndexPath(fromIndexPath, toIndexPath: indexPath)
      case .Change:
        self.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      case .ReloadSection, .RemoveSection:
        self.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
      }
    }
  }
  
}
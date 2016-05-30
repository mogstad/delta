import UIKit

public extension UITableView {

  public typealias TableViewUpdateCallback = (from: NSIndexPath, to: NSIndexPath) -> Void

  /// Perform updates on the table view.
  ///
  /// - parameter records: Array of `CollectionRecord` to perform on the
  ///   table view.
  /// - parameter update: An update callback that will be invoked for each
  ///   update record. It will be invoked with the old and the new index path.
  ///   Note: due to internals in UITableView’s and UICollecitonView’s we need
  ///   to query the cell using the old index path, and update the cell with
  ///   data from the new index path.
  public func performUpdates(records: [CollectionRecord], update: TableViewUpdateCallback? = nil) {
    var changeRecords: [CollectionRecord] = []

    self.beginUpdates()
    for record in records {
      switch record {
      case let .AddItem(section, index):
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        self.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      case let .RemoveItem(section, index):
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        self.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      case let .MoveItem(from, to):
        let indexPath = NSIndexPath(forRow: to.index, inSection: to.section)
        let fromIndexPath = NSIndexPath(forRow: from.index, inSection: from.section)
        self.moveRowAtIndexPath(fromIndexPath, toIndexPath: indexPath)
      case let .ChangeItem(_, _):
        // A Move & Reload for a single cell cannot occur within the same 
        // update block (Causes a UIKit exception,) so we queue up the 
        // reloads to occur after all of the insertions
        changeRecords.append(record)
      case let .ReloadSection(section):
        self.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
      case let .MoveSection(section, from):
        self.moveSection(from, toSection: section)
      case let .AddSection(section):
        self.insertSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
      case let .RemoveSection(section):
        self.deleteSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
      }
    }
    self.endUpdates()

    if changeRecords.count > 0 {
      self.beginUpdates()
      for record in changeRecords {
        guard case let .ChangeItem(from, to) = record else {
          return fatalError("changeRecords can contain only .ChangeItem, not \(record)")
        }

        let indexPath = NSIndexPath(forRow: to.index, inSection: to.section)
        let fromIndexPath = NSIndexPath(forRow: from.index, inSection: from.section)
        if let updateCallback = update {
          updateCallback(from: fromIndexPath, to: indexPath)
        } else {
          self.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
      }
      self.endUpdates()
    }
  }
}

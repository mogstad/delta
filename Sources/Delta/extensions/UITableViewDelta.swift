import UIKit

public extension UITableView {

    typealias TableViewUpdateCallback = (_ from: IndexPath, _ to: IndexPath) -> Void

  /// Perform updates on the table view.
  ///
  /// - parameter records: Array of `CollectionRecord` to perform on the
  ///   table view.
  /// - parameter update: An update callback that will be invoked for each
  ///   update record. It will be invoked with the old and the new index path.
  ///   Note: due to internals in UITableView’s and UICollecitonView’s we need
  ///   to query the cell using the old index path, and update the cell with
  ///   data from the new index path.
    func performUpdates(_ records: [CollectionRecord], update: TableViewUpdateCallback? = nil) {
    var changeRecords: [CollectionRecord] = []

    self.beginUpdates()
    for record in records {
      switch record {
      case let .addItem(section, index):
        let indexPath = IndexPath(row: index, section: section)
        self.insertRows(at: [indexPath], with: .automatic)
      case let .removeItem(section, index):
        let indexPath = IndexPath(row: index, section: section)
        self.deleteRows(at: [indexPath], with: .automatic)
      case let .moveItem(from, to):
        let indexPath = IndexPath(row: to.index, section: to.section)
        let fromIndexPath = IndexPath(row: from.index, section: from.section)
        self.moveRow(at: fromIndexPath, to: indexPath)
      case .changeItem(_, _):
        // A Move & Reload for a single cell cannot occur within the same 
        // update block (Causes a UIKit exception,) so we queue up the 
        // reloads to occur after all of the insertions
        changeRecords.append(record)
      case let .reloadSection(section):
        self.reloadSections(IndexSet(integer: section), with: .automatic)
      case let .moveSection(section, from):
        self.moveSection(from, toSection: section)
      case let .addSection(section):
        self.insertSections(IndexSet(integer: section), with: .automatic)
      case let .removeSection(section):
        self.deleteSections(IndexSet(integer: section), with: .automatic)
      }
    }
    self.endUpdates()

    if changeRecords.count > 0 {
      self.beginUpdates()
      for record in changeRecords {
        guard case let .changeItem(from, to) = record else {
          fatalError("changeRecords can contain only .ChangeItem, not \(record)")
        }

        let indexPath = IndexPath(row: to.index, section: to.section)
        let fromIndexPath = IndexPath(row: from.index, section: from.section)
        if let updateCallback = update {
          updateCallback(fromIndexPath, indexPath)
        } else {
          self.reloadRows(at: [indexPath], with: .automatic)
        }
      }
      self.endUpdates()
    }
  }
}

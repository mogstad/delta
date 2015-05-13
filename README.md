# Delta

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

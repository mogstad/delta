# Delta

[![Build Status](https://img.shields.io/circleci/project/mogstad/delta.svg?style=flat-square)](https://circleci.com/gh/mogstad/delta)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Delta.svg?style=flat-square)](https://cocoapods.org/pods/Delta)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)

Handling animations and keeping track of changes manually can be very error-prone,
it’s easy to make a mistake, and the code gets very hard to follow. Delta makes 
it hassle-free to make sure this is right, and makes your app shine by using 
animations. Your views will finally be a visual representation of your data.

## Usage

One of Delta’s unique features is that it can determine changes. This is done by
checking equtablillity of the item and equatabillity of its identifier. If the
identifier is the same, but the model is no longer equatable, Delta generates a
change record which can be used to reload or manually update the cell.

### Basic

To use Delta your view model needs to conform to the protocol `DeltaItem`.

```swift
import Delta

struct TaskListItem: DeltaItem, Equatable {
  var deltaIdentifier: Int {
    return self.model.identifier
  }
  var model: Task
}

func ==(lhs: TaskListItem, rhs: TaskListItem) -> Bool {
  return lhs.model == rhs.model
}
```

We can then figure out the difference between two ordered set of our models.

```swift
let records = generateItemRecordsForSection(0, from: from, to: to)
```

We can use those records to animate a table view or a collection view:

```swift
tableView.performUpdates(records)
```

### Sectioned Data Structures

Delta also support generating records for sectioned data structure. As with
items, Delta requires the section to conform to a protocol; `DeltaSection`. Each
section has an identifier and an ordered set of items.

```swift
struct TaskListSection: DeltaSection {
  var deltaIdentifier: Int
  var items: TaskListItem
}
```

Determining the change and animating the change:

```swift
let records = generateRecordsForSections(from: self.data, to: data)
self.data = data
collectionView.performUpdates(records)
```

### Update Callback

The default behaviour when a change has occoured is to reload the cell. This
isn’t always desirable, Delta therefor allows you to pass in an update callback,
that will be invoked for each changed cell.

```swift
collectionView.performUpdates(records, update: { old, new in 
  if let cell = self.collectionView.cellForItemAtIndexPath(old) as? MyCollectionViewCell {
    cell.task = data[new.section].item[new.item]
  }
})
```

Note: due to internals in UITableView’s and UICollecitonView’s we need to query
the cell using the old index path, and update its data from the new index path.

## Install

Delta will be compatible with the lastest public release of Swift. Older
releases will be available, but bug fixes won’t be issued.

### [Carthage](https://github.com/carthage/carthage)

1. Add `github "mogstad/delta" ~> 2.0.0` to your “Cartfile”
2. Run `carthage update`
3. Link Delta with your target
4. Add Delta to your copy framework script phase

### [CocoaPods](https://cocoapods.org)

Update your podfile:

1. Add `use_frameworks!` to your pod file[^1]
2. Add `pod "Delta", "~> 2.0.0"` to your application target
3. Update your dependencies by running `pod install`

[^1]: Swift can’t be included as a static library, therefor it’s required to add
`use_frameworks!` to your `podfile`. It will then import your dependeices as
dynamic frameworks.

## License

Delta is released under the MIT license. See LICENSE for details.

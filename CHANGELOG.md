# Change Log

`Delta` adheres to [Semantic Versioning](http://semver.org/).

## [5.0.1] - 2018-08-24

### Fixed

- Prevent crash while generating change set while removing a record and moving 
  records with a higher index.

## [5.0.0] - 2018-03-28

- Compatibility for Swift 4.0

## [4.0.2] - 2016-04-01

### Fixed

- Resolve issue where `RemoveItem` record could use the incorrect section.

## [4.0.1] - 2016-03-22

### Fixed

- Fix issue where Change’s `from` and `to` arguments was assigned opposite,
  resulting in cascading issues.

## [4.0.0] - 2016-03-22

### Added

- Precondition making sure that multiple objects with the same identifier isn’t
  passed into delta.

### Fixed

- Return correct `from` index path in update callback.  

## [3.0.1] - 2016-03-19

### Added

- Added inline documentation for most of the public function, enums, and 
  protocols. “Getting started” guide and examples are next on the list.

## [3.0.0] - 2016-03-18

### Changed

- Everything; The API surface has completely changed. The API is now exposed 
  through public functions instead of a class that works like a function.
- Items are now required to confirm to either `DeltaItem` or `DeltaSection` for
  Delta to work. The old implementation used some horrible assumptions, that 
  might not be true.

### Fixed

- Prevents a crash when altering sections and moving items.

## [2.0.1] - 2015-10-09

### Added

- Limited compatibility for OS X

## [2.0.0] - 2015-09-15

### Changed

- Compatibility for Swift 2.0

## [0.1.1] - 2015-08-19

### Fixed

- Resolves an issue where a reload of a section triggered a reload of an item 
  instead.

## [0.1.0] - 2015-08-16

- Inital public release of Delta

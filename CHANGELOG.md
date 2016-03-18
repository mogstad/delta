# Change Log

`Delta` adheres to [Semantic Versioning](http://semver.org/).

## [3.0.0] - Unreleased

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
import Foundation

public protocol SectionedDataSection {

  typealias T
  var items: [T] { get }
  var sectionIdentifier: Int { get }

}

public class SectionedDataProcessor<Section: SectionedDataSection, Item: Hashable where Section: Hashable, Section.T == Item> {

  private let from: [Section]
  private let to: [Section]

  public init(from: [Section], to: [Section]) {
    self.from = from
    self.to = to
  }

  public func generate() -> [DeltaCollectionRecord] {
    return self.contentRecords() + self.sectionRecords()
  }

  private func sectionRecords() -> [DeltaCollectionRecord] {
    let delta = DeltaProcessor(from: self.from, to: self.to)
    return delta.generateForSections()
  }

  private func contentRecords() -> [DeltaCollectionRecord] {
    var cache = Dictionary<Int, (index: Int, section: Section)>()
    for (index, section) in self.from.enumerate() {
      cache[section.sectionIdentifier] = (index: index, section: section)
    }

    var itemRecords = Array<DeltaCollectionRecord>()
    for (index, section) in self.to.enumerate() {
      if let oldSection = cache[section.sectionIdentifier] {
        let records = self.compareSection(self.from[oldSection.index], to: self.to[index], section: index)
        itemRecords += records
      }
    }
    return itemRecords
  }

  private func compareSection(from: Section, to: Section, section: Int) -> [DeltaCollectionRecord] {
    let from = from.items
    let to = to.items
    let delta = DeltaProcessor<Item>(from: from, to: to)
    return delta.generateInSection(section)
  }
  
}

import Quick
import Nimble
@testable import Delta

struct Section: DeltaSection, Equatable {

  let identifier: Int
  let items: [Model]
  var deltaIdentifier: Int { return self.identifier }

  init(identifier: Int, items: [Model]) {
    self.identifier = identifier
    self.items = items
  }

}

func ==(lhs: Section, rhs: Section) -> Bool {
  return lhs.identifier == rhs.identifier && lhs.items == rhs.items
}

class SectionedDeltaProcessorSpec: QuickSpec {

  override func spec() {
    describe("SectionedDeltaProcessor") {
      describe("#generate") {
        var records: [CollectionRecord]!
        describe("adding section") {
          beforeEach {
            let first = Section(identifier: 1, items: [
              Model(identifier: 1)
            ])
            let second = Section(identifier: 2, items: [
              Model(identifier: 2)
            ])
            records = generateRecordsForSections(from: [first], to: [first, second])
          }
          it("works") {
            expect(records.count).to(equal(1))
            let record = CollectionRecord.AddSection(section: 1)
            expect(records[0]).to(equal(record))
          }
        }
        describe("adding models in section") {
          beforeEach {
            let from = Section(identifier: 1, items: [
              Model(identifier: 1)
              ])
            let to = Section(identifier: 1, items: [
              Model(identifier: 1),
              Model(identifier: 2)
            ])
            records = generateRecordsForSections(from: [from], to: [to])
          }
          it("works") {
            expect(records.count).to(equal(1))
            let record = CollectionRecord.AddItem(section: 0, index: 1)
            expect(records[0]).to(equal(record))
          }

        }
        describe("reloading section") {
          beforeEach {
            let section = Section(identifier: 0, items: [Model(identifier: 123)])
            let from = Section(identifier: 1, items: [
              Model(identifier: 1)
            ])
            let to = Section(identifier: 1, items: [])
            records = generateRecordsForSections(from: [section, from], to: [section, to])
          }
          it("reloads section when its models is or was null") {
            expect(records.count).to(equal(1))
            let record = CollectionRecord.ReloadSection(section: 1)
            expect(records[0]).to(equal(record))
          }
        }

        describe("empty") {
          beforeEach {
            records = generateRecordsForSections(from: Array<Section>(), to: Array<Section>())
          }

          it("works") {
            expect(records.count).to(equal(0))
          }
        }

        describe("Removing section") {
          beforeEach {
            let section = Section(identifier: 0, items: [Model(identifier: 123)])
            let from = Section(identifier: 1, items: [
              Model(identifier: 1)
            ])
            records = generateRecordsForSections(from: [section, from], to: [section])
          }
          it("removes section") {
            expect(records.count).to(equal(1))
            let record = CollectionRecord.RemoveSection(section: 1)
            expect(records[0]).to(equal(record))
          }
        }

        describe("Moving a section") {
          beforeEach {
            let section = Section(identifier: 0, items: [Model(identifier: 123)])
            let from = Section(identifier: 1, items: [
              Model(identifier: 1)
            ])

            records = generateRecordsForSections(from: [section, from], to: [from, section])
          }
          it("removes section") {
            expect(records.count).to(equal(1))
            let record = CollectionRecord.MoveSection(section: 1, from: 0)
            expect(records[0]).to(equal(record))
          }
        }
      }
    }
  }

}

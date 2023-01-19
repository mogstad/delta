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
            let record = CollectionRecord.addSection(section: 1)
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
            let record = CollectionRecord.addItem(section: 0, index: 1)
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
            let record = CollectionRecord.reloadSection(section: 1)
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
            let record = CollectionRecord.removeSection(section: 1)
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
          it("moves section") {
            expect(records.count).to(equal(1))
            let record = CollectionRecord.moveSection(section: 1, from: 0)
            expect(records[0]).to(equal(record))
          }
        }

        describe("Removing section and insert item") {
          beforeEach {
            let from = [
              Section(identifier: 0, items: [Model(identifier: 128)]),
              Section(identifier: 1, items: [Model(identifier: 512)]),
              Section(identifier: 2, items: [Model(identifier: 1024)]),
              Section(identifier: 3, items: [Model(identifier: 2048)]),
            ]

            let to = [
              Section(identifier: 1, items: [
                Model(identifier: 512),
                Model(identifier: 4096)
              ]),
              Section(identifier: 2, items: [Model(identifier: 1024)]),
              Section(identifier: 3, items: [Model(identifier: 2048)]),
            ]
            records = generateRecordsForSections(from: from, to: to)
          }

          it("generates records") {
            expect(records.count).to(equal(2))
          }

          it("removes section") {
            let record = CollectionRecord.removeSection(section: 0)
            expect(records[1]).to(equal(record))
          }

          it("adds item record") {
            let record = CollectionRecord.addItem(section: 0, index: 1)
            expect(records[0]).to(equal(record))
          }
        }

        describe("Inserting section and item") {
          beforeEach {
            let from = [
              Section(identifier: 1, items: [Model(identifier: 512)])
            ]

            let to = [
              Section(identifier: 0, items: [Model(identifier: 128)]),
              Section(identifier: 1, items: [
                Model(identifier: 512),
                Model(identifier: 4096)
              ])
            ]
            records = generateRecordsForSections(from: from, to: to)
          }

          it("generates records") {
            expect(records.count).to(equal(2))
          }

          it("adds section") {
            let record = CollectionRecord.addSection(section: 0)
            expect(records[1]).to(equal(record))
          }

          it("adds item record") {
            let record = CollectionRecord.addItem(section: 1, index: 1)
            expect(records[0]).to(equal(record))
          }
        }

        describe("Moving items and removing section") {
          beforeEach {
            let from = [
              Section(identifier: 0, items: [Model(identifier: 128)]),
              Section(identifier: 1, items: [Model(identifier: 512), Model(identifier: 2048)]),
              Section(identifier: 2, items: [Model(identifier: 1024)]),
            ]

            let to = [
              Section(identifier: 1, items: [
                Model(identifier: 2048),
                Model(identifier: 512),
              ]),
              Section(identifier: 2, items: [Model(identifier: 1024)]),
            ]
            records = generateRecordsForSections(from: from, to: to)
          }

          it("generates records") {
            expect(records.count).to(equal(2))
          }

          it("removes section") {
            let record = CollectionRecord.removeSection(section: 0)
            expect(records[1]).to(equal(record))
          }

          it("creates move record") {
            let record = CollectionRecord.moveItem(
              from: (section: 1, index: 0),
              to: (section: 0, index: 1))

            expect(records[0]).to(equal(record))
          }
        }

        describe("Change records with section changes") {
          beforeEach {
            let from = [
              Section(identifier: 1, items: [
                Model(identifier: 512, count: 2),
                ])
            ]

            let to = [
              Section(identifier: 0, items: [Model(identifier: 64)]),
              Section(identifier: 1, items: [
                Model(identifier: 512, count: 4),
                ]),
            ]
            records = generateRecordsForSections(from: from, to: to)
          }

          it("generates records") {
            expect(records.count).to(equal(2))
          }

          it("adds section") {
            let record = CollectionRecord.addSection(section: 0)
            expect(records[1]).to(equal(record))
          }

          it("creates change record") {
            let record = CollectionRecord.changeItem(
              from: (section: 0, index: 0),
              to: (section: 1, index: 0))

            expect(records[0]).to(equal(record))
          }
        }

        describe("Change records combined with remove item in same section") {
          beforeEach {
            let from = [
              Section(identifier: 1, items: [
                Model(identifier: 64),
                Model(identifier: 512, count: 2)
              ])
            ]

            let to = [
              Section(identifier: 1, items: [
                Model(identifier: 512, count: 1)
              ])
            ]
            records = generateRecordsForSections(from: from, to: to)
          }

          it("generates records") {
            expect(records.count).to(equal(2))
          }

          it("removes item") {
            let record = CollectionRecord.removeItem(section: 0, index: 0)
            expect(records[0]).to(equal(record))
          }

          it("creates change record") {
            let record = CollectionRecord.changeItem(
              from: (section: 0, index: 1),
              to: (section: 0, index: 0))

            expect(records[1]).to(equal(record))
          }
        }

        describe("Adding section and removing item") {
          beforeEach {
            let from = [
              Section(identifier: 1, items: [
                Model(identifier: 512),
                Model(identifier: 2048)
              ])
            ]

            let to = [
              Section(identifier: 0, items: [Model(identifier: 64)]),
              Section(identifier: 1, items: [
                Model(identifier: 512),
              ]),
            ]
            records = generateRecordsForSections(from: from, to: to)
          }

          it("generates records") {
            expect(records.count).to(equal(2))
          }

          it("created add section record") {
            let record = CollectionRecord.addSection(section: 0)
            expect(records[1]).to(equal(record))
          }

          it("creates remove item record") {
            let record = CollectionRecord.removeItem(section: 0, index: 1)
            expect(records[0]).to(equal(record))
          }
        }

        describe("Removing section and removing item") {
          beforeEach {
            let from = [
              Section(identifier: 0, items: [Model(identifier: 64)]),
              Section(identifier: 1, items: [
                Model(identifier: 512),
                Model(identifier: 2048)
                ])
            ]

            let to = [
              Section(identifier: 1, items: [
                Model(identifier: 512),
                ]),
            ]
            records = generateRecordsForSections(from: from, to: to)
          }

          it("generates records") {
            expect(records.count).to(equal(2))
          }

          it("created add section record") {
            let record = CollectionRecord.removeSection(section: 0)
            expect(records[1]).to(equal(record))
          }

          it("creates remove item record") {
            let record = CollectionRecord.removeItem(section: 1, index: 1)
            expect(records[0]).to(equal(record))
          }
        }

        describe("Moving items and adding section") {
          beforeEach {
            let from = [
              Section(identifier: 1, items: [
                Model(identifier: 512),
                Model(identifier: 2048)
              ])
            ]

            let to = [
              Section(identifier: 0, items: [Model(identifier: 64)]),
              Section(identifier: 1, items: [
                Model(identifier: 2048),
                Model(identifier: 512),
              ]),
            ]
            records = generateRecordsForSections(from: from, to: to)
          }

          it("generates records") {
            expect(records.count).to(equal(2))
          }

          it("adds section") {
            let record = CollectionRecord.addSection(section: 0)
            expect(records[1]).to(equal(record))
          }

          it("creates move record") {
            let record = CollectionRecord.moveItem(
              from: (section: 0, index: 0),
              to: (section: 1, index: 1))

            expect(records[0]).to(equal(record))
          }
        }
      }
    }
  }

}

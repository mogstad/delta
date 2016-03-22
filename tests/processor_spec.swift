import Foundation
import Quick
import Nimble
@testable import Delta

struct Model: DeltaItem, Equatable {
  var identifier: Int
  var count: Int
  var deltaIdentifier: Int { return self.identifier }
  init(identifier: Int, count: Int = 0) {
    self.identifier = identifier
    self.count = count
  }
}

func ==(lhs: Model, rhs: Model) -> Bool {
  return lhs.identifier == rhs.identifier && lhs.count == rhs.count
}

class DeltaProcessorSpec: QuickSpec {

  override func spec() {
    describe("changes(from, to)") {
      var records: [DeltaChange]!
      describe("Adding nodes") {
        beforeEach {
          let from = [Model(identifier: 1)]
          let to = [Model(identifier: 1), Model(identifier: 2)]
          records = self.records(from, to: to)
          expect(records.count).to(equal(1))
        }

        it("creates “add” record") {
          let record = DeltaChange.Add(index: 1)
          expect(records[0]).to(equal(record))
        }
      }

      describe("Removing nodes") {
        beforeEach {
          let from = [Model(identifier: 1), Model(identifier: 2)]
          let to = [Model(identifier: 1)]
          records = self.records(from, to: to)
          expect(records.count).to(equal(1))
        }

        it("creates “remove” record") {
          let record = DeltaChange.Remove(index: 1)
          expect(records[0]).to(equal(record))
        }
      }

      describe("Changing nodes") {
        beforeEach {
          let from = [Model(identifier: 1, count: 10)]
          let to = [Model(identifier: 1, count: 5)]
          records = self.records(from, to: to)
          expect(records.count).to(equal(1))
        }

        it("creates “change” record") {
          let record = DeltaChange.Change(index: 0, from: 0)
          expect(records[0]).to(equal(record))
        }
      }

      describe("Changing a node and removing a node") {
        beforeEach {
          let from = [
            Model(identifier: 0),
            Model(identifier: 1, count: 10)
          ]

          let to = [
            Model(identifier: 1, count: 5)
          ]

          records = self.records(from, to: to)
          expect(records.count).to(equal(2))
        }

        it("creates “remove” record") {
          let record = DeltaChange.Remove(index: 0)
          expect(records[0]).to(equal(record))
        }

        it("creates “change” record") {
          let record = DeltaChange.Change(index: 0, from: 1)
          expect(records[1]).to(equal(record))
        }
      }

      describe("Removing and adding") {
        beforeEach {
          let from = [Model(identifier: 16) ,Model(identifier: 64), Model(identifier: 32)]
          let to = [Model(identifier: 16), Model(identifier: 256), Model(identifier: 32)]
          records = self.records(from, to: to)
          expect(records.count).to(equal(2))
        }

        it("creates “remove” record") {
          let record = DeltaChange.Remove(index: 1)
          expect(records[0]).to(equal(record))
        }

        it("creates “add” record") {
          let record = DeltaChange.Add(index: 1)
          expect(records[1]).to(equal(record))
        }
      }

      describe("Moving a record in a set") {
        beforeEach {
          let from = [Model(identifier: 1), Model(identifier: 3), Model(identifier: 2)]
          let to = [Model(identifier: 1), Model(identifier: 2), Model(identifier: 3)]
          records = self.records(from, to: to)
          expect(records.count).to(equal(1))
        }

        it("creates “move” record") {
          let record = DeltaChange.Move(index: 2, from: 1)
          expect(records[0]).to(equal(record))
        }

      }

      describe("Moving multiple items in a set set") {
        beforeEach {
          let from = [
            Model(identifier: 1),
            Model(identifier: 3),
            Model(identifier: 6),
            Model(identifier: 2),
            Model(identifier: 5),
            Model(identifier: 4)
          ]
          let to = [
            Model(identifier: 1),
            Model(identifier: 2),
            Model(identifier: 3), 
            Model(identifier: 4), 
            Model(identifier: 5), 
            Model(identifier: 6)
          ]
          records = self.records(from, to: to)
          expect(records.count).to(equal(3))
        }

        it("moves the record") {

          let record = DeltaChange.Move(index: 2, from: 1)
          let record1 = DeltaChange.Move(index: 5, from: 2)
          let record2 = DeltaChange.Move(index: 4, from: 4)

          expect(records[0]).to(equal(record))
          expect(records[1]).to(equal(record1))
          expect(records[2]).to(equal(record2))
        }
      }

      describe("Moving an item and appending an item") {
        beforeEach {
          let from = [
            Model(identifier: 1),
            Model(identifier: 3),
            Model(identifier: 6)
          ]

          let to = [
            Model(identifier: 4),
            Model(identifier: 1),
            Model(identifier: 6),
            Model(identifier: 3)
          ]

          records = self.records(from, to: to)
          expect(records.count).to(equal(2))
        }

        it("moves the record") {
          let record = DeltaChange.Move(index: 3, from: 1)
          expect(records[1]).to(equal(record))
        }
      }

      describe("Removing an item and appending another item") {
        beforeEach {
          let from = [
            Model(identifier: 4),
            Model(identifier: 1),
            Model(identifier: 3),
            Model(identifier: 6)
          ]
          let to = [
            Model(identifier: 1),
            Model(identifier: 6),
            Model(identifier: 3)
          ]

          records = self.records(from, to: to)
          expect(records.count).to(equal(2))
        }

        it("moves the record") {
          let record = DeltaChange.Move(index: 2, from: 2)
          expect(records[1]).to(equal(record))
        }
      }
    }
  }

  private func records(from: [Model], to: [Model]) -> [DeltaChange] {
    return changes(from: from, to: to)
  }

}

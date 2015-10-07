import Foundation
import Quick
import Nimble
@testable import Delta

class DeltaProcessorSpec: QuickSpec {

  override func spec() {
    describe("Delta") {
      var records: [DeltaRecord<NSNumber>]!
      describe("Adding nodes") {
        beforeEach {
          let from: [NSNumber] = [1]
          let to: [NSNumber] = [1,2]
          records = self.records(from, to: to)
          expect(records.count).to(equal(1))
        }

        it("creates “add” record") {
          let record = DeltaRecord<NSNumber>(type: .Add, item: NSNumber(integer: 2), index: 1)
          expect(records[0]).to(equal(record))
        }
      }

      describe("Removing nodes") {
        beforeEach {
          let from: [NSNumber] = [1,2]
          let to: [NSNumber] = [1]
          records = self.records(from, to: to)
          expect(records.count).to(equal(1))
        }

        it("creates “remove” record") {
          let record = DeltaRecord<NSNumber>(type: .Remove, item: NSNumber(integer: 2), index: 1)
          expect(records[0]).to(equal(record))
        }
      }

      describe("Removing and adding") {
        beforeEach {
          let from: [NSNumber] = [16,64,32]
          let to: [NSNumber] = [16,256,32]
          records = self.records(from, to: to)
          expect(records.count).to(equal(2))
        }

        it("creates “remove” record") {
          let record = DeltaRecord<NSNumber>(
            type: .Remove,
            item: NSNumber(integer: 64),
            index: 1)

          expect(records[0]).to(equal(record))
        }

        it("creates “add” record") {
          let record = DeltaRecord<NSNumber>(
            type: .Add,
            item: NSNumber(integer: 256),
            index: 1)

          expect(records[1]).to(equal(record))
        }
      }

      describe("Moving a record in a set set") {
        beforeEach {
          let from: [NSNumber] = [1,3,2]
          let to: [NSNumber] = [1,2,3]
          records = self.records(from, to: to)
          expect(records.count).to(equal(1))
        }

        it("creates “move” record") {
          let record = DeltaRecord<NSNumber>(
            type: .Move,
            item: NSNumber(integer: 3),
            index: 2,
            fromIndex: 1)

          expect(records[0]).to(equal(record))
        }

      }

      describe("Moving multiple items in a set set") {
        beforeEach {
          let from: [NSNumber] = [1,3,6,2,5,4]
          let to: [NSNumber] = [1,2,3,4,5,6]

          records = self.records(from, to: to)
          expect(records.count).to(equal(3))
        }

        it("moves the record") {
          let record = DeltaRecord<NSNumber>(
            type: .Move,
            item: NSNumber(integer: 3),
            index: 2,
            fromIndex: 1)

          let record1 = DeltaRecord<NSNumber>(
            type: .Move,
            item: NSNumber(integer: 6),
            index: 5,
            fromIndex: 2)

          let record2 = DeltaRecord<NSNumber>(
            type: .Move,
            item: NSNumber(integer: 5),
            index: 4,
            fromIndex: 4)

          expect(records[0]).to(equal(record))
          expect(records[1]).to(equal(record1))
          expect(records[2]).to(equal(record2))
        }
      }

      describe("Moving an item and appending an item") {
        beforeEach {
          let from: [NSNumber] = [1,3,6]
          let to: [NSNumber] = [4,1,6,3]

          records = self.records(from, to: to)
          expect(records.count).to(equal(2))
        }

        it("moves the record") {
          let record = DeltaRecord<NSNumber>(
            type: .Move,
            item: NSNumber(integer: 3),
            index: 3,
            fromIndex: 1)

          expect(records[1]).to(equal(record))
        }
      }

      describe("Removing an item and appending another item") {
        beforeEach {
          let from: [NSNumber] = [4,1,3,6]
          let to: [NSNumber] = [1,6,3]

          records = self.records(from, to: to)
          expect(records.count).to(equal(2))
        }

        it("moves the record") {
          let record = DeltaRecord<NSNumber>(
            type: .Move,
            item: NSNumber(integer: 3),
            index: 2,
            fromIndex: 2)

          expect(records[1]).to(equal(record))
        }
      }
    }
  }

  private func records(from: [NSNumber], to: [NSNumber]) -> [DeltaRecord<NSNumber>] {
    let delta = DeltaProcessor<NSNumber>(from: from, to: to)
    return delta.generate()
  }

}

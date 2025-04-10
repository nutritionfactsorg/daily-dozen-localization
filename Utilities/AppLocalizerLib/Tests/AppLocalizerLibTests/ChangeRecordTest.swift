//
//  ChangeRecordTest.swift
//  AppLocalizerLib
//

import Testing

struct Record {
    let key: String
    var indexPrior: Int! = nil
    var indexNext: Int! = nil
    
    var indexPart: Int {
        let regex = #/(\.\d+)$/#
        if let match = try? regex.firstMatch(in: key) {
            return Int(match.1) ?? 0
        }
        return 0
    }
    
    init(_ keyIn: String, isPrior: Bool) {
        self.key = keyIn
        if isPrior {
            self.indexPrior = self.indexPart
            self.indexNext = nil
        } else {
            self.indexPrior = nil
            self.indexNext = self.indexPart
        }
    }
    
    var namePart: String {
        let regex = #/^(.*)\.\d+$/#
        if let match = try? regex.firstMatch(in: key) {
            return String(match.1)
        }
        return key
    }
}

extension Record: Equatable {
    static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.key == rhs.key &&
               lhs.indexPrior == rhs.indexPrior &&
               lhs.indexNext == rhs.indexNext
    }
}

func insertRecords(existing: [Record], insert: [Record]) -> [Record] {
    var updatedRecords = existing
    for recordToInsert in insert {
        if let insertionIndex = updatedRecords.firstIndex(where: { existingRecord in
            let namesMatch = existingRecord.namePart == recordToInsert.namePart
            let indicesMatch = existingRecord.indexPrior == recordToInsert.indexNext
            return namesMatch && indicesMatch
        }) {
            updatedRecords.insert(recordToInsert, at: insertionIndex)
        }
    }
    return updatedRecords.sorted(by: { $0.key < $1.key })
}

func deleteRecords(existing: [Record], delete: [Record]) -> [Record] {
    var updatedRecords = existing
    for recordToDelete in delete {
        if let indexToRemove = updatedRecords.firstIndex(where: { existingRecord in
            let namesMatch = existingRecord.namePart == recordToDelete.namePart
            let indicesMatch = existingRecord.indexPrior == recordToDelete.indexPrior
            return namesMatch && indicesMatch
        }) {
            updatedRecords.remove(at: indexToRemove)
        }
    }
    return updatedRecords.sorted(by: { $0.key < $1.key })
}

func reindexRecords(_ recordList: [Record]) -> [Record] {
    var groupedRecords: [String: [Record]] = [:]
    for record in recordList {
        groupedRecords[record.namePart, default: []].append(record)
    }
    
    var reindexedRecords: [Record] = []
    for (namePart, records) in groupedRecords {
        let sortedRecords = records.sorted { $0.key < $1.key }
        for (newIndex, record) in sortedRecords.enumerated() {
            let newKey = "\(namePart).\(newIndex)"
            let isPrior = record.indexPrior != nil
            let reindexedRecord = Record(newKey, isPrior: isPrior)
            reindexedRecords.append(reindexedRecord)
        }
    }
    return reindexedRecords.sorted { $0.key < $1.key }
}

@Test("keyParts Text")
func testKeyParts() {
    let key = "a.b.2.81"
    
    let regex = #/^(.*)\.(\d+)$/#
    if let match = try? regex.firstMatch(in: key) {
        print("match.1 = \(match.1)")
        print("match.2 = \(match.2)")
    }
}

@Test("Record Operations Test")
func testRecordOperations() {
    // Step 1: Generate test data
    let existingRecordList = [
        Record("nameA.0", isPrior: true),
        Record("nameA.1", isPrior: true),
        Record("nameB.0", isPrior: true),
        Record("nameB.1", isPrior: true),
        Record("nameB.2", isPrior: true),
        Record("nameB.3", isPrior: true),
        Record("nameB.4", isPrior: true),
        Record("nameC.0", isPrior: true),
        Record("nameC.1", isPrior: true)
    ]
    
    let insertRecordList = [
        Record("nameB.1", isPrior: false),
        Record("nameB.3", isPrior: false)
    ]
    
    let deleteRecordList = [
        Record("nameB.0", isPrior: true),
        Record("nameB.1", isPrior: true),
        Record("nameC.0", isPrior: true)
    ]
    
    // Step 2: Apply operations in sequence
    let afterInsert = insertRecords(existing: existingRecordList, insert: insertRecordList)
    let afterDelete = deleteRecords(existing: afterInsert, delete: deleteRecordList)
    let finalResult = reindexRecords(afterDelete)
    
    // Step 3: Verify the final result
    let expectedResult = [
        Record("nameA.0", isPrior: true),  // (0, nil)
        Record("nameA.1", isPrior: true),  // (1, nil)
        Record("nameB.0", isPrior: false), // (nil, 0)
        Record("nameB.1", isPrior: true),  // (1, nil)
        Record("nameB.2", isPrior: false), // (nil, 2)
        Record("nameB.3", isPrior: true),  // (3, nil)
        Record("nameB.4", isPrior: true),  // (4, nil)
        Record("nameC.0", isPrior: true)   // (0, nil)
    ]
    
    #expect(finalResult == expectedResult, "The reindexed result does not match the expected output")
}

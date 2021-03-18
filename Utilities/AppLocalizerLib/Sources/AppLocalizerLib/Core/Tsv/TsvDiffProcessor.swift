//
//  TsvDiffProcessor.swift
//  AppLocalizerLib
//

import Foundation

/// TsvDiffProcessor
///
/// Scope: difference detection is only based on `key_apple&key_android` primary key
/// 
/// Consider "A" is typically the reference e.g. English_US.
/// Consider "B" as the target which may needs to be adjusted. 
/// 
/// File Output: "B" url is used as the basis for file output.
///
struct TsvDiffProcessor {
    
    let urlListAa: [URL]
    let urlListBb: [URL]
    //
    let tsvAa: TsvSheet
    let tsvBb: TsvSheet
    
    init(aList: [URL], bList: [URL]) {
        guard aList.count > 0 && bList.count > 0 else {
            fatalError("TsvDiffProcessor init expects at least 1 url for A and B sides.")
        }
        urlListAa = aList
        urlListBb = bList
        tsvAa = TsvSheet(urlList: urlListAa)
        tsvBb = TsvSheet(urlList: urlListBb)
    }
    
    func doDiffKeys() {
        let keysPrimaryAa = tsvAa.getKeySetPrimary()
        let keysPrimaryBb = tsvBb.getKeySetPrimary()
        
        let onlyInAa = keysPrimaryAa.subtracting(keysPrimaryBb)
        let onlyInBb = keysPrimaryBb.subtracting(keysPrimaryAa)
        printKeyDiff(onlyInA: onlyInAa, onlyInB: onlyInBb)
        saveKeyDiff(onlyInA: onlyInAa, onlyInB: onlyInAa)
    }
    
    private func printKeyDiff(onlyInA: Set<String>, onlyInB: Set<String>) {
        let onlyInAList = Array(onlyInA).sorted()
        let onlyInBList = Array(onlyInB).sorted()
        
        var s = 
            """
            ****************
            ***** DIFF *****
            ****************
            """
        for i in 0 ..< urlListAa.count {
            let url = urlListAa[i]
            s.append("** A:\(i): \(url.path)")
        }
        for i in 0 ..< urlListBb.count {
            let url = urlListBb[i]
            s.append("** B:\(i): \(url.path)")
        }
        s.append(
            """
            *****
            *** A Unique\n
            """
        )
        for id in onlyInAList {
            s.append("\(id)\n")
        }
        s.append(
            """
            *****
            *** B Unique\n
            """
        )
        for id in onlyInBList {
            s.append("\(id)\n")
        }
        s.append(
            """
            *****
            """
        )
        print(s)
    }
    
    func saveKeyDiff(onlyInA: Set<String>, onlyInB: Set<String>) {
        let onlyInAaKeyList = Array(onlyInA).sorted()
        let onlyInBbKeyList = Array(onlyInB).sorted()
        
        var onlyInAaTsvRowList = TsvRowList()
        var onlyInBbTsvRowList = TsvRowList()
        
        for key in onlyInAaKeyList {
            if let row = tsvAa.tsvRowList.get(key: key, keyType: .primary) {
                onlyInAaTsvRowList.append(row)
            }
        }        
        for key in onlyInBbKeyList {
            if let row = tsvBb.tsvRowList.get(key: key, keyType: .primary) {
                onlyInBbTsvRowList.append(row)
            }
        }
        
        let name = urlListBb[0].lastPathComponent.components(separatedBy: ".")[0]
        let url =  urlListBb[0].deletingLastPathComponent()

        let urlAdditions = url.appendingPathComponent("\(name).additions.tsv", isDirectory: false)
        let urlDeletions = url.appendingPathComponent("\(name).deletions.tsv", isDirectory: false)

        onlyInAaTsvRowList.writeTsvFile(urlAdditions)
        onlyInBbTsvRowList.writeTsvFile(urlDeletions)
    }
    
}

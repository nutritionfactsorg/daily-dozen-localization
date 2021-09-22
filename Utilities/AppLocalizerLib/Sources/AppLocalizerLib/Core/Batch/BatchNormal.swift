//
//  BatchNormal.swift
//  
//

import Foundation

struct BatchNormal {
 
    static var shared = BatchNormal()

    func doNormalize(inputXLIFF: URL) {
        // to TSV
        let xliff = XliffIntoTsvProcessor(url: inputXLIFF)
        
        // to .strings file
        let outputUrl = inputXLIFF.deletingPathExtension().appendingPathExtension("strings")
        let stringz = StringzProcessor(tsvRowList: xliff.tsvRowList)
        let s = stringz.toString()
        do {
            try s.write(to: outputUrl, atomically: false, encoding: .utf8)
        } catch {
            print("ERROR: failed to write \(outputUrl.path) \(error)")
        }
    }
    
}

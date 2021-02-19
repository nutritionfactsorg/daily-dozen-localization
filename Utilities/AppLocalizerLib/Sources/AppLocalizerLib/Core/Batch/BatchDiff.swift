//
//  BatchDiff.swift
//  AppLocalizerLib
//

import Foundation

struct BatchDiff {
    static var shared = BatchDiff()

    func doDiffKeys(xmlUrlA: URL?, xmlUrlB: URL?, xliffUrlA: URL?, xliffUrlB: URL?) {
        if let diffXmlA = xmlUrlA, let diffXmlB = xmlUrlB {
            let processor = XmlDiffProcessor.init(a: diffXmlA, b: diffXmlB)
            processor.doDiffKeys()
        }
        if let diffXliffA = xliffUrlA, let diffXliffB = xliffUrlB {
            let processor = XliffDiffProcessor(a: diffXliffA, b: diffXliffB)
            processor.doDiffKeys()
        }
    }
        
}

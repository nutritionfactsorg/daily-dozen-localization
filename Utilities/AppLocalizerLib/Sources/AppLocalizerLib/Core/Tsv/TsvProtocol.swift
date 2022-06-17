//
//  TsvProtocol.swift
//  AppLocalizerLib
//

import Foundation

enum TsvBaseOrLangMode {
    case baseMode
    case langMode
}

enum TsvKeyType {
    case apple
    case droid
    case primary // `key_apple&key_android`
}

enum TsvValueType {
    case base // `base_value` English
    case lang // `lang_value` target language
    case noteBase // `base_note`
    case noteLang // `lang_note`
}

enum TsvPutMode {
    // case appendMerge
    // case prependMerge
    case doNotOverwrite /// only write source to empty target values
    case verbatim /// empty source clears target value. removes completely empty result.
}

protocol TsvProtocol {
    
    var tsvRowList: TsvRowList { get set }
        
    // MARK: - Operations
    
    func applyingValues(from: TsvRowList, withKeyType: TsvKeyType, ofValueType: TsvValueType) -> TsvRowList
    func applyingValues(from: TsvRowList, withKeyType: TsvKeyType, ofValueTypes: [TsvValueType]) -> TsvRowList
    func applyingValues(from: TsvRowList, withKeyValueTypes: [(keyType: TsvKeyType, valueType: TsvValueType)]) -> TsvRowList
    
    func diffKeys(_ other: TsvRowList, byKeyType: TsvKeyType) -> (added: TsvRowList, dropped: TsvRowList)

    // MARK: - Output
    
    func toStringDot(rowIdx: Int) -> String
    func toTsv(rowIdx: Int) -> String
    func toTsv() -> String
    
    func writeTsvFile(_ url: URL)
}

extension TsvProtocol {

    // MARK: - Operations: implementation
    
    func applyingValues(from: TsvRowList, withKeyType: TsvKeyType, ofValueType: TsvValueType) -> TsvRowList {
        return tsvRowList.applyingValues(from: from, withKeyType: withKeyType, ofValueType: ofValueType)
    }
    
    func applyingValues(from: TsvRowList, withKeyType: TsvKeyType, ofValueTypes: [TsvValueType]) -> TsvRowList {
        return tsvRowList.applyingValues(from: from, withKeyType: withKeyType, ofValueTypeList: ofValueTypes)
    }
    
    func applyingValues(from: TsvRowList, withKeyValueTypes: [(keyType: TsvKeyType, valueType: TsvValueType)]) -> TsvRowList {
        return tsvRowList.applyingValues(from: from, withKeyValueTypes: withKeyValueTypes)
    }
    
    func diffKeys(_ other: TsvRowList, byKeyType: TsvKeyType) -> (added: TsvRowList, dropped: TsvRowList) {
        return tsvRowList.diffKeys(other, byKeyType: byKeyType)
    }
    
    // MARK: - Output: implementation
    
    func toStringDot(rowIdx: Int) -> String {
        return tsvRowList.toStringDot(rowIdx: rowIdx)
    }
    
    func toStringDot(rowIdxRange: Range<Int>) -> String {
        return tsvRowList.toStringDot(rowIdxRange: rowIdxRange)
    }
    
    func toStringDot(find: String, limit: Int? = nil) -> String {
        return tsvRowList.toStringDot(find: find, limit: limit)
    }
    
    func toTsv(rowIdx: Int) -> String {
        return tsvRowList.toTsv(rowIdx: rowIdx)
    }
    
    func toTsv() -> String {
        return tsvRowList.toTsv()
    } 

    func writeTsvFile(_ url: URL) {
        tsvRowList.writeTsvFile(url)
    }
    
}

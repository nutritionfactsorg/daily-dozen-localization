//
//  TsvImportSheet.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvImportSheet {
    var recordList: [TsvImportRow] = []
    var log = LogService()
    
    init(url: URL) {
        log.logLevel = .verbose
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            // .split(whereSeparator: (Character) throws -> Bool)
            // Value of type 'String.Element' (aka 'Character') has no member 'isNewLine'
            
            if content.count < 100 {
                print(":ERROR: TsvImportSheet did not init with \(url.absoluteString)")
                return
            }
            
            var characterPrev: Character?
                    
            var insideQuote = false
            var escapeQuote = false
            var record: [[Character]] = []
            var field: [Character] = []
            var countChar = 0
            var countLine = 1
            var countLineChar = 0
            for character in content {
                countChar += 1
                countLineChar += 1
                //
                var statusDetail = ""
                insideQuote ? statusDetail.append("T ") : statusDetail.append("F ")  
                escapeQuote ? statusDetail.append("T ") : statusDetail.append("F ")  
                switch character {
                case "\n":
                    statusDetail.append(" \\N ")
                case "\r":
                    statusDetail.append(" \\R ")
                case "\r\n":
                    statusDetail.append(" RN ")
                case "\t":
                    statusDetail.append(" \\T ")
                default:
                    statusDetail.append("  \(character) ")
                }
                statusDetail.append(" :@\(countLine)/\(countLineChar)/[\(recordList.count)]")
                log.verbose(statusDetail)
                if countLine == 999 && countLineChar > 0 { // :DEBUG:
                    print(":@\(countLine)/\(countLineChar)/[\(recordList.count)]")
                }
                //
                if character == "\r" {
                    // Ignore "\r" part of Windows line ending "\r\n"
                    continue
                } else if character == "\n" || character == "\r\n" {
                    // :NYI:???: maybe normalize line endings before processing 
                    if insideQuote {
                        field.append(character)
                    } else {
                        record.append(field)
                        if record.count >= 4 {
                            let r = TsvImportRow(
                                key_android: String(record[0]), 
                                key_apple: String(record[1]), 
                                base_value: String(record[2]), 
                                lang_value: String(record[3])
                            )
                            recordList.append(r)
                            countLine += 1
                            countLineChar = 0
                        }
                        field = []
                        record = []
                        escapeQuote = false
                        insideQuote = false
                    }
                } else if character == "\t" {
                    if insideQuote {
                        field.append(character)
                    } else {
                        record.append(field)
                        field = []
                        escapeQuote = false
                        insideQuote = false
                    }
                } else if character == "\"" {
                    if insideQuote {
                        if escapeQuote {
                            if characterPrev == "\"" {
                                field.append(character)
                                escapeQuote = false                                
                            } else {
                                fatalError(":ERROR:@\(countLine)/\(countLineChar)/[\(recordList.count)]: TsvImportSheet escaped quote must precede")
                            }
                        } else {
                            escapeQuote = true
                        }
                    } else {
                        if characterPrev == nil || characterPrev == "\n" || characterPrev == "\t" {
                            insideQuote = true
                            escapeQuote = false
                        } else {
                            // print(":CHECK:@\(position): TsvImportSheet double quote in \(field)")
                            field.append(character)
                        }
                    }
                } else {
                    field.append(character)
                }
                
                characterPrev = character
            }
            
            
        } catch {
            print(  "TsvImportSheet error:\n\(error)")
        }
    }
    
    func toString() -> String {
        var s = ""
        var index = 0
        for r in recordList {
            s.append("record[\(index)]:\n\(r.toString())\n")
            index += 1
        }
        return s
    }
    
    func toStringDot() -> String {
        var s = ""
        for r in recordList {
            s.append("\(r.toStringDot())Ⓝ")
        }
        return s
    } 
    
}

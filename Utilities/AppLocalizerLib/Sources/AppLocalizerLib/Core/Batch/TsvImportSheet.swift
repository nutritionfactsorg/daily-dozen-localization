//
//  TsvImportSheet.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvImportSheet {
    var recordList: [TsvImportRow] = []
    var log = LogService()
    
    init(url: URL, loglevel: LogServiceLevel = .info) {
        log.logLevel = loglevel
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            // .split(whereSeparator: (Character) throws -> Bool)
            // Value of type 'String.Element' (aka 'Character') has no member 'isNewLine'
            
            if content.count < 100 {
                print(":ERROR: TsvImportSheet did not init with \(url.absoluteString)")
                return
            }
            
            var cPrev: Character? // Previous UTF-8 Character
            var cThis: Character? // Current UTF-8 Character
            var cNext: Character? // Next UTF-8 Character
                    
            var insideQuote = false
            var escapeQuote = false
            var record: [[Character]] = []
            var field: [Character] = []
            var countChar = 0
            var countLine = 1
            var countLineChar = 0
            
            for character in content {
                cPrev = cThis
                cThis = cNext
                cNext = character
                countChar += 1
                countLineChar += 1
                //
                var statusDetail = ""
                insideQuote ? statusDetail.append("T ") : statusDetail.append("F ")  
                escapeQuote ? statusDetail.append("T ") : statusDetail.append("F ")  
                switch cThis {
                case "\n":
                    statusDetail.append(" \\N ")
                case "\r":
                    statusDetail.append(" \\R ")
                case "\r\n":
                    statusDetail.append(" RN ")
                case "\t":
                    statusDetail.append(" \\T ")
                default:
                    statusDetail.append("  \(cThis ?? "␀") ")
                }
                statusDetail.append(" :@\(countLine)/\(countLineChar)/[\(recordList.count)]")
                log.verbose(statusDetail)
                if countLine == 999 && countLineChar > 0 { // :DEBUG:
                    print(":@\(countLine)/\(countLineChar)/[\(recordList.count)]")
                }
                //
                if cThis == "\r" {
                    // Ignore "\r" part of Windows line ending "\r\n"
                    continue
                } else if cThis == "\n" || cThis == "\r\n" {
                    // :NYI:???: maybe normalize line endings before processing 
                    if insideQuote {
                        field.append("\n") // :???: double check platform line endings
                    } else {
                        record.append(field)
                        if record.count >= 4 {
                            if !record[0].isEmpty || !record[1].isEmpty || !record[2].isEmpty || !record[3].isEmpty {
                                let r = TsvImportRow(
                                    key_android: String(record[0]), 
                                    key_apple: String(record[1]), 
                                    base_value: String(record[2]), 
                                    lang_value: String(record[3])
                                )
                                recordList.append(r)
                            }
                            countLine += 1
                            countLineChar = 0
                        }
                        field = []
                        record = []
                        escapeQuote = false
                        insideQuote = false
                    }
                } else if cThis == "\t" {
                    if insideQuote {
                        field.append("\t")
                    } else {
                        record.append(field)
                        field = []
                        escapeQuote = false
                        insideQuote = false
                    }
                } else if cThis == "\"" {
                    if insideQuote {
                        if escapeQuote {
                            if cPrev == "\"" {
                                field.append("\"")
                                escapeQuote = false                                
                            } else {
                                fatalError(":ERROR:@\(countLine)/\(countLineChar)/[\(recordList.count)]: TsvImportSheet escaped quote must precede")
                            }
                        } else {
                            if cNext == "\t" || cNext == "\n" || cNext == "\r\n" {
                                insideQuote = false
                            } else {
                                escapeQuote = true
                            }
                        }
                    } else {
                        if cPrev == nil || cPrev == "\n" || cPrev == "\t" {
                            insideQuote = true
                            escapeQuote = false
                        } else {
                            // print(":CHECK:@\(position): TsvImportSheet double quote in \(field)")
                            if let cThis = cThis {
                                field.append(cThis)
                            }
                        }
                    }
                } else {
                    if let cThis = cThis {
                        field.append(cThis)
                    }
                }
                
                cPrev = cThis
            }
            
            // Handle last Character
            if let cNext = cNext {
                if cNext != "\n" && cNext != "\r" && cNext != "\r\n" && cNext != "\t" {
                    field.append(cNext)
                }
            }
            if field.isEmpty == false {
                record.append(field)
            }
            if !record[0].isEmpty || !record[1].isEmpty || !record[2].isEmpty || !record[3].isEmpty {
                let r = TsvImportRow(
                    key_android: String(record[0]), 
                    key_apple: String(record[1]), 
                    base_value: String(record[2]), 
                    lang_value: String(record[3])
                )
                recordList.append(r)
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

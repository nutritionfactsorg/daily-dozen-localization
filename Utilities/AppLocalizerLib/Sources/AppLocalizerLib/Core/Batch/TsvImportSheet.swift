//
//  TsvImportSheet.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvImportSheet {
    var recordList: [TsvImportRow] = []
    
    init(url: URL) {
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
            var countLine = 1
            var countLineChar = 0
            for character in content {
                countLineChar += 1
                if countLine == 999 && countLineChar > 0 { // :DEBUG:
                    print(":@\(countLine)/\(countLineChar)/[\(recordList.count)]")
                }
                if character == "\r" {
                    // Ingore "\r" part of Windows line ending "\r\n" 
                    continue
                } else if character == "\n" {
                    if insideQuote {
                        field.append(character)
                    } else {
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
                                fatalError(":ERROR:@\(countLine)/\(countLineChar)/[\(recordList.count)]: TsvImportSheet escaped quote must preceed")
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

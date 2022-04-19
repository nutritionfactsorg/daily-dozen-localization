//
//  SortHelper.swift
//  AppLocalizerLib
//

import Foundation

struct SortHelper {
    
    struct SortElement {
        let string: String
        let base: String
        let postUInt: UInt?
        
        init(_ str: String) {
            string = str
                        
            if let i = UInt(str.suffix(3)) {
                base = String(str.dropLast(3)).lowercased()
                postUInt = i
            } else if let i = UInt(str.suffix(2)) {
                base = String(str.dropLast(2)).lowercased()
                postUInt = i
            } else if let i = UInt(str.suffix(1)) {
                base = String(str.dropLast()).lowercased()
                postUInt = i
            } else {
                base = str.lowercased()
                postUInt = nil
            }            
        }
        
        func toString() -> String {
            let postStr = (postUInt != nil) ? String(postUInt!) : "nil"
            return """
             string:\(string)
               base:\(base)
            postInt:\(postStr)
            
            """
        }

    }
    
    var elementArray: [SortElement]

    init(_ stringArray: [String]) {
        elementArray = []
        for s in stringArray {
            elementArray.append(SortElement(s))
        }
    }
    
    func sortWithUintPostfix() -> [String] {
        
        let sortedElements = elementArray.sorted { 
            (lhs: SortElement, rhs: SortElement) -> Bool in
            //returns true when lhs should be ordered before rhs
            if let lhsUint = lhs.postUInt, let rhsUint = rhs.postUInt, 
                lhs.base == rhs.base
            {
                return lhsUint < rhsUint
            }
            return lhs.base < rhs.base
        }
        
        var result = [String]()
        for e in sortedElements {
            result.append(e.string)
        }
        
        return result
    }
    
}

//
//  StringsRegex.swift
//  UrlReportGenerator
//

import Foundation

public extension String {
    func regexMatch(pattern: String) -> Bool {
        let anyMatch = self.regexSearch(pattern: pattern)
        if anyMatch.count > 0 {
            return true
        }
        return false
    }
    
    @available(*, unavailable, renamed: "regexRemoving")
    func regexRemove(pattern: String) -> String { return "" }
    
    func regexRemoving(pattern: String) -> String {
        return self.regexReplacing(pattern: pattern, template: "")
    }
    
    @available(*, unavailable, renamed: "regexReplacing")
    func regexReplace(pattern: String, template: String) -> String { return "" }
    
    func regexReplacing(pattern: String, template: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])

            let nsRange = NSRange(location: 0, length: self.utf16.count)
            var outString: String?
            //autoreleasepool{
            outString = regex.stringByReplacingMatches(
                in: self,
                options: [],
                range: nsRange,
                withTemplate: template
            )
            //}
            return outString!
        }
        catch {
            return ""
        }
    }
    
    func regexSearch(pattern: String) -> [String] {
        var stringGroupMatches = [String]()
        
        do {
            
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsRangeAll = NSRange(location: 0, length: self.utf16.count)
            
            // autoreleasepool {
            let matches = regex.matches( in: self, options: [], range: nsRangeAll)
            
            for match: NSTextCheckingResult in matches {
                let rangeCount: Int = match.numberOfRanges
                // remember: $0th match is whole pattern
                for group in 0 ..< rangeCount {
                    //let nsRange: NSRange = match.range(at: group)
                    //let r: Range = self.range(from: nsRange)!  // NO LONGER AVAILABLE
                    
                    let r: Range = Range(match.range(at: group))!
                    stringGroupMatches.append( String(self[r.lowerBound ..< r.upperBound]) )
                }
            }
            // }
            return stringGroupMatches
        }
        catch {
            return []
        }
    }
    
}

extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}

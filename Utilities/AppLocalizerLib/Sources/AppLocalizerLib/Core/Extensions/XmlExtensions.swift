//
//  XmlExtensions.swift
//  AppLocalizerLib
//

import Foundation

// XMLDocument level 1 is root.
// See also: https://developer.apple.com/documentation/foundation/xmldocument

extension XMLNode.Kind {
    func toString() -> String {
        switch self {
        case .invalid:
            return "invalid"
        case .document:
            return "document"
        /// `Element`: only node type which can have both child nodes and attributes.
        case .element:
            // Examples:
            // ```
            // <tag> stuff </tag>
            // <tag abc="xyz"></tag>
            // <tag abc="xuz" />
            // ```
            return "element"
        case .attribute:
            return "attribute"
        case .namespace:
            return "namespace"
        case .processingInstruction:
            return "processingInstruction"
        case .comment:
            return "comment"
        case .text:
            return "text"
        case .DTDKind:
            return "DTDKind"
        case .entityDeclaration:
            return "entityDeclaration"
        case .attributeDeclaration:
            return "attributeDeclaration"
        case .elementDeclaration:
            return "elementDeclaration"
        case .notationDeclaration:
            return "notationDeclaration"
        @unknown default:
            return "@unknown"
        }
    }
}

extension XMLNode {
    func toStringNode() -> String {
        var s = ""
        s.append("xPath:'\(self.xPath ?? "nilpath")' ")
        s.append("kind:'\(self.kind.toString())' ") // node kind
        s.append("name:'\(self.name ?? "nil")' ") // tagname
        s.append("level:\(self.level) ")
        s.append("index:\(self.level) ")
        s.append("children:\(self.childCount) ")
        if self.childCount == 0 {
            s.append("nodevalue:'\(self.stringValue ?? "nil")' ")
        }
        return s
    }
}

extension XMLElement {
    func toStringElement() -> String {
        var s = self.toStringNode()
        if let attributeList: [XMLNode] = self.attributes {
            s.append("attributes: ")
            for attribute in attributeList {
                guard 
                    let name = attribute.name, 
                    let value = attribute.stringValue 
                    else { continue }
                s.append("(\(name):\(value)) ")
            }
        }
        return s
    }
}

//
//  Data+.swift
//  
//
//  Created by Simon Schöpke on 19.06.21.
//

import Foundation

extension Data {
    static func + (lhs: Data, rhs: String) -> Data {
        return lhs + rhs.data(using: .utf8)!
    }
    
    static func + (lhs: String, rhs: Data) -> Data {
        return lhs.data(using: .utf8)! + rhs
    }
}

extension Data: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = value.data(using: .utf8)!
    }
}

extension Sequence where Element == Data {
    func joined(seperator: Data) -> Data {
        guard let firstElement = self.first() else {
            return Data()
        }
        
        return dropFirst().reduce(firstElement) { joinedData, data in
            joinedData + seperator + data
        }
    }
    
    private func first() -> Element? {
        self.first { _ in true }
    }
}

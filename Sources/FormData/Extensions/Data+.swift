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

extension Data {
    var utf8String: String {
        String(data: self, encoding: .utf8)!
    }
}

extension Data {
    func contains<D>(_ data: D) -> Bool where D: DataProtocol {
        self.firstRange(of: data) != nil
    }
}

extension Data: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = value.data(using: .utf8, allowLossyConversion: false)!
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
    
    func joined() -> Data {
        guard let firstElement = self.first() else {
            return Data()
        }
        
        return dropFirst().reduce(firstElement, +)
    }
    
    private func first() -> Element? {
        self.first { _ in true }
    }
    
    func containsAny(segment: Data) -> Bool {
        !self.allSatisfy { !$0.contains(segment) }
    }
}

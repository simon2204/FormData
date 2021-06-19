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
}

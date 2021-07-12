//
//  File.swift
//  
//
//  Created by Simon Schöpke on 12.07.21.
//

import Foundation

extension UUID {
    func uuidData() -> Data {
        return Data(self.asUInt8Array())
    }
    
    private func asUInt8Array() -> [UInt8] {
        let (u1, u2, u3, u4, u5, u6, u7, u8, u9, u10, u11, u12, u13, u14, u15, u16) = self.uuid
        return [u1, u2, u3, u4, u5, u6, u7, u8, u9, u10, u11, u12, u13, u14, u15, u16]
    }
}

//
//  UrlEncodedData.swift
//  
//
//  Created by Simon Schöpke on 12.07.21.
//

import Foundation

public struct UrlEncodedData: PostRequest {
    
    public let httpHeaderFields = ["Content-Type": "application/x-www-form-urlencoded"]
    
    public var body: Data {
        dataParts.joined(separator: "&").data(using: .utf8)!
    }
    
    private var dataParts = [String]()
    
    public init() { }
    
    public mutating func add(value: String, forKey key: String) {
        let value = value.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let key = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let dataPart = "\(key)=\(value)"
        dataParts.append(dataPart)
    }
}

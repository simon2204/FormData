//
//  UrlEncodedData.swift
//  
//
//  Created by Simon Schöpke on 12.07.21.
//

import Foundation

public final class UrlEncodedData: PostRequest {
    
    public var httpHeaderFields: [String: String] {
        ["Content-Type": MimeType.urlencoded.rawValue]
    }
    
    public var body: Data {
        return dataParts.joined(separator: "&").data(using: .utf8)!
    }
    
    private var dataParts = [String]()
    
    public init() { }
    
    public func add(value: String, forKey key: String) {
        let value = value.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let key = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let dataPart = "\(key)=\(value)"
        dataParts.append(dataPart)
    }
}

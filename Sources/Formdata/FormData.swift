//
//  FormData.swift
//  
//
//  Created by Simon Schöpke on 14.06.21.
//

import Foundation

public struct FormData {
    private static let identification = "FromDataFormBoundary"
    private static let contentType = ContentType.formData.rawValue
    private static let contentDisposition = "form-data"
    
    private let boundary: Data
    private var multiPartData: Data
    
    private var endBoundary: Data {
        boundary + "--\r\n"
    }
    
    var httpHeaderFields: [String: String] {
        let contentType = "\(Self.contentType); boundary=\(boundary)"
        return ["Content-Type": contentType]
    }
    
    var data: Data {
        multiPartData + endBoundary
    }
    
    public init(boundary: String? = nil) {
        self.init(boundary: boundary?.data(using: .utf8))
    }
    
    public init(boundary: Data? = nil) {
        self.boundary = boundary ?? Self.createBoundary()
        self.multiPartData = Data()
    }
    
    private static func createBoundary() -> Data {
        let uniqueID = UUID().uuidString
        return "--\(Self.identification)\(uniqueID)".data(using: .utf8)!
    }
    
    public mutating func append(_ text: String, name: String) {
        multiPartData.append(partData(for: text, name: name))
    }
    
    public mutating func append(_ data: Data, name: String) {
        multiPartData.append(partData(for: data, name: name))
    }
    
    public mutating func append(_ file: File, name: String) {
        multiPartData.append(partData(for: file, name: name))
    }
    
    private func partData(for text: String, name: String) -> Data {
        partData(for: text.data(using: .utf8)!, name: name)
    }
    
    private func partData(for data: Data, name: String) -> Data {
        boundary + "\r\n"
        + "Content-Disposition: \(FormData.contentDisposition); "
        + "name=\"\(name)\"\r\n"
        + "\r\n" + data + "\r\n"
    }
    
    private func partData(for file: File, name: String) -> Data {
        boundary + "\r\n"
        + "Content-Disposition: \(FormData.contentDisposition); "
        + "name=\"\(name)\"; "
        + "filename=\"\(file.name)\"\r\n"
        + "Content-Type: \(file.contentType.rawValue)\r\n"
        + "\r\n" + file.content + "\r\n"
    }
}

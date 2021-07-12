//
//  FormData.swift
//  
//
//  Created by Simon Schöpke on 14.06.21.
//

import Foundation

/// Repräsentiert HTML Form Data
///
/// Ermöglicht Daten über HTML als `multipart/form-data` zu versenden.
///
public struct FormData: PostRequest {
    
    // Media Type der Ressourcen, die mit `FormData` erstellt werden.
    private static let contentType = MimeType.formData.rawValue
    
    // Art des Inhaltes, welcher dargestellt wird.
    private static let contentDisposition = "form-data"
    
    // Enthält alle Dateien und Daten, die zu `FormData` hinzugefügt wurden.
    private var dataParts = [Data]()
    
    private var boundary: Boundary<FormData>!
    
    // Teilt bei Versenden der Daten dem Server oder Client mit,
    // um welchen Inhaltstyp es sich bei den zurückgegebenen Inhalten handelt.
    public var httpHeaderFields: [String: String] {
        let contentType = "\(Self.contentType); boundary=\(boundary.boundaryData.utf8String)"
        return ["Content-Type": contentType]
    }
    
    // Beinhaltet alle Daten, die zum Versenden als form-data benötigt werden.
    public var body: Data {
        boundary.boundaryData
        + dataParts.joined(seperator: boundary.boundaryData)
        + boundary.endBoundaryData
    }
    
    public init() {
        self.boundary = Boundary(object: self, keyPath: \.dataParts)
    }
    
    public mutating func append(_ text: String, name: String) {
        dataParts.append(dataPart(for: text, name: name))
    }
    
    public mutating func append(_ data: Data, name: String) {
        dataParts.append(dataPart(for: data, name: name))
    }
    
    public mutating func append(_ file: File, name: String) {
        dataParts.append(dataPart(for: file, name: name))
    }
    
    private func dataPart(for text: String, name: String) -> Data {
        dataPart(for: text.data(using: .utf8)!, name: name)
    }
    
    private func dataPart(for data: Data, name: String) -> Data {
        "Content-Disposition: \(FormData.contentDisposition); "
        + "name=\"\(name)\"\r\n"
        + "\r\n" + data + "\r\n"
    }
    
    private func dataPart(for file: File, name: String) -> Data {
        "Content-Disposition: \(FormData.contentDisposition); "
        + "name=\"\(name)\"; "
        + "filename=\"\(file.name)\"\r\n"
        + "Content-Type: \(file.contentType.rawValue)\r\n"
        + "\r\n" + file.content + "\r\n"
    }
}


fileprivate final class Boundary<T> {
    
    private let object: T
    
    private let keypath: KeyPath<T, [Data]>
    
    private var data: [Data]!
    
    private var cachedBoundaryValue: Data!
    
    private var boundaryValue: Data {
        let currentData = object[keyPath: keypath]
        
        if cachedBoundaryValue == nil || self.data != currentData {
            self.data = currentData
            self.cachedBoundaryValue = createUniqueBoundaryValue()
        }
        
        return self.cachedBoundaryValue
    }
    
    // Abgrenzung der einzelnen Teile in einer Multipart Datenstruktur.
    var boundaryData: Data {
        "--" + boundaryValue
    }
    
    // Markiert, dass keine weiteren Dateien und Daten nach dieser Grenze mehr folgen.
    var endBoundaryData: Data {
        "--" + boundaryValue + "--"
    }
    
    init(object: T, keyPath: KeyPath<T, [Data]>) {
        self.object = object
        self.keypath = keyPath
    }
    
    private func createUniqueBoundaryValue() -> Data {
        var boundaryValue: Data
        repeat {
            boundaryValue = Self.createBoundaryValue()
        } while data.containsAny(segment: boundaryValue)
        return boundaryValue
    }
    
    /// Erstellt eine neue Grenze mit Hilfe einer selbst festgelegten Identifikation und einer `UUID`.
    /// - Returns: Grenze in Form von Daten.
    private static func createBoundaryValue() -> Data {
        UUID().uuidData()
    }
}




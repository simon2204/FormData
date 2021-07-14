//
//  FormData.swift
//  
//
//  Created by Simon Schöpke on 14.06.21.
//

import Foundation

/// Erstellt `multipart/form-data` für Uploads innerhalb eines HTTP- oder HTTPS-Bodys.
///
/// Weitere Informationen zu `multipart/form-data` im Allgemeinen
/// sind in den Spezifikationen RFC-2388 und RFC-2045.
///
public struct FormData: PostRequest {
 
    // Enthält alle Dateien und Daten, die zu `FormData` hinzugefügt wurden.
    private var dataParts = [Data]()
    
    /// Abgrenzung der `dataParts` zueinander.
    private var boundary = Boundary()
    
    public var httpHeaderFields: [String: String] {
        ["Content-Type": "multipart/form-data; boundary=\(boundary.value)"]
    }
    
    public var body: Data {
        boundary.data
        + dataParts.joined(seperator: boundary.data)
        + boundary.finalData
    }
    
    /// Erstellt ein leeres FormData Objekt.
    public init() { }
    
    public mutating func add(value: String, forKey key: String) {
        dataParts.append(dataPart(for: value, name: key))
    }
    
    public mutating func add(data: Data, forKey key: String) {
        dataParts.append(dataPart(for: data, name: key))
    }
    
    public mutating func add(file: File, forKey key: String) {
        dataParts.append(dataPart(for: file, name: key))
    }
    
    private func dataPart(for text: String, name: String) -> Data {
        dataPart(for: text.data(using: .utf8)!, name: name)
    }
    
    private func dataPart(for data: Data, name: String) -> Data {
        "Content-Disposition: form-data; "
        + "name=\"\(name)\"\r\n"
        + "\r\n" + data + "\r\n"
    }
    
    private func dataPart(for file: File, name: String) -> Data {
        "Content-Disposition: form-data; "
        + "name=\"\(name)\"; "
        + "filename=\"\(file.name)\"\r\n"
        + "Content-Type: \(file.contentType.rawValue)\r\n"
        + "\r\n" + file.content + "\r\n"
    }
}

/// Abgrenzung der einzelnen Teile in einer Multipart Datenstruktur.
fileprivate struct Boundary {
    /// Wert der Grenze, ohne die zusätzlichen zwei führenden Bindestriche
    /// und ohne Carriage Returns und Line Feeds.
    let value =  "----------FormDataBoundary-" + UUID().uuidString
    
    /// Grenze mit zwei Bindestrichen und CRLF.
    var data: Data {
        "--" + value + "\r\n"
    }
    
    /// Markiert, dass keine weiteren Daten nach dieser Grenze mehr folgen.
    var finalData: Data {
        "--" + value + "--"
    }
}

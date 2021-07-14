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
public final class FormData: PostRequest {
    
    // Media Type der Ressourcen, die mit `FormData` erstellt werden.
    private static let contentType = MimeType.formData.rawValue
    
    // Art des Inhaltes, welcher dargestellt wird.
    private static let contentDisposition = "form-data"
    
    // Enthält alle Dateien und Daten, die zu `FormData` hinzugefügt wurden.
    private var dataParts = [Data]()
    
    /// Abgrenzung der `dataParts` zueinander.
    private var boundary: Boundary<FormData>!
    
    public var httpHeaderFields: [String: String] {
        ["Content-Type": "\(Self.contentType); boundary=\(boundary.boundaryValue.utf8String)"]
    }
    
    public var body: Data {
        boundary.boundaryData
        + dataParts.joined(seperator: boundary.boundaryData)
        + boundary.endBoundaryData
    }
    
    /// Erstellt ein leeres FormData Objekt.
    public init() {
        self.boundary = Boundary(object: self, keyPath: \.dataParts)
    }
    
    public func add(value: String, forKey key: String) {
        dataParts.append(dataPart(for: value, name: key))
    }
    
    public func add(data: Data, forKey key: String) {
        dataParts.append(dataPart(for: data, name: key))
    }
    
    public func add(file: File, forKey key: String) {
        dataParts.append(dataPart(for: file, name: key))
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

/// Abgrenzung der einzelnen Teile in einer Multipart Datenstruktur.
fileprivate final class Boundary<T> {
    
    /// Objekt auf welches der keyPath angewendet werden soll.
    private let object: T
    
    /// Pfad zur Eigenschaft, in dessen Daten die Grenze nicht vorkommen soll.
    private let keypath: KeyPath<T, [Data]>
    
    /// Enthält die gecachten Daten, die die Grenze nicht beinhaltet.
    private var cachedData: [Data]!
    
    /// Enthält den gecachten Wert der Grenze.
    private var cachedBoundaryValue: Data!
    
    /// Wert der Grenze, ohne zusätzliche Bindestriche, Carriage Returns und Line Feeds.
    var boundaryValue: Data {
        
        let newData = object[keyPath: keypath]
        
        // Erstellt eine neue Grenze, wenn noch keine existiert oder
        // wenn sich die neuen Daten zu den vorherigen unterscheiden.
        if cachedBoundaryValue == nil || self.cachedData != newData {
            self.cachedData = newData
            self.cachedBoundaryValue = createUniqueBoundaryValue()
        }
        
        return self.cachedBoundaryValue
    }
    
    /// Grenze mit zwei Bindestrichen und CRLF.
    var boundaryData: Data {
        "--" + boundaryValue + "\r\n"
    }
    
    /// Markiert, dass keine weiteren Daten nach dieser Grenze mehr folgen.
    var endBoundaryData: Data {
        "--" + boundaryValue + "--"
    }
    
    /// Erstellt ein neues `Boundary` Objekt, welches Grenzen liefert,
    /// die nicht in den Daten des übergebenen keyPaths vorkommen.
    /// - Parameters:
    ///   - object: Objekt auf welches der keyPath angewendet werden soll.
    ///   - keyPath: Pfad zur Eigenschaft, in dessen Daten die Grenze nicht vorkommen soll.
    init(object: T, keyPath: KeyPath<T, [Data]>) {
        self.object = object
        self.keypath = keyPath
    }
    
    /// Erstellt eine neue Grenze, die nicht in dem übergebenen Daten vorkommt.
    /// - Returns: UUID-Grenze in Form von Daten.
    private func createUniqueBoundaryValue() -> Data {
        var boundaryValue: Data
        repeat {
            boundaryValue = Self.createBoundaryValue()
        } while cachedData.containsAny(segment: boundaryValue)
        return boundaryValue
    }
    
    /// Erstellt eine neue Grenze mit Hilfe einer selbst festgelegten Identifikation und einer `UUID`.
    /// - Returns: UUID-Grenze in Form von Daten.
    private static func createBoundaryValue() -> Data {
        UUID().uuidString.data(using: .utf8)!
    }
}




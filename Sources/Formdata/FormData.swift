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
public class FormData {
    // Media Type der Ressourcen, die mit `FormData` erstellt werden.
    private static let contentType = MimeType.formData.rawValue
    
    // Art des Inhaltes, welcher dargestellt wird.
    private static let contentDisposition = "form-data"
    
    private var dataHasChanged = false
    
    // Enthält alle Dateien und Daten, die zu `FormData` hinzugefügt wurden.
    private var dataParts = [Data]() {
        didSet {
            dataHasChanged = true
        }
    }
    
    private var cachedBoundary: Boundary!
    
    private var boundary: Boundary {
        if dataHasChanged {
            cachedBoundary = Boundary(data: dataParts)
            dataHasChanged = false
        }
        return cachedBoundary
    }
    
    // Teilt bei Versenden der Daten dem Server oder Client mit,
    // um welchen Inhaltstyp es sich bei den zurückgegebenen Inhalten handelt.
    var httpHeaderFields: [String: String] {
        let contentType = "\(Self.contentType); boundary=\(boundary.boundaryData.utf8String)"
        return ["Content-Type": contentType]
    }
    
    // Beinhaltet alle Daten, die zum Versenden als form-data benötigt werden.
    var multiPartData: Data {
        boundary.boundaryData
        + dataParts.joined(seperator: boundary.boundaryData)
        + boundary.endBoundaryData
    }
    
    public func append(_ text: String, name: String) {
        dataParts.append(dataPart(for: text, name: name))
    }
    
    public func append(_ data: Data, name: String) {
        dataParts.append(dataPart(for: data, name: name))
    }
    
    public func append(_ file: File, name: String) {
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

extension FormData {
    struct Boundary {
        // Dient dazu die zum Server gesendeten Form-Daten mit diesem
        // Framework in verbindung zu bringen.
        private static let identification: Data = "FormDataFormBoundary"
        
        // Abgrenzung der einzelnen Teile in einer Multipart Datenstruktur.
        let boundaryData: Data
        
        // Markiert, dass keine weiteren Dateien und Daten nach dieser Grenze mehr folgen.
        let endBoundaryData: Data
        
        init(data: [Data]) {
            let boundaryValue = Self.createUniqueBoundaryValue(for: data)
            self.boundaryData = "--" + boundaryValue
            self.endBoundaryData = "--" + boundaryValue + "--"
        }
        
        private static func createUniqueBoundaryValue(for data: [Data]) -> Data {
            var boundaryValue: Data
            repeat {
                boundaryValue = Self.createBoundaryValue()
            } while !isUniqueBoundaryValue(boundaryValue, for: data)
            return boundaryValue
        }
        
        /// Erstellt eine neue Grenze mit Hilfe einer selbst festgelegten Identifikation und einer `UUID`.
        /// - Returns: Grenze in Form von Daten.
        private static func createBoundaryValue() -> Data {
            Self.identification + UUID().uuidString
        }

        private static func isUniqueBoundaryValue(_ boundaryValue: Data, for data: [Data]) -> Bool {
            data.allSatisfy { !$0.contains(boundaryValue) }
        }
    }
}



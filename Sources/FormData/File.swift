//
//  File.swift
//  
//
//  Created by Simon Schöpke on 14.06.21.
//

import Foundation

/// Repräsentiert eine Datei, die zu `FormData` hinzugefügt werden kann.
///
/// Um ein Objekt von `File` zu erzeugen, kann die URL zu einer lokalen Datei verwendet werden.
/// Zum Beispiel:
/// ```swift
/// let localFilePath = "/Users/Simon/Desktop/DummyText.txt"
/// let localFileURL = URL(fileURLWithPath: localFilePath)
/// let file = try File(url: localFileURL, contentType: .plainText)
/// ```
public struct File {
    public let name: String
    public let content: Data
    public let contentType: MimeType
    
    /// Initialisiert eine neue Datei mit einem Namen, Inhalt und Art des Inhaltes.
    /// - Parameters:
    ///   - name: Name der Datei.
    ///   - content: Inhalt der Datei.
    ///   - contentType: Art des Inhaltes.
    public init(name: String, content: Data, contentType: MimeType) {
        self.name = name
        self.content = content
        self.contentType = contentType
    }
    
    /// Initialisiert eine neue Datei mit einer `URL` zu einer Datei und Art des Inhaltes.
    /// - Parameters:
    ///   - url: URL zu einer Datei.
    ///   - contentType: Art des Inhaltes.
    public init(url: URL, contentType: MimeType) throws {
        self.name = url.lastPathComponent
        self.content = try Data(contentsOf: url)
        self.contentType = contentType
    }
}

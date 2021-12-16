//
//  PostRequest.swift
//  
//
//  Created by Simon Schöpke on 12.07.21.
//

import Foundation

public protocol PostRequest {
    /// Ein `Dictionary`, das alle HTTP-Header-Felder für eine Anfrage enthält.
    var httpHeaderFields: [String: String] { get }
    /// Die Daten, die als Nachrichtentext einer Anfrage gesendet werden.
    var body: Data { get }
}

public extension PostRequest {
    /// Versendet `PostRequest`s an eine bestimmte `URL`.
    /// - Parameter url: Ziel der Anfrage.
    /// - Returns: Antwort des Servers.
    @discardableResult
    func post(to url: URL) async throws -> Data {
        let uploader = PostRequestUploader(postRequest: self, url: url)
        return try await uploader.upload()
    }
}

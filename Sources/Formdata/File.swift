//
//  File.swift
//  
//
//  Created by Simon Schöpke on 14.06.21.
//

import Foundation

public struct File {
    let name: String
    let content: Data
    let contentType: ContentType
    
    public init(name: String, content: Data, contentType: ContentType) {
        self.name = name
        self.content = content
        self.contentType = contentType
    }
    
    public init(url: URL, contentType: ContentType) throws {
        self.name = url.lastPathComponent
        self.content = try Data(contentsOf: url)
        self.contentType = contentType
    }
}

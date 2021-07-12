//
//  PostRequest.swift
//  
//
//  Created by Simon Schöpke on 12.07.21.
//

import Foundation

public protocol PostRequest {
    var httpHeaderFields: [String: String] { get }
    var body: Data { get }
}

public extension PostRequest {
    @discardableResult
    func post(to url: URL) throws -> Data {
        let uploader = PostRequestUploader(postRequest: self, url: url)
        return try uploader.upload()
    }
}

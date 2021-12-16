//
//  PostRequestUploader.swift
//  
//
//  Created by Simon Schöpke on 19.06.21.
//

import Foundation

#if os(Linux)
import FoundationNetworking
#endif

struct PostRequestUploader {
    private let postRequest: PostRequest
    private let url: URL
    
    public init(postRequest: PostRequest, url: URL) {
        self.postRequest = postRequest
        self.url = url
    }
    
    private var request: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = postRequest.httpHeaderFields
        return urlRequest
    }
    
    @discardableResult
    public func upload() async throws -> Data {
        let (data, response) = try await URLSession.shared.upload(for: request, from: postRequest.body)
		
        guard let response = response as? HTTPURLResponse else {
            throw PostRequestUploaderError.couldNotParseResponse
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw PostRequestUploaderError.response(withStatusCode: response.statusCode)
        }
        
        return data
    }
    
    enum PostRequestUploaderError: Error {
        case response(withStatusCode: Int)
        case couldNotParseResponse
        case noDataAvailable
    }
}

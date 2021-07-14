//
//  PostRequestUploader.swift
//  
//
//  Created by Simon Schöpke on 19.06.21.
//

import Foundation

struct PostRequestUploader {
    private static let session = URLSession.shared
    
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
    public func upload() throws -> Data {
        let (data, response, error) = Self.session.upload(with: request, from: postRequest.body)
        
        if let error = error {
            throw error
        }
        
        guard let res = response as? HTTPURLResponse else {
            throw PostRequestUploaderError.noResponse
        }
        
        guard res.statusCode == 200 else {
            throw PostRequestUploaderError.response(withStatusCode: res.statusCode)
        }
        
        guard let data = data else {
            throw PostRequestUploaderError.noDataAvailable
        }
        
        return data
    }
    
    enum PostRequestUploaderError: Error {
        case response(withStatusCode: Int)
        case noResponse
        case noDataAvailable
    }
}

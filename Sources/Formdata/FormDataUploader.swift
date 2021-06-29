//
//  FormDataUploader.swift
//  
//
//  Created by Simon Schöpke on 19.06.21.
//

import Foundation

public struct FormDataUploader {
    private static let session = URLSession.shared
    
    private let formData: FormData
    private let url: URL
    
    public init(formData: FormData, url: URL) {
        self.formData = formData
        self.url = url
    }
    
    private var request: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = formData.httpHeaderFields
        return urlRequest
    }
    
    public func upload() throws -> Data {
        let (data, response, error) = Self.session.upload(with: request, from: formData.multiPartData)
        
        if let error = error {
            throw error
        }
        
        guard let response = response as? HTTPURLResponse else {
            throw FormDataUploaderError.noResponse
        }
        
        guard response.statusCode == 200 else {
            throw FormDataUploaderError.response(withStatusCode: response.statusCode)
        }
        
        guard let data = data else {
            throw FormDataUploaderError.noDataAvailable
        }
        
        return data
    }
    
    enum FormDataUploaderError: Error {
        case response(withStatusCode: Int)
        case noResponse
        case noDataAvailable
    }
}

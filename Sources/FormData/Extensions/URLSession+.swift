//
//  URLSession+.swift
//  
//
//  Created by Simon Schöpke on 19.06.21.
//

import Foundation

extension URLSession {
    func upload(with request: URLRequest, from bodyData: Data) throws -> (Data, URLResponse) {
        var data: Data?
        var error: Error?
        var response: URLResponse?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = uploadTask(with: request, from: bodyData) {
            data = $0
            response = $1
            error = $2
            semaphore.signal()
        }
        
        task.resume()
        
        semaphore.wait()
        
        if let error = error {
            throw error
        }
        
        guard let response = response else {
            throw URLSessionError.serverDidNotRespond
        }
        
        guard let data = data else {
            throw URLSessionError.noDataAvailable
        }
        
        return (data, response)
    }
    
    enum URLSessionError: Error {
        case noDataAvailable
        case serverDidNotRespond
    }
}

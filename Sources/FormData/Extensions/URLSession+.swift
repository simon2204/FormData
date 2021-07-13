//
//  URLSession+.swift
//  
//
//  Created by Simon Schöpke on 19.06.21.
//

import Foundation

extension URLSession {
    static let semaphore = DispatchSemaphore(value: 0)
    
    func upload(with request: URLRequest, from bodyData: Data) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var error: Error?
        var response: URLResponse?
        
        let task = uploadTask(with: request, from: bodyData) {
            data = $0
            response = $1
            error = $2
            Self.semaphore.signal()
        }
        
        task.resume()
        Self.semaphore.wait()
        
        return (data, response, error)
    }
}

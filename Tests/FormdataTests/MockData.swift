//
//  MockData.swift
//  
//
//  Created by Simon Schöpke on 19.06.21.
//

import Foundation
import Formdata

fileprivate let mockForm = "--WebKitFormBoundary2It7EPJgFTqMH0LW\r\n"
+ "Content-Disposition: form-data; name=\"assignmentId\"\r\n\r\n"
+ "1\r\n"
+ "--WebKitFormBoundary2It7EPJgFTqMH0LW\r\n"
+ "Content-Disposition: form-data; name=\"files[]\"; filename=\"katze5432.txt\"\r\n"
+ "Content-Type: text/plain\r\n\r\n"
+ "Katze5432\r\n"
+ "--WebKitFormBoundary2It7EPJgFTqMH0LW\r\n"
+ "Content-Disposition: form-data; name=\"files[]\"; filename=\"test1234.txt\"\r\n"
+ "Content-Type: text/plain\r\n\r\n"
+ "Test1234\r\n"
+ "--WebKitFormBoundary2It7EPJgFTqMH0LW--\r\n"

let mockFormData = mockForm.data(using: .utf8)!

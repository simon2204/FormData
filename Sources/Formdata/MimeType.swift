//
//  MimeType.swift
//  
//
//  Created by Simon Schöpke on 14.06.21.
//

import Foundation

/// Multipurpose Internet Mail Extensions
///
/// Ein Medientyp (auch bekannt als Multipurpose Internet Mail Extensions oder MIME-Typ) ist ein Standard,
/// der die Art und das Format eines Dokuments, einer Datei oder einer Auswahl von Bytes angibt.
/// Er ist im [RFC 6838](https://tools.ietf.org/html/rfc6838)
/// der IETF definiert und standardisiert.
///
public enum MimeType: String {
    case octetStream = "application/octet-stream"
    case pdf = "application/pdf"
    case pkcs8 = "application/pkcs8"
    case zip = "application/zip"
    case formData = "multipart/form-data"
    case byteRanges = "multipart/byteranges"
    case jpeg = "image/jpeg"
    case png = "image/png"
    case svg = "image/svg+xml"
    case plainText = "text/plain"
}

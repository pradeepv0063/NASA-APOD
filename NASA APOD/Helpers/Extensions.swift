//
//  Extensions.swift
//  AlbumViewer

//

import Foundation

extension Encodable {
    var toData: Data? {
        return try? JSONEncoder().encode(self)
    }
}

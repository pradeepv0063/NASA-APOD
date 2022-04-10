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

extension String {
    
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let date = formatter.date(from: self)
        return date
    }
}

extension Date {
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let date = formatter.string(from: self)
        return date
    }
}

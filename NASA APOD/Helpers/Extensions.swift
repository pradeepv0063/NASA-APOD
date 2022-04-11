//
//  Extensions.swift
//  AlbumViewer

//

import Foundation

extension Encodable {
    
    /// Extension to convert Encodable confirming object to Data format
    var toData: Data? {
        return try? JSONEncoder().encode(self)
    }
}

extension String {
    
    /// Extension to convert String of type "YYYY-MM-dd" to Date format
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let date = formatter.date(from: self)
        return date
    }
}

extension Date {
    
    /// Extension to convert Date to String of type "YYYY-MM-dd"
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let date = formatter.string(from: self)
        return date
    }
}

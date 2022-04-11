//
//  LocalStorageService.swift
//  NASA APOD
//
//  Created by Ram Voleti on 10/04/22.
//

import Foundation

protocol LocalStorageServiceType {

    static var favorites: [String: String] { get set }
}

class LocalStorageService: LocalStorageServiceType {

    /// Sets and Returns the Dictionary containing the list of favorites.
    ///
    /// The key contains the `Title` and value contains `Date` of the Favorite picture.

    static var favorites: [String: String] {

        get {
            let list = UserDefaults.standard.object(forKey: UserDefaultKeys.favorites.rawValue) as? [String: String]
            return list ?? [: ]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.favorites.rawValue)
        }
    }
}

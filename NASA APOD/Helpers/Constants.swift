//
//  Constants.swift
//  AlbumViewer

//

import Foundation

/// Cell idetifiers used in the Table Views
enum CellIdentifiers: String {

    case titleCell
    case mediaCell
    case detailCell
}

/// User Default Keys used to fetch from UserDefault
enum UserDefaultKeys: String {
    case favorites
}

/// List of Image used in the app.
enum ImageNames: String {
    case favorite = "Favorite"
    case favoriteFill = "FavoriteFill"
}

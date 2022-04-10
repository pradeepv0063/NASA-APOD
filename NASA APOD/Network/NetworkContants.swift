//
//  NetworkContants.swift
//  AlbumViewer

//

import Foundation

enum NetworkError: Error {
    case noInternetConnection
    case invalidURL
    case badInput
    case custom(String)
    case unknown
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum APIDetails: String {
    case apiKey = "2gRO8gaQIdeWYw6VaLcYn99mR3Hc3HawL49TGEfb"
}

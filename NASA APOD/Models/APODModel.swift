//
//  APODModel.swift
//  NASA APOD
//
//  Created by Ram Voleti on 10/04/22.
//

import Foundation

enum MediaType: String, Codable {
    case image
    case video
    case unknown
}

typealias APODModelList = [APODModel]

struct APODModel: Codable {

    let date: Date?
    let detail: String
    let hdurl: URL?
    let mediaType: MediaType
    let title: String
    let url: URL?
    let urlString: String
    
    enum CodingKeys: String, CodingKey {
        case title, date, url, hdurl
        case detail = "explanation"
        case mediaType = "media_type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        detail = try container.decodeIfPresent(String.self, forKey: .detail) ?? ""
        mediaType = try container.decodeIfPresent(MediaType.self, forKey: .mediaType) ?? .unknown
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        let hdurlString = try container.decodeIfPresent(String.self, forKey: .hdurl) ?? ""
        hdurl = URL(string: hdurlString)
        urlString = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        url = URL(string: urlString)
        let dateString = try container.decodeIfPresent(String.self, forKey: .date)
        date = dateString?.getDate()
    }
}

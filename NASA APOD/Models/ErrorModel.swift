//
//  ErrorModel.swift
//  NASA APOD
//
//  Created by Ram Voleti on 11/04/22.
//

import Foundation

struct ErrorModel: Decodable {
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message = "msg"
    }
}

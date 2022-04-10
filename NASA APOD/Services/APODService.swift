//
//  APODService.swift
//  NASA APOD
//
//  Created by Ram Voleti on 10/04/22.
//

import Foundation
import PromiseKit

protocol APODServiceType {
        
    static func getPicture(date: String) -> Promise<APODModel>
}

class APODService: APODServiceType {

    private enum Path: String {
        case onDate = "&date="
    }

    static var service: NetworkDispatcher.Type = BaseNetworkDispatcher.self

    static func getTodaysPicture() -> Promise<APODModel> {
        let request = BaseRequest()
        return service.execute(request: request, for: APODModel.self).compactMap { $0 }
    }
    
    static func getPicture(date: String) -> Promise<APODModel> {
        let request = BaseRequest(path: Path.onDate.rawValue + date)
        return service.execute(request: request, for: APODModel.self).compactMap { $0 }
    }
}

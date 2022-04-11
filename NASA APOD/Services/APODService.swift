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

    /// Call to get the Picture information for the given Date
    ///
    /// - Parameter date: `String` containing the date in YYYY-MM-dd format
    /// - Returns: `Promise<APODModel>` APODModel enclosed in the Promise, returned by the API call
    static func getPicture(date: String) -> Promise<APODModel> {
        let request = BaseRequest(path: Path.onDate.rawValue + date)
        return service.execute(request: request, for: APODModel.self).compactMap { $0 }
    }
}

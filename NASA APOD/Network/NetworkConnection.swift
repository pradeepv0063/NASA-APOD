//
//  NetworkConnection.swift
//  NASA APOD
//
//  Created by Ram Voleti on 11/04/22.
//

import Foundation
import Network

enum NetworkConnectionState {
    case available, unavailable
}

struct NetworkConnection {
    
    static let monitor = NWPathMonitor()
    static var status: NetworkConnectionState = .unavailable
    
    static func startMonitor() {
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.status = .available
            } else {
                self.status = .unavailable
            }
        }
    }
    
    static func stopMonitor() {
        monitor.cancel()
    }
}



//
//  Connectivity.swift
//  App
//
//  Created by MAC HOME on 11/8/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import Network

enum ConnectionState {
    case isActive
    case noConnection
}

extension NWPathMonitor {
    func state() -> ConnectionState {
        var state: ConnectionState = .isActive
        self.pathUpdateHandler = { path in
            state = path.status == .satisfied ? ConnectionState.isActive : ConnectionState.noConnection
        }
        return state
    }
    
    func stateDidChange(block: @escaping (ConnectionState) -> ()) {
        self.pathUpdateHandler = { path in
            block(path.status == .satisfied ? ConnectionState.isActive : ConnectionState.noConnection)
        }
    }
}

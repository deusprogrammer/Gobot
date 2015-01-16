//
//  StarscreamAdapter.swift
//  WebSocketTest
//
//  Created by Michael Main on 1/16/15.
//  Copyright (c) 2015 Michael Main. All rights reserved.
//

import Foundation
import StarscreamOSX

class StarscreamAdapterOSX : WriteableSocket {
    var socket : WebSocket
    
    init(socket: WebSocket) {
        self.socket = socket
    }
    
    init(scheme : String, host : String, path: String) {
        socket = WebSocket(
            url: NSURL(
                scheme: scheme,
                host: host,
                path: path)!)
    }
    
    func write(str: String) {
        socket.writeString(str)
    }
}
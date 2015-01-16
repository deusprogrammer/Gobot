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
    
    required init(scheme : String, host : String, path : String, connect:((Void) -> Void), disconnect:((NSError?) -> Void), text:((String) -> Void)) {
        socket = WebSocket(
            url: NSURL(
                scheme: scheme,
                host: host,
                path: path)!, connect: connect, disconnect: disconnect, text: text)
        socket.connect()
    }
    
    func write(str: String) {
        socket.writeString(str)
    }
}
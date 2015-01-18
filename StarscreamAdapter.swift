//
//  StarscreamAdapter.swift
//  WebSocketTest
//
//  Created by Michael Main on 1/16/15.
//  Copyright (c) 2015 Michael Main. All rights reserved.
//

import Foundation
import StarscreamOSX

class StarscreamAdapter : STOMPClientAdapter, WebSocketDelegate {
    var socket : WebSocket
    var delegate : STOMPClientDelegate?
    
    required init(scheme : String, host : String, path : String) {
        socket = WebSocket(
            url: NSURL(
                scheme: scheme,
                host: host,
                path: path)!)
        socket.connect()
        socket.delegate = self
    }
    
    func write(str: String) {
        socket.writeString(str)
    }
    
    func websocketDidConnect() {
        if delegate != nil {
            delegate?.onConnect()
        }
    }
    
    func websocketDidDisconnect(error: NSError?) {
        if delegate != nil {
            delegate?.onDisconnect(error)
        }
    }
    
    func websocketDidReceiveData(data: NSData) {
        
    }
    
    func websocketDidReceiveMessage(text: String) {
        if delegate != nil {
            delegate?.onReceive(text)
        }
    }
    
    func websocketDidWriteError(error: NSError?) {

    }
}
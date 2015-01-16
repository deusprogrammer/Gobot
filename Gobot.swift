//
//  Gobot.swift
//  WebSocketTest
//
//  Created by Michael Main on 1/16/15.
//  Copyright (c) 2015 Michael Main. All rights reserved.
//

import Foundation

class STOMPClient {
    var socket : WriteableSocket
    
    init(socket: WriteableSocket) {
        self.socket = socket
    }
    
    func websocketDidReceiveData(data: NSData) {
        println("Received data: \(data.length)")
    }
    
    func connect(host: String, version: String) {
        var connectCommand = STOMPConnect(host: host, version: version)
        println(">>\(connectCommand.getCommandString())~")
        socket.write(connectCommand.getCommandString())
    }
    
    func subscribe(destination: String, id: String = "0", ack : String = "auto", body : String? = nil) {
        var subscribeCommand = STOMPSubscribe(id: id, destination: destination, ack: ack, body: body)
        println(">>\(subscribeCommand.getCommandString())~")
        socket.write(subscribeCommand.getCommandString())
    }
    
    func unsubscribe(destination: String, id: String = "0", body : String? = nil) {
        var subscribeCommand = STOMPUnsubscribe(id: id, body: body)
        println(">>\(subscribeCommand.getCommandString())~")
        socket.write(subscribeCommand.getCommandString())
    }
    
    func send(destination : String, contentType : String = "text/plain", body: String) {
        var sendCommand = STOMPSend(destination: destination, contentType: contentType, body: body)
        println(">>\(sendCommand.getCommandString())~")
        socket.write(sendCommand.getCommandString())
    }
    
    func ack(id: String, transaction: String! = nil) {
        var ackCommand = STOMPAck(id: id, transaction: transaction)
        println(">>\(ackCommand.getCommandString())")
        socket.write(ackCommand.getCommandString())
    }
    
    func nack(id: String, transaction: String! = nil) {
        var ackCommand = STOMPNack(id: id, transaction: transaction)
        println(">>\(ackCommand.getCommandString())")
        socket.write(ackCommand.getCommandString())
    }
}

class STOMPFrame : Printable {
    var command : STOMPCommand!
    var headers = Dictionary<String, String>()
    var body : String!
    
    init() {
        
    }
    
    init(stompString : String) {
        var sections = stompString.componentsSeparatedByString("\n\n")
        var headers = sections[0]
        self.body = sections[1]
        var lines = headers.componentsSeparatedByString("\n")
        
        self.command = STOMPCommand(rawValue: lines[0])
        for i in 1..<(lines.count) {
            var pair = lines[i].componentsSeparatedByString(":")
            self.headers[pair[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())] = pair[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
    }
    
    func getCommandString() -> String {
        var commandString = "\(command.rawValue)\n"
        for (key, value) in headers {
            commandString += "\(key):\(value)\n"
        }
        
        if (body != nil) {
            commandString += "\n\(body)"
        } else {
            commandString += "\n"
        }
        
        return "\(commandString)\0"
    }
    
    var description : String {
        return getCommandString()
    }
}

class STOMPConnect : STOMPFrame {
    init(host : String, version : String, body : String? = nil) {
        super.init()
        self.command = STOMPCommand.CONNECT
        self.headers["host"] = host
        self.headers["accept-version"] = version
        self.body = body
    }
}

class STOMPSubscribe : STOMPFrame {
    init(id : String, destination : String, ack : String, body : String? = nil) {
        super.init()
        self.command = STOMPCommand.SUBSCRIBE
        self.headers["id"] = id
        self.headers["destination"] = destination
        self.headers["ack"] = ack
        self.body = body
    }
}

class STOMPUnsubscribe : STOMPFrame {
    init(id : String, body : String? = nil) {
        super.init()
        self.command = STOMPCommand.UNSUBSCRIBE
        self.headers["id"] = id
        self.body = body
    }
}

class STOMPSend : STOMPFrame {
    init(destination : String, contentType : String, body : String? = nil) {
        super.init()
        self.command = STOMPCommand.SEND
        self.headers["destination"] = destination
        self.headers["content-type"] = contentType
        self.body = body
    }
}

class STOMPAck :STOMPFrame {
    init(id : String, transaction: String! = nil) {
        super.init()
        self.command = STOMPCommand.ACK
        self.headers["id"] = id
        if transaction != nil {
            self.headers["transaction"] = transaction
        }
        self.body = body
    }
}

class STOMPNack :STOMPFrame {
    init(id : String, transaction: String! = nil) {
        super.init()
        self.command = STOMPCommand.NACK
        self.headers["id"] = id
        if transaction != nil {
            self.headers["transaction"] = transaction
        }
        self.body = body
    }
}

// Eventually need to expand this to include other commands
enum STOMPCommand : String {
    // Client commands
    case CONNECT     = "CONNECT"
    case SUBSCRIBE   = "SUBSCRIBE"
    case UNSUBSCRIBE = "UNSUBSCRIBE"
    case SEND        = "SEND"
    case ACK         = "ACK"
    case NACK        = "NACK"
    
    // Server commands
    case CONNECTED   = "CONNECTED"
    case MESSAGE     = "MESSAGE"
    case RECEIPT     = "RECEIPT"
    case ERROR       = "ERROR"
}

protocol WriteableSocket {
    func write(str : String)
}
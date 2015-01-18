//
//  ViewController.swift
//  WebSocketTest
//
//  Created by Michael Main on 1/13/15.
//  Copyright (c) 2015 Michael Main. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, STOMPClientDelegate {
    @IBOutlet weak var titleLabel: NSTextField!
    var client : STOMPClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var adapter = StarscreamAdapter(
            scheme: "ws",
            host: "localhost:8080",
            path: "/WebSocketsTest/stomp/websocket"
        )
        adapter.delegate = self
        client = STOMPClient(socket: adapter)
    }
    
    func onConnect() {
        println("websocket is connected")
        client.connect("localhost", version: "1.2")
    }
    
    func onDisconnect(error : NSError?) {
        if let e = error {
            println("websocket is disconnected: \(e.localizedDescription)")
        }
    }
    
    func onReceive(message : String) {
        println("<<\(message)")
        var frame = STOMPFrame(stompString: message)
        
        if frame.command == STOMPCommand.CONNECTED {
            client.subscribe("/queue/IKKICON_AMV")
        } else if frame.command == STOMPCommand.MESSAGE {
            if frame.headers["destination"] == "/queue/IKKICON_AMV" {
                titleLabel.stringValue = frame.body
            }
        } else if frame.command == STOMPCommand.RECEIPT {
            
        } else if frame.command == STOMPCommand.ERROR {
            println("An error has occured: \(frame.body)")
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func onClick(sender: NSButton) {
        // On button click, send message
        client.send("/app/hello", body: "Test")
    }
}


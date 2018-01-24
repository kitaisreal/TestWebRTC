//
//  SocketModel.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation
import Starscream

class SocketModel {
    
    private let mainSocket:WebSocket
    var socketDelegate:SocketDelegate?
    
    init() {
        let mainSocketURL = URL(string:SocketConstants.HOST_URL)!
        mainSocket = WebSocket(url: mainSocketURL)
        mainSocket.onText = {[weak self] text in
            self?.getMessage(message: text)
        }
        
        mainSocket.onConnect = { [weak self] in
            guard let socketDelegate = self?.socketDelegate else {
                return
            }
            socketDelegate.socketOnConnect()
        }
        
        mainSocket.onDisconnect = { [weak self] error in
            guard let socketDelegate = self?.socketDelegate else {
                return
            }
            socketDelegate.socketOnConnect()
        }
    }
    
    func connect() {
        mainSocket.connect()
    }
    
    func sendMessage(message:String) {
        mainSocket.write(string: message)
    }
    
    private func getMessage(message:String) {
        guard let socketDelegate = self.socketDelegate else {
            return
        }
        socketDelegate.socketOnReceiveMessage(message: message)
    }
}

//
//  SocketDelegate.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

protocol SocketDelegate {
    func socketOnConnect()
    func socketOnReceiveMessage(message:String)
    func socketOnDisconnect()
}

//
//  VideoViewModelActions.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/22/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

enum VideoCallViewActions {
    case sendLines
    case receiveLocalVideo(RTCVideoTrack)
    case receiveRemoteVideo(RTCVideoTrack)
    case connected(Bool)
    case connecting
    case disconnected
    case swapRenderViews
//    case receiveMessage(ARDDataMessage)
    //MAYBE NOT LINES
    case receiveLines([Line])
    case error(Error)
}

enum VideoViewModelActions {
    case audioMute
    case audioUnmute
    case videoMute
    case videoUnmute
    case callBreak
    case startVideoTranslation
    case stopVideoTranslation
    case swapCamera
    case swapRenderViews
    //MAYBE NOT LINE
    case sendLines([Line])
}

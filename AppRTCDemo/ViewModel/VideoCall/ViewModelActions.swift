//
//  VideoViewModelActions.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/22/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

enum VideoCallViewActions {
    case sendDrawMessage
    case receiveLocalVideo(RTCVideoTrack)
    case receiveRemoteVideo(RTCVideoTrack)
    case connected(Bool)
    case connecting
    case disconnected
    case swapRenderViews
//    case receiveMessage(ARDDataMessage)
    //MAYBE NOT LINES
    case receiveDrawMessage(DrawMessage)
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
    case initTimer
//    case invalidateTimer
    //MAYBE NOT LINE
    case sendDrawMessage(DrawMessage)
}

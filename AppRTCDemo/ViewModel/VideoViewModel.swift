//
//  VideoViewModel.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/22/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

class VideoViewModel {
    private var appClient:ARDAppClient = ARDAppClient()
    private var initiator:Bool = false
    private var videoViewModelSignalObserver:Signal<VideoViewModelActions,NoError>.Observer
    private let videoCallObserver:Signal<VideoCallViewActions, NoError>.Observer
//    private let timer:Timer
    
    init(videoCallObserver:Signal<VideoCallViewActions, NoError>.Observer) {
        appClient = ARDAppClient()
        appClient.serverHostUrl = AppClientConstants.HOST_URL
        
        self.videoCallObserver = videoCallObserver
        
        let (viewModelSignal,observer) = Signal<VideoViewModelActions, NoError>.pipe()
        videoViewModelSignalObserver = observer
        
        viewModelSignal.observeValues() { [weak self] value in
            switch (value) {
                
            case .audioMute:
                print("VIEW MODEL GET SIGNAL MUTE AUDIO IN")
                self?.appClient.muteAudioIn()
            case .audioUnmute:
                print("VIEW MODEL GET SIGNAL UNMUTE AUDIO IN")
                self?.appClient.unmuteAudioIn()
            case .videoMute:
                print("VIEW MODEL GET SIGNAL MUTE VIDEO IN")
                self?.appClient.muteVideoIn()
            case .videoUnmute:
                print("VIEW MODEL GET SIGNAL UNMUTE VIDEO IN")
                self?.appClient.unmuteVideoIn()
            case .callBreak:
                self?.appClient.disconnect()
            case .startVideoTranslation:
                self?.appClient.startMediaTranslation()
            case .stopVideoTranslation:
                self?.appClient.stopMediaTranslation()
            case .swapCamera:
                //AUTO SWAP IN ARD APP CLIENT.H
                break
            case .swapRenderViews:
                self?.videoCallObserver.send(value: VideoCallViewActions.swapRenderViews)
                break
            case .sendLines(let lines): break
                self?.sendMessage(lines: lines)
            }
        }
        
    }
    
    func sendMessage(lines:[Line]) {
        
    }
    
    func connectToRoom(roomID:String) {
        appClient.delegate = self
        appClient.connectToRoom(withId: roomID, options: nil)
    }
    
    func getInitiator() -> Bool {
        return self.initiator
    }
    
    func getViewModelSignalObserver() -> Signal<VideoViewModelActions,NoError>.Observer {
        return self.videoViewModelSignalObserver
    }
}

extension VideoViewModel:ARDAppClientDelegate {
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        switch state {

        case .disconnected:
            videoCallObserver.send(value: VideoCallViewActions.disconnected)
        case .connecting:
            videoCallObserver.send(value: VideoCallViewActions.connecting)
        case .connected:
            self.initiator = appClient.isInitiator()
            videoCallObserver.send(value: VideoCallViewActions.connected(self.initiator))
        }
    }

    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        print("VIDEO VIEW MODEL RECEIVE LOCAL VIDEO TRACK")
        videoCallObserver.send(value: VideoCallViewActions.receiveLocalVideo(localVideoTrack))
    }

    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        print("VIDEO VIEW MODEL RECEIVE REMOTE VIDEO TRACK")
        videoCallObserver.send(value: VideoCallViewActions.receiveRemoteVideo(remoteVideoTrack))
//        self.remoteVideoTrack = remoteVideoTrack
//        self.remoteVideoTrack?.add(remoteVideoView)
    }

    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        videoCallObserver.send(value: VideoCallViewActions.error(error))
        //END CALL
        appClient.disconnect()
    }
}


extension VideoViewModel:ARDDataMessageReceiverDelegate {
    
    func didReceiverMessage(_ message: ARDSignalingMessage!) {
        //TODO SEND
        print("MESSAGE ")
    }

    func didReceiveDataMessage(_ buffer: RTCDataBuffer!) {
        //TODO SEND
        print("DATA BUFFER")
    }

}


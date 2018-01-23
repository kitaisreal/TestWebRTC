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
    private var timer:Timer?
    private var remoteVideoTrack:RTCVideoTrack?
    private var localVideoTrack:RTCVideoTrack?
    
    init(videoCallObserver:Signal<VideoCallViewActions, NoError>.Observer) {
        appClient = ARDAppClient()
        
        self.videoCallObserver = videoCallObserver
        
        let (viewModelSignal,observer) = Signal<VideoViewModelActions, NoError>.pipe()
        videoViewModelSignalObserver = observer
        
        viewModelSignal.observeValues() { [weak self] value in
            print("BUG VIEW MODEL VALUE \(value)")
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
            case .sendDrawMessage(let drawMessage):
                self?.sendMessage(drawMessage: drawMessage)
            case .initTimer:
                self?.initTimer()
            }
        }
        
    }
    func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: DrawConstants.MESSAGE_TIMER_FIRING_TIME,
                                     target: self,
                                     selector:  (#selector(self.sendReceiveDrawMessageAction)),
                                     userInfo: nil,
                                     repeats: true)
    }
    func invalidateTimer() {
        timer?.invalidate()
    }
    @objc func sendReceiveDrawMessageAction() {
        videoCallObserver.send(value: VideoCallViewActions.sendDrawMessage)
    }
    func sendMessage(drawMessage:DrawMessage) {
//        guard let jsonDataMessage = try? JSONEncoder.init().encode(drawMessage) else {
//            return
//        }
//        let stringData = String(data:jsonDataMessage, encoding: .utf8)
//        print("DATA BUG\(stringData) SEND TO DATA CHANNEL WITH LABEL \(kDrawingDataLabel)")
//        let dataBuffer = RTCDataBuffer(data: jsonDataMessage, isBinary: false)
        guard let jsonDataMessage = try? JSONEncoder.init().encode(drawMessage) else {
            return
        }
        let dataBuffer = RTCDataBuffer(data: jsonDataMessage, isBinary: true)
        appClient.sendData(toDataChannel: dataBuffer, toChannelWithLabel: kDrawingDataLabel)
    }
    
    func connectToRoom(roomID:String) {
        appClient = ARDAppClient(delegate: self)
        appClient.serverHostUrl = AppClientConstants.HOST_URL
        appClient.dataMessageReceiver = self
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
            print("BUG CONNECTING")
            videoCallObserver.send(value: VideoCallViewActions.connecting)
        case .connected:
            self.initiator = appClient.isInitiator()
            print("BUG CONNECTED")
            videoCallObserver.send(value: VideoCallViewActions.connected(self.initiator))
        }
    }

    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        self.localVideoTrack = localVideoTrack
        guard let localTrack = self.localVideoTrack else {
            return
        }
        videoCallObserver.send(value: VideoCallViewActions.receiveLocalVideo(localTrack))
    }

    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        self.remoteVideoTrack = remoteVideoTrack
        guard let remoteTrack = self.remoteVideoTrack else {
            return
        }
        videoCallObserver.send(value: VideoCallViewActions.receiveRemoteVideo(remoteTrack))
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
        
        print("GET MESSAGE \(String(data:buffer.data, encoding:.utf8))")
        print("DATA BUG MESSAGE DID RECEIVE DATA MESSAGE STEP 1 \(String(data:buffer.data,encoding:.utf8))")
        guard let drawMessage = try? JSONDecoder.init().decode(DrawMessage.self, from: buffer.data) else  {
            return
        }
        self.videoCallObserver.send(value: VideoCallViewActions.receiveDrawMessage(drawMessage))
    }

}


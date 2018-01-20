//
//  VideoViewController.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/19/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import UIKit

class VideoViewController: AbstractDrawVC,ARDDataMessageReceiverDelegate,DrawMessageDelegate {
    func didReceiveDataMessage(_ buffer: RTCDataBuffer!) {
        print("DID RECEIVE MESSAGE")
        if (buffer.isBinary == false) {
            guard let string = String(data:buffer.data, encoding:.utf8) else {
                return
            }
            print(string)
        }
    }
    
    var appClient:ARDAppClient?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var drawingImage: UIImageView!
    
    @IBOutlet weak var remoteVideoView: RTCEAGLVideoView!
    
    var remoteVideoTrack:RTCVideoTrack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appClient = ARDAppClient(delegate: self)
        appClient?.dataMessageReceiver = self
        appClient?.serverHostUrl = AppClientConstants.HOST_URL
        self.delegate = self
        self.textField.delegate = self
        self.imageView = drawingImage
        self.drawColor = UIColor.green
    }
    
    @IBAction func swapCameraAction(_ sender: UIButton) {
        appClient?.swapCameraToBack()
    }
    func sendLinesMessage(linesMessage: ARDDataMessage) {
        appClient?.send(linesMessage)
    }
    
    @IBAction func sendDataToChannel(_ sender: UIButton){
        let testStringData = String("TestStringData").data(using: .utf8)
        let rtcDataBuffer = RTCDataBuffer(data: testStringData, isBinary: false)
        print(kDrawingDataLabel)
        appClient?.sendData(toDataChannel: rtcDataBuffer, toChannelWithLabel:kDrawingDataLabel )
    }
    
    @IBAction func startVideoTranslation(_ sender: UIButton) {
        print("START VIDEO TRANSLATION")
//        appClient?.unmuteAudioIn()
//        appClient?.unmuteVideoIn()
        appClient?.startMediaTranslation()
    }
    
    @IBAction func stopMediaTranslation(_ sender: UIButton) {
        print("STOP VIDEO TRANSLATION")
//        appClient?.muteAudioIn()
//        appClient?.muteVideoIn()
        appClient?.stopMediaTranslation()
        
    }
    func didReceiverMessage(_ message: ARDSignalingMessage!) {
        guard let dataMessage = message as? ARDDataMessage else {
            return
        }
        if dataMessage.messageType == "lines" {
            let dataDictionary = dataMessage.dataDictionary
            
            if let dataLines = dataDictionary!["lines"] as? String  {
                let decoder = JSONDecoder()
                guard let lines = try? decoder.decode([Line].self, from: dataLines.data(using: .utf8)!) else {
                    return
                }
                drawLines(lines: lines)
            }
        }
    }
    
    @IBAction func toRoom(_ sender: UIButton) {
        guard let text = textField.text else {
            return
        }
        print("TO ROOM")
        appClient?.connectToRoom(withId: text, options: nil)
    }
}

extension VideoViewController:ARDAppClientDelegate {
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        switch state {
            
        case .disconnected:
            print("APP CLIEND STATE DISCONNECTED")
        case .connecting:
            print("APP CLIENT STATE CONNECTING")
        case .connected:
            print("APP CLIENT STATE CONNECTED")
        }
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        print("RECEIVE REMOTE VIDEO TRACK")
        
        self.remoteVideoTrack = remoteVideoTrack
        self.remoteVideoTrack?.add(remoteVideoView)
    }
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        print(error)
    }
}

extension VideoViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

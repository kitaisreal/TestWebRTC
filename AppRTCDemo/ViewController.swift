//
//  ViewController.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/17/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ARDAppClientDelegate,RTCEAGLVideoViewDelegate,UITextFieldDelegate,ARDDataMessageReceiverDelegate {
    
    let testMessage:ARDDataMessage = ARDDataMessage(typeAndData: "image", data: ["message":"testDataMessage"])
    var appClient:ARDAppClient?
    var localVideoTrack:RTCVideoTrack?
    var remoteVideoTrack:RTCVideoTrack?
    
    @IBOutlet weak var remoteView: RTCEAGLVideoView!
    @IBOutlet weak var localView: RTCEAGLVideoView!
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        appClient = ARDAppClient(delegate: self)
        appClient?.dataMessageReceiver = self
        appClient?.serverHostUrl = AppClientConstants.HOST_URL
        textField.delegate = self
        print(appClient?.state)
        remoteView.delegate = self
        localView.delegate = self
        let testStringData = String("TestStringData").data(using: .utf8)
        let test:RTCDataBuffer = RTCDataBuffer(data: testStringData, isBinary: false)
        
    }
    
    @IBAction func addVideoStream(_ sender: UIButton) {
//        appClient?.addMediaStream()
    }
    func didReceiverMessage(_ message: ARDSignalingMessage!) {
        print("RECEIVE MESSAGE IN APP VIEW CONTROLLER")
        print(message)
        if let dataMessage = message as? ARDDataMessage {
            print("DATA MESSAGE TYPE \(dataMessage.type)")
        }
    }
    
    @IBAction func swapCamera(_ sender: UIButton) {
        appClient?.swapCameraToBack()
        appClient?.send(testMessage)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK ARD APP CLIENT DELEGATE
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        //HANDLE ERROR
        print(error)
//        fatalError()
    }
    
    @IBAction func toRoom(_ sender: UIButton) {
        appClient?.connectToRoom(withId: textField.text!, options: nil)
    }
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        switch state {
            
        case .disconnected:
            print("DISCONNECTED")
        case .connecting:
            print("CONNECTING")
        case .connected:
            print("CONNECTED")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        print("GET LOCAL VIDEO TRACK SET TO VIEW")
        self.localVideoTrack = localVideoTrack
        self.localVideoTrack?.add(localView)
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        print("GET REMOTE VIDEO TRACK SET TO VIEW")
        self.remoteVideoTrack = remoteVideoTrack
        self.remoteVideoTrack?.add(remoteView)
    }
    
    func videoView(_ videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
        print("SIZE HANDLE \(size)")
    }
    
}


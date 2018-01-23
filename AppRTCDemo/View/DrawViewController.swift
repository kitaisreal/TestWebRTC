//
//  DrawViewController.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/18/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController,ARDDataMessageReceiverDelegate {
    func didReceiveDataMessage(_ buffer: RTCDataBuffer!) {
        print()
    }
    
    
    var timer = Timer()
    
    func didReceiverMessage(_ message: ARDSignalingMessage!) {
        guard let dataMessage = message as? ARDDataMessage else {
            return
        }
//        print("GET DATA MESSGAGE ")
//        print("GET DATA MESSAGE \(dataMessage.messageType)")
//        print("GET DATA MESSAGE \(dataMessage.type)")
//        print("GET DATA MESSAGE \(dataMessage.dataDictionary)")
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
    
    @IBOutlet weak var textField: UITextField!
    
    var drawBool = false
    
    private var swipped = false
    private var lastPoint = CGPoint.zero
    private var lines:[Line] = []
    private var oldLines:[Line] = []
    
    var appClient:ARDAppClient?
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: (#selector(self.sendMessage)), userInfo: nil, repeats: true)
        
        textField.delegate = self
//        appClient = ARDAppClient()
        appClient = ARDAppClient(delegate: self)
        appClient?.dataMessageReceiver = self
        appClient?.serverHostUrl = AppClientConstants.HOST_URL
    }
    
    @objc func sendMessage() {
        print("TIMER CHECK TO SEND MESSAGE")
        if (oldLines.count != lines.count) {
            print("TIMER SEND MESSAGE")
            print("OLD LINES COUNT \(oldLines.count)")
            print("LINES COUNT \(lines.count)")
            let linesDifferrence = lines.differrence(with: oldLines)
            guard let linesData = try? JSONEncoder().encode(linesDifferrence) else {
                return
            }
//            print("LINES DIFFERENCE \(lines.differrence(with: oldLines).count)")
            let linesMessage:ARDDataMessage = ARDDataMessage(typeAndData: "lines", data: ["lines":String(data:linesData, encoding: .utf8)!])
            appClient?.send(linesMessage)
            oldLines = self.lines.copy()
//          self.lines.removeAll()
        }
    }
    
    @IBAction func connectToRoom(_ sender: UIButton) {
        guard let text = textField.text else {
            return
        }
        print("CONNECT TO ROOM")
        appClient?.connectToRoom(withId: text, options: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    func drawLines(lines:[Line]) {
        for line in lines {
            UIGraphicsBeginImageContext(self.view.frame.size)
            imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            let context = UIGraphicsGetCurrentContext()
            let startPoint = line.startPoint
            let endPoint = line.endPoint
            context?.beginPath()
            context?.move(to: startPoint)
            context?.addLine(to: endPoint)
            context?.setLineWidth(1)
            context?.setStrokeColor(UIColor.green.cgColor)
            context?.strokePath()
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
    func drawLines(fromPoint:CGPoint,toPoint:CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        let startPoint = CGPoint(x: fromPoint.x, y: fromPoint.y)
        let endPoint = CGPoint(x: toPoint.x, y: toPoint.y)
        context?.move(to: startPoint)
        context?.addLine(to: endPoint)
        lines.append(Line(startPoint: startPoint, endPoint: endPoint))
        print(lines.count)
        context?.setLineWidth(1)
        context?.setStrokeColor(UIColor.green.cgColor)
        context?.strokePath()
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func sendLinesToChannel() {
        guard let linesData = try? JSONEncoder().encode(self.lines) else {
            return
        }
        let linesMessage:ARDDataMessage = ARDDataMessage(typeAndData: "lines", data: ["lines":String(data:linesData, encoding: .utf8)!])
        appClient?.send(linesMessage)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        swipped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swipped {
            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
}

extension DrawViewController:ARDAppClientDelegate {
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
        
    }
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        print(error)
    }
}

extension DrawViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

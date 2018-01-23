//
//  VideoCallViewController.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/22/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class VideoCallViewController: UIViewController {
    
    private var videoViewModel:VideoViewModel
    private var videoViewModelObserver:Signal<VideoViewModelActions,NoError>.Observer
    private var videoCallSignal:Signal<VideoCallViewActions,NoError>
    
    var roomID:String?
    
    @IBOutlet weak var drawView: DrawView!
    
    @IBOutlet weak var endCallButton: UIButton!
    @IBOutlet weak var swapRenderViewsButton: UIButton!
    @IBOutlet weak var audioMuteUnmuteButton: UIButton!
    @IBOutlet weak var videoMuteUnmuteButton: UIButton!
    @IBOutlet weak var drawLinesButton: UIButton!
    
    
    @IBOutlet weak var remoteVideoView: RTCEAGLVideoView!
    @IBOutlet weak var localVideoView: RTCEAGLVideoView!
    
    
    @IBOutlet weak var bottomMenu: UIView!
    
    
    private var drawState:MutableProperty<Bool> = MutableProperty<Bool>(false)
    private var audioState:Bool = true
    private var videoState:Bool = true
    private var videoRenderState:Bool = true
    
    convenience override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let (signal,observer) = Signal<VideoCallViewActions,NoError>.pipe()
        videoCallSignal = signal
        videoViewModel = VideoViewModel(videoCallObserver: observer)
        videoViewModelObserver = videoViewModel.getViewModelSignalObserver()
    }
    
    required init(coder aDecoder: NSCoder) {
        let (signal,observer) = Signal<VideoCallViewActions,NoError>.pipe()
        videoCallSignal = signal
        
        videoViewModel = VideoViewModel(videoCallObserver: observer)
        videoViewModelObserver = videoViewModel.getViewModelSignalObserver()
        
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let roomID = roomID else {
            return
        }
        drawView.drawBool = drawState
       
        //SIGNAL OBSERVE
        
        videoCallSignal.observeValues() { [weak self] value in
            switch (value) {
                
            case .sendDrawMessage:
                print("SEND DRAW MESSAGE")
                if let drawMessage = self?.drawView.getDrawMessage() {
                    self?.videoViewModelObserver.send(value: VideoViewModelActions.sendDrawMessage(drawMessage))
                }
            case .receiveLocalVideo(let localVideoTrack):
                localVideoTrack.add(self?.localVideoView)
            case .receiveRemoteVideo(let remoteVideoTrack):
                remoteVideoTrack.add(self?.remoteVideoView)
            case .connected:
                print("connected")
            case .connecting:
                print("connecting")
            case .disconnected:
                print("disconnecting")
                self?.dismiss(animated: true, completion: nil)
            case .swapRenderViews:
                print("swap render views")
                //TODO
                self?.swapRenderViews()
            case .receiveDrawMessage(let drawMessage):
                
                print("RECEIVE DRAW MESSAGE")
                self?.drawView.drawDrawMessage(drawMessage: drawMessage)
            case .error(let error):
                print("Receive error \(error)")
               self?.videoViewModelObserver.send(value: VideoViewModelActions.callBreak)
            }
        }
        
        //BUTTONS ACTIONS
        endCallButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues() { [weak self] button in
                self?.videoViewModelObserver.send(value: VideoViewModelActions.callBreak)
        }
        audioMuteUnmuteButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues() { [weak self] button in
                if button.image(for: .normal) == #imageLiteral(resourceName: "ic_audioOff") {
                    button.setImage(#imageLiteral(resourceName: "ic_audioOn"), for: .normal)
                } else {
                    button.setImage(#imageLiteral(resourceName: "ic_audioOff"), for: .normal)
                }
                if let audioState = self?.audioState {
                    self?.audioState = !audioState
                    audioState ? self?.videoViewModelObserver.send(value: VideoViewModelActions.audioMute) : self?.videoViewModelObserver.send(value: VideoViewModelActions.audioUnmute)
                }
        }
        swapRenderViewsButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues() { [weak self] button in
                //ADD SWAP RENDER VIEWS
                self?.videoViewModelObserver.send(value: VideoViewModelActions.swapRenderViews)
        }
        videoMuteUnmuteButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues() { [weak self] button in
                if button.image(for: .normal) == #imageLiteral(resourceName: "ic_videoOff") {
                    button.setImage(#imageLiteral(resourceName: "ic_videoOn"), for: .normal)
                } else {
                    button.setImage(#imageLiteral(resourceName: "ic_videoOff"), for: .normal)
                }
                if let videoState = self?.videoState {
                    self?.videoState = !videoState
                    videoState ? self?.videoViewModelObserver.send(value: VideoViewModelActions.videoMute) : self?.videoViewModelObserver.send(value: VideoViewModelActions.videoUnmute)
                }
        }
        drawLinesButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues() { [weak self] button in
                button.tintColor = button.tintColor == .white ? #colorLiteral(red: 0, green: 0.9803921569, blue: 0.5725490196, alpha: 1) : .white
                
                if let drawStateValue = self?.drawState.value {
                    drawStateValue ? self?.hideDrawAnnotations() : self?.showDrawAnnotations()
                    self?.drawState.value = !drawStateValue
                }
        }
//        swapRenderViewsButton.reactive
//            .controlEvents(.touchUpInside)
//            .observeValues() { [weak self] button in
//               self?.videoViewModelObserver.send(value: VideoViewModelActions.swapRenderViews)
//        }
        
        videoViewModel.connectToRoom(roomID: roomID)
        
        videoViewModelObserver.send(value: VideoViewModelActions.initTimer)
        
        initButtonColors()
    }
    //MARK - SWAP RENDER VIEWS
    private func swapRenderViews() {
        print("SWAP RENDER VIEWS FUNCTION SECOND STEP")
//        if (videoRenderState) {
//            remoteVideoTrack?.remove(remoteVideoView)
//            localVideoTrack?.remove(localVideoView)
//            remoteVideoTrack?.add(localVideoView)
//            localVideoTrack?.add(remoteVideoView)
//        } else {
//            remoteVideoTrack?.remove(localVideoView)
//            localVideoTrack?.remove(remoteVideoView)
//            remoteVideoTrack?.add(localVideoView)
//            localVideoTrack?.add(remoteVideoView)
//        }
//        videoRenderState = !videoRenderState
    }
    //MARK - BUTTON COLOR INIT
    private func initButtonColors() {
        endCallButton.setImage(#imageLiteral(resourceName: "ic_hangup").withRenderingMode(.alwaysTemplate), for: .normal)
        endCallButton.tintColor = UIColor.red
        
        drawLinesButton.setImage(#imageLiteral(resourceName: "ic_gesture_white").withRenderingMode(.alwaysTemplate), for: .normal)
        drawLinesButton.tintColor = UIColor.white
    }
    //MARK - ANNOTATIONS
    private var isDrawAnnotationsShow = false
    
    private func showDrawAnnotations() {
        UIView.animate(withDuration: 0.6) {
            self.bottomMenu.transform = CGAffineTransform(translationX: 0, y: -self.bottomMenu.bounds.height + AnimationConstants.annotationsHeightOffset)
        }
        isDrawAnnotationsShow = !isDrawAnnotationsShow
    }
    
    private func hideDrawAnnotations() {
        UIView.animate(withDuration: 0.6) {
            self.bottomMenu.transform = CGAffineTransform.identity
        }
        isDrawAnnotationsShow = !isDrawAnnotationsShow
    }
}

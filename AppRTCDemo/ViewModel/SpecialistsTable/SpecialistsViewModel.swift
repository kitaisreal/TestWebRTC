//
//  SpecialistsTableViewModel.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

class SpecialistsViewModel: SocketDelegate {
   
    private let socketModel:SocketModel = SocketModel()
    private var viewModelObserver:Signal<SpecialistsViewModelActions,NoError>.Observer
    private let viewObserver:Signal<SpecialistsViewActions,NoError>.Observer
    private let messageBuilder:MessageBuilder = MessageBuilder()
    private let selfId:String
    private var delegate:SpecialistsViewModelDelegate?
    
    init(viewObserver:Signal<SpecialistsViewActions,NoError>.Observer) {
        
        selfId = Authorization.instance.getYourSpecialist()!.id
        self.viewObserver = viewObserver
        let (signal,observer) = Signal<SpecialistsViewModelActions,NoError>.pipe()
        self.viewModelObserver = observer
        print("RECEIVE VIEW MODEL INIT SELF ID \(selfId)")
        signal.observeValues() { [weak self] values in
            switch (values) {
            
            case .callOffer(let offerFor):
                print("RECEIVE CALL OFFER ACTION OFFER FOR \(offerFor)")
                self?.makeCallOfferFor(for: offerFor)
            case .callAnswer(let idFor):
                print("RECEIVE CALL ANSWER ACTION ANSWER FOR \(idFor)")
                self?.makeCallAnswerFor(for: idFor)
            }
        }
        
    }
    func setDelegate(delegate:SpecialistsViewModelDelegate) {
        self.delegate = delegate
    }
    func getViewModelObserver() -> Signal<SpecialistsViewModelActions,NoError>.Observer {
        return self.viewModelObserver
    }
    
    func makeCallAnswerFor(for id:String) {
        let randomRoom = Utils.generateRandomId()
        guard let message = messageBuilder.buildCallAnswerMessage(id: selfId, for: id, room: randomRoom).toString() else {
            return
        }
        socketModel.sendMessage(message: message)
        delegate?.toRoom(roomID: randomRoom)
    }
    
    func makeCallOfferFor(for id:String) {
        guard let message = messageBuilder.buildCallMessage(id: selfId, for: id).toString() else {
            return
        }
        print("RECEIVE VIEW MODEL MAKE OFFER FOR \(id) SELF ID \(selfId) \(message)")
        socketModel.sendMessage(message: message)
    }
        
    func connectToSocketServer() {
        socketModel.socketDelegate = self
        socketModel.connect()
       
    }
    
    func sendLogInForMessage(id:String, for secondId:String) {
        guard let message = messageBuilder.buildLogInForMessage(id: id, for: secondId).toString() else {
            return
        }
        self.socketModel.sendMessage(message: message)
    }
    
    func socketOnConnect() {
        if let authSpecialist = Authorization.instance.getYourSpecialist(),
            let message = messageBuilder.buildLogInMessage(id: authSpecialist.id).toString()  {
            socketModel.sendMessage(message: message)
        }
    }
    
    func socketOnReceiveMessage(message: String) {
        guard let data = message.data(using: .utf8), let messageModel = try? JSONDecoder.init().decode(Message.self, from: data) else {
            return
        }
        if (messageModel.messageType == MessageTypes.LOG_IN) {
            print("RECEIVE VIEW MODEL LOG IN MESSAGE")
            self.sendLogInForMessage(id: selfId, for: messageModel.idFrom)
            viewObserver.send(value: SpecialistsViewActions.log_in(messageModel.idFrom))
        }
        
        if (messageModel.messageType == MessageTypes.LOG_OUT) {
            print("RECEIVE VIEW MODEL LOG OUT MESSAGE")
            viewObserver.send(value: SpecialistsViewActions.log_out(messageModel.idFrom))
        }
        
        if (messageModel.messageType == MessageTypes.CALL_OFFER
            && messageModel.data[CallOfferKeys.CALL_OFFER_FOR] == selfId) {
            print("RECEIVE VIEW MODEL CALL OFFER MESSAGE")
            let id = messageModel.idFrom
            viewObserver.send(value: SpecialistsViewActions.callOffer(id))
        }
        
        if (messageModel.messageType == MessageTypes.CALL_ANSWER
            && messageModel.data[CallAnswerKeys.CALL_ANSWER_FOR] == selfId) {
            let room = messageModel.data[CallAnswerKeys.CALL_ROOM_ID]!
            print("RECEIVE VIEW MODEL CALL ANSWER WITH ROOM \(room) ID FROM \(messageModel.idFrom)")
            viewObserver.send(value: SpecialistsViewActions.callAnswer(room))
        }
        
        if (messageModel.messageType == MessageTypes.LOG_IN_FOR
            && messageModel.data[LogInForKeys.LOG_IN_FOR] == selfId) {
            print("RECEIVE VIEW MODEL LOG IN FOR MESSAGE")
            viewObserver.send(value: SpecialistsViewActions.log_in(messageModel.idFrom))
        }
    }
    
    func socketOnDisconnect() {
        print("SOCKET ON DISCONNECT")
    }
}


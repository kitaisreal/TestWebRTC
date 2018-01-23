//
//  MessageBuilder.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

class MessageBuilder {
    func buildLogInMessage(id:String) -> Message {
        return Message(idFrom: id, data: [:], messageType: MessageTypes.LOG_IN)
    }
    
    func buildLogOutMessage(id:String) -> Message {
        return Message(idFrom: id, data: [:], messageType: MessageTypes.LOG_OUT)
    }
    
    func buildCallMessage(id:String, for secondId:String) -> Message {
        var data:[String:String] = [:]
        data.updateValue(secondId, forKey: CallOfferKeys.CALL_OFFER_FOR)
        return Message(idFrom: id, data: data, messageType: MessageTypes.CALL_OFFER)
    }
    
    func buildCallAnswerMessage(id:String, for secondId:String, room:String) -> Message {
        var data:[String:String] = [:]
        data.updateValue(secondId, forKey: CallAnswerKeys.CALL_ANSWER_FOR)
        data.updateValue(room, forKey: CallAnswerKeys.CALL_ROOM_ID)
        return Message(idFrom: id, data: data, messageType: MessageTypes.CALL_ANSWER)
    }
    
}

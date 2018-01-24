//
//  MessageTypes.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

struct MessageTypes {
    static let LOG_IN = "log_in"
    static let LOG_OUT = "log_out"
    static let CALL_OFFER = "call_offer"
    static let CALL_ANSWER = "call_answer"
    static let LOG_IN_FOR = "log_in_for"
}
struct LogInForKeys {
    static let LOG_IN_FOR = "log_in_for"
}
struct CallOfferKeys {
    static let CALL_OFFER_FOR = "call_offer_for"
}

struct CallAnswerKeys {
    static let CALL_ANSWER_FOR = "call_answer_for"
    static let CALL_ROOM_ID = "call_room_id"
}

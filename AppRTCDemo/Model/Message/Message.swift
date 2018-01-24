//
//  Message.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

class Message:Codable {
    
    let idFrom:String
    let data:[String:String]
    let messageType:String
    
    enum CodingKeys: String, CodingKey {
        case idFrom = "id_from"
        case data = "data"
        case messageType = "message_type"
    }
    
    init(idFrom:String, data:[String:String], messageType:String) {
        self.idFrom = idFrom
        self.data = data
        self.messageType = messageType
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.idFrom = try values.decode(String.self, forKey: .idFrom)
        self.data = try values.decode([String:String].self, forKey: .data)
        self.messageType = try values.decode(String.self, forKey: .messageType)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(idFrom, forKey: .idFrom)
        try container.encode(data, forKey: .data)
        try container.encode(messageType, forKey: .messageType)
    }

}

extension Message {
    
    func toString() -> String? {
        guard let messageData = try? JSONEncoder.init().encode(self) else {
            return nil
        }
        let stringResult = String(data:messageData, encoding: .utf8)
        return stringResult
    }
    
}

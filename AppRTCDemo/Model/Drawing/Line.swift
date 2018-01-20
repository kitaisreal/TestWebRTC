//
//  Line.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/18/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

class Line:Codable {
    
    let startPoint:CGPoint
    let endPoint:CGPoint
    
    enum CodingKeys: String, CodingKey
    {
        case startPoint = "startPoint"
        case endPoint = "endPoint"
    }
    
    init(startPoint:CGPoint, endPoint:CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    //CHANGE TO STRUCT
    func cloneLine() -> Line {
        return Line(startPoint: self.startPoint, endPoint: self.endPoint)
    }

    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let startString = try values.decode(String.self, forKey: .startPoint)
        let endString = try values.decode(String.self, forKey: .endPoint)
        let start = CGPointFromString(startString)
        let end = CGPointFromString(endString)
        self.startPoint = start
        self.endPoint = end
    }
    
    
    func encode(to encoder: Encoder) throws
    {
        let startPointValue = "{" + startPoint.x.description + "," + startPoint.y.description + "}"
        let endPointValue = "{" + endPoint.x.description + "," + endPoint.y.description + "}"
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startPointValue, forKey: .startPoint)
        try container.encode(endPointValue, forKey: .endPoint)
    }
}

extension Line:Equatable {
    static func ==(lhs: Line, rhs: Line) -> Bool {
        return lhs.startPoint == rhs.startPoint && lhs.endPoint == rhs.endPoint
    }
}


//
//  PathsConvertTestTests.swift
//  AppRTCDemoTests
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import XCTest
@testable import AppRTCDemo

class PathsConvertTestTests:XCTestCase {
    
    func testPathsCodable() {
        let firstPoint:CGPoint = CGPoint(x: 5.6, y: 4.3)
        let secondPoint:CGPoint = CGPoint(x: 8.0, y: 4.5)
        let thirdPoint:CGPoint = CGPoint(x: 9.8, y: 5.6)
        let path = Path(path: [firstPoint, secondPoint, thirdPoint])
        let secondPath = Path(path: [secondPoint, firstPoint, thirdPoint])
        let drawMessage = DrawMessage(paths: [path, secondPath], frameHeight: 400, frameWidth: 500)
        print("TEST PATHS CODABLE")
        let test = try? JSONEncoder.init().encode(drawMessage)
        let string = String(data:test!, encoding: .utf8)
        print("TEST MESSAGE \(string)")
        if let drawDecodableMessage = try? JSONDecoder.init().decode(DrawMessage.self, from: test!) {
            print(drawDecodableMessage.frameHeight)
            print(drawDecodableMessage.frameWidth)
            for i in drawDecodableMessage.drawPaths {
                for point in i.path {
                    print("POINT X \(point.x) Y \(point.y)")
                }
            }
            
        }
    }
    func testPathsDecodable() {
        
    }
}

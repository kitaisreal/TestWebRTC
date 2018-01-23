//
//  LinesMessage.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

class DrawMessage:Codable {
    let frameHeight:Double
    let frameWidth:Double
    let drawPaths:[Path]
    
    enum CodingKeys: String, CodingKey
    {
        case paths = "paths"
        case frameWidth = "frameWidth"
        case frameHeight = "frameHeight"
    }
    
    init(paths:[Path], frameHeight:Double, frameWidth:Double) {
        self.drawPaths = paths
        self.frameHeight = frameHeight
        self.frameWidth = frameWidth
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.frameWidth = try values.decode(Double.self, forKey: .frameWidth)
        self.frameHeight = try values.decode(Double.self, forKey: .frameHeight)
        let doubleArray = try values.decode([[[Double]]].self, forKey: .paths)
        var paths:[Path] = []
        for doublePath in doubleArray {
            let path = Path(path: doublePath)
            paths.append(path)
        }
        self.drawPaths = paths
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let pathsDoubleArray = self.drawPaths.toDoubleArray()
        try container.encode(pathsDoubleArray, forKey: .paths)
        try container.encode(self.frameHeight, forKey: .frameHeight)
        try container.encode(self.frameWidth, forKey: .frameWidth)
    }
}

fileprivate extension Array where Element == Path {
    func toDoubleArray() -> [[[Double]]] {
        var doubleArray:[[[Double]]] = []
        for path in self {
            doubleArray.append(path.toDoubleArray())
        }
        return doubleArray
    }
    
}

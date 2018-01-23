//
//  Path.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

class Path:Codable {
    var path:[CGPoint] = []
    
    init(path:[CGPoint]) {
        self.path = path
    }
    
    convenience init(path:[[Double]]) {
        var pathToReturn:[CGPoint] = []
        for element in path {
            let point = CGPoint(array: element)
            pathToReturn.append(point)
        }
        self.init(path: pathToReturn)
    }
    
    func toDoubleArray() -> [[Double]]{
        return path.toDoubleArray()
    }
    
    func copy() -> Path {
        return Path(path: self.path)
    }
}


extension Path:Equatable {
    static func ==(lhs: Path, rhs: Path) -> Bool {
        return lhs.path == rhs.path
    }
}


fileprivate extension Array where Element == CGPoint {
    func toDoubleArray() -> [[Double]]{
        var array:[[Double]] = []
        for point in self {
            array.append(point.toDoubleArray())
        }
        return array
    }
}
fileprivate extension CGPoint {
    func toDoubleArray() -> [Double] {
        let x:Double = Double(self.x)
        let y:Double = Double(self.y)
        let array:[Double] = [x,y]
        return array
    }
    init(array:[Double]) {
        guard array.count == 2 else {
            self.init()
            return
        }
        self.init(x: array[0], y: array[1])
    }
}

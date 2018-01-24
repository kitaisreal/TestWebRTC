//
//  Utils.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/19/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

extension Array where Element == Line {
    func copy() -> [Line] {
        var buffer:[Line] = []
        for line in self {
            buffer.append(line.cloneLine())
        }
        return buffer
    }
    
    func differrence(with secondArray:[Line]) -> [Line]{
        let buffer = self.copy()
        return buffer.filter() {
            return (!secondArray.contains($0))
        }
    }
}
class Utils {
    static func generateRandomId() -> String {
        return String(Utils.randomInt(min: 1000000, max: 100000000))
    }
    static func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}
extension Array where Element == Path {
    func copy() -> [Path] {
        var buffer:[Path] = []
        for path in self {
            buffer.append(path)
        }
        return buffer
    }
    
    func difference(with secondArray:[Path]) -> [Path] {
        let buffer = self.copy()
        return buffer.filter() {
            return (!secondArray.contains($0))
        }

    }
}

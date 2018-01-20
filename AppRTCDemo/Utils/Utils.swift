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

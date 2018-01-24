//
//  SpecialistModel.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

class SpecialistModel {
    let name:String
    let speciality:String
    let image:String
    let town:String
    let id:String
    let password:String
    
    init(id:String,name:String, speciality:String, image:String, town:String, password:String) {
        self.name = name
        self.speciality = speciality
        self.image = image
        self.town = town
        self.id = id
        self.password = password
    }
}

extension Array where Element == SpecialistModel {
    func getIndex(id:String) -> Int? {
        var getIndex:Int? = nil
        for (index,specialist) in self.enumerated() {
            if (specialist.id == id) {
                getIndex = index
                return getIndex
            }
        }
        return getIndex
    }
}

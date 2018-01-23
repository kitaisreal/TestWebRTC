//
//  Authorization.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

class Authorization {
    private let specialistsRepository:SpecialistsRepository
    private var yourSpecialist:SpecialistModel?
    static let instance = Authorization()
    
    private init() {
        specialistsRepository = SpecialistsRepository()
    }
    
    func authorizate(name:String, password:String) -> Bool{
        guard let specialist = specialistsRepository.checkAuthorization(name: name, password: password) else {
            return false
        }
        self.yourSpecialist = specialist
        return true
    }
    
    
}

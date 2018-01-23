//
//  SpecialistsRepository.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation

class SpecialistsRepository {
    private var specialists:[SpecialistModel] = []
    
    init() {
        let firstSpecialist = SpecialistModel(id: "21348923849",
                                              name: "Joe Sanders",
                                              speciality: "Master Electirican",
                                              image: "NULL",
                                              town: "Seattle, WA",
                                              password:"123456")
        let secondSpecialist = SpecialistModel(id: "39493294923",
                                               name: "Derrick Fields",
                                               speciality: "Operations Manager",
                                               image: "NULL",
                                               town: "Olympia, WA",
                                               password: "12345")
        let thirdSpecialist = SpecialistModel(id: "2394923942933",
                                              name: "Pete Hawkins",
                                              speciality: "Marine Electirican",
                                              image: "NULL",
                                              town: "Chicago, LT",
                                              password: "1234")
        specialists = [firstSpecialist, secondSpecialist, thirdSpecialist]
    }
    
    
    func checkAuthorization(name:String, password:String) -> SpecialistModel? {
        for specialist in specialists {
            if (specialist.name == name && specialist.password == password) {
                return specialist
            }
        }
        return nil
    }
}

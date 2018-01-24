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
        //"Joe Sanders"
        //"Derrick Fields"
        //"Pete Hawkins"
        let firstSpecialist = SpecialistModel(id: "21348923849",
                                              name: "a",
                                              speciality: "Master Electirican",
                                              image: "ic_career_Joe",
                                              town: "Seattle, WA",
                                              password:"1")
        let secondSpecialist = SpecialistModel(id: "39493294923",
                                               name: "b",
                                               speciality: "Operations Manager",
                                               image: "NULL",
                                               town: "Olympia, WA",
                                               password: "2")
        let thirdSpecialist = SpecialistModel(id: "2394923942933",
                                              name: "c",
                                              speciality: "Marine Electirican",
                                              image: "ic_career_Pete",
                                              town: "Chicago, LT",
                                              password: "3")
        specialists = [firstSpecialist, secondSpecialist, thirdSpecialist]
    }
    
    func getSpecialists() -> [SpecialistModel] {
        return self.specialists
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

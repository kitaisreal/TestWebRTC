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
                                              image: "ic_career_Joe",
                                              town: "Seattle, WA",
                                              password:"1")
        let secondSpecialist = SpecialistModel(id: "39493294923",
                                               name: "Derrick Fields",
                                               speciality: "Operations Manager",
                                               image: "ic_career_Derrick",
                                               town: "Olympia, WA",
                                               password: "2")
        let thirdSpecialist = SpecialistModel(id: "2394923942933",
                                              name: "Pete Hawkins",
                                              speciality: "Marine Electirican",
                                              image: "ic_career_Pete",
                                              town: "Chicago, IL",
                                              password: "3")
        let fourthSpecialist = SpecialistModel(id: "99123949829134",
                                              name: "Marcus Lowe",
                                              speciality: "Journeyman Electrician ",
                                              image: "ic_career_Marcus",
                                              town: "Portland, OR",
                                              password: "4")
        let fifthSpecialist = SpecialistModel(id: "8923458938945",
                                               name: "Bob Haley",
                                               speciality: "Sr. Mechanical Engineer",
                                               image: "ic_career_Bob",
                                               town: "Atlanta, WA",
                                               password: "5")
        let sixSpecialist = SpecialistModel(id: "273485782345734",
                                               name: "Clint Simpson",
                                               speciality: "Apprentice Electrician",
                                               image: "ic_career_Clint",
                                               town: "Kent, WA",
                                               password: "6")
        let sevenSpecialist = SpecialistModel(id: "43543513241234",
                                            name: "Cory Mason",
                                            speciality: "Maintenance Technician",
                                            image: "ic_career_Cory",
                                            town: "Eugene, OR",
                                            password: "7")
        specialists = [firstSpecialist, secondSpecialist, thirdSpecialist, fourthSpecialist, fifthSpecialist, sixSpecialist, sevenSpecialist]
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

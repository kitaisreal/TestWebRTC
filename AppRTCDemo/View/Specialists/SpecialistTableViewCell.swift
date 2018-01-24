//
//  SpecialistTableViewCell.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import UIKit

class SpecialistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var specialistImageView: UIImageView!
    
    @IBOutlet weak var specialistName: UILabel!
    
    @IBOutlet weak var specialistCareer: UILabel!
    
    @IBOutlet weak var specialistCity: UILabel!
    
    @IBOutlet weak var specialistAvailableLabel: UILabel!
    
    @IBOutlet weak var specialistAvailableStatus: UILabel!
    
    var status:Bool = false
    
    func setContent(specialist:SpecialistModel) {
        self.specialistCity.text = specialist.town
        self.specialistName.text = specialist.name
        self.specialistCareer.text = specialist.speciality
        //TODO LOAD
        self.specialistImageView.image = UIImage(named: specialist.image)
    }
    
    func updateStatus() {
        status ? setAvailableStatus() : setBusyStatus()
        status = !status
    }
    
    func setAvailableStatus() {
        specialistAvailableLabel.text = "Available"
        specialistAvailableStatus.textColor = UIColor.green
    }
    
    func setBusyStatus() {
        specialistAvailableLabel.text = "Busy"
        specialistAvailableStatus.textColor = UIColor.red
    }
}

//
//  RoomNavigationViewController.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/22/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import UIKit

class RoomNavigationViewController: UIViewController {

    @IBOutlet weak var roomIDTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomIDTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func roomNavigate(_ sender: UIButton) {
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinitionVC = segue.destination as? VideoCallViewController else {
            return
        }
        if let roomID = roomIDTextField.text {
            destinitionVC.roomID = roomID
        }
    }

}

extension RoomNavigationViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        roomIDTextField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        roomIDTextField.resignFirstResponder()
    }
}


//
//  AuthorizationViewController.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {

    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func logIn(_ sender: UIButton) {
        guard let nameText = nameTextField.text, let passwordText = passwordTextField.text else {
            return
        }
        //IMPLEMENT LOG IN WITHOUT SENDER
        _ = Authorization.instance.authorizate(name: nameText, password: passwordText)
    }
}

extension AuthorizationViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}




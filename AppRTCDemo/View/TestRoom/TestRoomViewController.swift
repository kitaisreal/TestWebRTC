//
//  TestRoomViewController.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import UIKit

class TestRoomViewController: UIViewController {
    
    @IBOutlet weak var roomIdTextField: UILabel!
    var roomId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TEST ROOM VIEW DID LOAD \(roomId)")
        if let roomId = roomId {
            roomIdTextField.text = roomId
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRoomId(roomID:String) {
        print("SET ROOM ID \(roomID) \(roomIdTextField)")
        self.roomId = roomID
        guard roomIdTextField != nil else {
            return
        }        
        self.roomIdTextField.text = roomID
    }

}

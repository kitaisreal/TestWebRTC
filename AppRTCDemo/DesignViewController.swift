//
//  DesignViewController.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/22/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import UIKit

class DesignViewController: UIViewController {

    let annotationsHeightOffset:CGFloat = 8
    let annotationsHeight:CGFloat = 64
    
    @IBOutlet weak var handUpButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var gestureButton: UIButton!
    
    @IBOutlet weak var annotationsView: UIView!
    
    var isAnnotationsShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Menu settings
        handUpButton.setImage(#imageLiteral(resourceName: "ic_hangup").withRenderingMode(.alwaysTemplate), for: .normal)
        
        handUpButton.tintColor = UIColor.red
        
        gestureButton.setImage(#imageLiteral(resourceName: "ic_gesture_white").withRenderingMode(.alwaysTemplate), for: .normal)
        gestureButton.tintColor = UIColor.white
        
        print("View resolution is \(view.bounds.width)x\(view.bounds.height)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func onHandUpButtonTapped(_ sender: UIButton) {
        print("Hand up button...")
        
        sender.tintColor = sender.tintColor == .red ? .lightGray : .red
    }
    
    @IBAction func onSoundTapped(_ sender: UIButton) {
//        if (sender.image(for: ))
        if sender.image(for: .normal) == #imageLiteral(resourceName: "ic_audioOff") {
            sender.setImage(#imageLiteral(resourceName: "ic_audioOn"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "ic_audioOff"), for: .normal)
        }
    }
    
    @IBAction func onVideoButtonTapped(_ sender: UIButton) {
        if sender.image(for: .normal) == #imageLiteral(resourceName: "ic_videoOff") {
            sender.setImage(#imageLiteral(resourceName: "ic_videoOn"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "ic_videoOff"), for: .normal)
        }
    }
    
    @IBAction func onGestureButtonTapped(_ sender: UIButton) {
        sender.tintColor = sender.tintColor == .white ? #colorLiteral(red: 0, green: 0.9803921569, blue: 0.5725490196, alpha: 1) : .white
    }
    
    @IBAction func onSwapUpOnView(_ sender: UISwipeGestureRecognizer) {
        print("Swap up")
        performAnnotations(sender: sender)
    }
    
    @IBAction func onSwapDownOnView(_ sender: UISwipeGestureRecognizer) {
        print("Swap down")
        performAnnotations(sender: sender)
    }
    
    
    @IBAction func onAnnotationsCloseButtonTapped(_ sender: UIButton) {
        print("Close anotations buton...")
        hideAnnotations()
    }
    
    // MARK: - Methods
    
    func performAnnotations(sender: UISwipeGestureRecognizer) {
        if sender.location(in: view).y < view.bounds.height / 2 { return }
        
        if isAnnotationsShow && sender.direction == .down {
            hideAnnotations()
        }
        
        if !isAnnotationsShow && sender.direction == .up {
            showAnnotations()
        }
    }
    
    func showAnnotations() {
        UIView.animate(withDuration: 0.8) {
            self.annotationsView.transform = CGAffineTransform(translationX: 0, y: -self.annotationsView.bounds.height + self.annotationsHeightOffset)
        }
        isAnnotationsShow = !isAnnotationsShow
    }
    
    func hideAnnotations() {
        UIView.animate(withDuration: 0.8) {
            self.annotationsView.transform = CGAffineTransform.identity
        }
        isAnnotationsShow = !isAnnotationsShow
    }
}

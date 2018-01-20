//
//  AbstractDrawVC.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/19/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import UIKit

class AbstractDrawVC: UIViewController {
    
    private var timer = Timer()
    private var swipped = false
    private var lastPoint = CGPoint.zero
    private var lines:[Line] = []
    private var oldLines:[Line] = []
    
    var drawBool = false
    var delegate:DrawMessageDelegate?
    var drawColor:UIColor = UIColor.black
    var imageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: DrawConstants.MESSAGE_TIMER_FIRING_TIME, target: self, selector: (#selector(self.sendMessage)), userInfo: nil, repeats: true)
        
    }
        
    @objc func sendMessage() {
        print("FROM TIMER SEND MESSAGE")
        guard let messageDelegate = delegate else {
            return
        }
        if (oldLines.count != lines.count) {
            let linesDifferrence = lines.differrence(with: oldLines)
            guard let linesData = try? JSONEncoder().encode(linesDifferrence) else {
                return
            }
            let linesMessage = ARDDataMessage(typeAndData: "lines", data: ["lines":String(data:linesData, encoding: .utf8)!])
            oldLines = self.lines.copy()
            messageDelegate.sendLinesMessage(linesMessage: linesMessage!)
        }
    }
    
    func invalidateTimer() {
        
        self.timer.invalidate()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let imageView = imageView else {
            return
        }
        swipped = false
        print("TOUCHES BEGAN")
        if let touch = touches.first {
            lastPoint = touch.location(in: imageView)
        }
    }
    func drawLines(lines:[Line]) {
        guard let imageView = imageView else {
            return
        }
        print("IMAGE VIEW \(imageView)")
        for line in lines {
            UIGraphicsBeginImageContext(imageView.frame.size)
            imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height))
            let context = UIGraphicsGetCurrentContext()
            let startPoint = line.startPoint
            let endPoint = line.endPoint
            context?.beginPath()
            context?.move(to: startPoint)
            context?.addLine(to: endPoint)
            context?.setLineWidth(CGFloat(DrawConstants.LINE_WIDTH))
            context?.setStrokeColor(drawColor.cgColor)
            context?.strokePath()
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
    func drawLines(fromPoint:CGPoint,toPoint:CGPoint) {
        guard let imageView = imageView else {
            return
        }
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height))
        let context = UIGraphicsGetCurrentContext()
        let startPoint = CGPoint(x: fromPoint.x, y: fromPoint.y)
        let endPoint = CGPoint(x: toPoint.x, y: toPoint.y)
        context?.move(to: startPoint)
        context?.addLine(to: endPoint)
        lines.append(Line(startPoint: startPoint, endPoint: endPoint))
        print(lines.count)
        context?.setLineWidth(CGFloat(DrawConstants.LINE_WIDTH))
        context?.setStrokeColor(UIColor.green.cgColor)
        context?.strokePath()
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let imageView = imageView else {
            return
        }
        swipped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: imageView)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swipped {
            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
}

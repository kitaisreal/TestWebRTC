//
//  DrawView.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/20/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift

class DrawView:UIImageView {
    
    var paths:[Path] = []
    private var oldPaths:[Path] = []
    
    var drawBool:MutableProperty<Bool>?
    var drawColor:UIColor = UIColor.black
    private var lastPoint = CGPoint.zero
    private var swipped = false
    
    func getDrawMessage() -> DrawMessage {
        let height = Double(self.frame.height)
        let width = Double(self.frame.width)
        if (oldPaths.count != paths.count) {
            let pathsDifference = paths.difference(with: oldPaths)
            oldPaths = self.paths.copy()
            return DrawMessage(paths: pathsDifference, frameHeight: height, frameWidth: width)
        }
        return DrawMessage(paths: [], frameHeight: height, frameWidth: width)
    }
    func drawDrawMessage(drawMessage:DrawMessage) {
        //TODO CHANGE POINTS TO YOUR FRAME HEIGHT FRAME WIDTH
        DispatchQueue.main.async { [weak self] in
            let paths = drawMessage.drawPaths
            let height = drawMessage.frameHeight
            let width = drawMessage.frameWidth
            let frameHeight = (self?.frame.height)!
            let frameWidth = (self?.frame.width)!
            let scaleFactorY = height / Double(frameHeight)
            let scaleFactorX = width / Double(frameWidth)
            print("SCALE FACTOR X \(scaleFactorX)")
            print("SCALE FACTOR Y \(scaleFactorY)")
            var truePaths:[Path] = []
            for path in paths {
                var truePath:[CGPoint] = []
                for point in path.path {
                    let newPoint = CGPoint(x: Double(point.x) * scaleFactorX, y: Double(point.y) * scaleFactorY)
                    truePath.append(newPoint)
                }
                truePaths.append(Path(path: truePath))
            }
            self?.drawPaths(paths: truePaths, color: UIColor.orange)
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    
    func drawPaths(paths:[Path], color:UIColor) {
        DispatchQueue.main.async { [weak self] in
            for path in paths {
                self?.drawPath(path: path, color:color, save:false)
                
            }
        }
    }
    func drawPath(path:Path, color:UIColor, save:Bool) {
        let size = self.frame.size
        let width = self.frame.width
        let height = self.frame.height
        UIGraphicsBeginImageContext(size)
        self.image?.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let context = UIGraphicsGetCurrentContext()
        if path.path.first != nil {
            context?.move(to: path.path[0])
            for point in path.path {
                context?.addLine(to: point)
            }
        }
        if (save) {
            self.paths.append(path)
        }
        context?.setLineWidth(CGFloat(DrawConstants.LINE_WIDTH))
        context?.setStrokeColor(color.cgColor)
        context?.strokePath()
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard drawBool?.value == true else {
            return
        }
        swipped = true
        if let touch = touches.first {
            var drawPathArray:[CGPoint] = []
            let currentPoint = touch.location(in: self)
            drawPathArray = [lastPoint, currentPoint]
            lastPoint = currentPoint
            let path = Path(path: drawPathArray)
            drawPath(path: path, color:UIColor.green, save:true)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swipped {
            
        }
    }
    
}

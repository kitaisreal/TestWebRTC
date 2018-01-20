//
//  DrawView.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/20/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import Foundation
import UIKit

class DrawView:UIImageView {
    
    var lines:[Line] = []
    var drawBool = false
    var drawColor:UIColor = UIColor.black
    private var lastPoint = CGPoint.zero
    private var swipped = false
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    func drawLines(lines:[Line]) {
        for line in lines {
            self.drawLine(line: line, save: true)
        }
    }
    func drawLine(line:Line, save:Bool) {
        let size = self.frame.size
        let width = self.frame.width
        let height = self.frame.height
        UIGraphicsBeginImageContext(size)
        self.image?.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let context = UIGraphicsGetCurrentContext()
        let startPoint = line.startPoint
        let endPoint = line.endPoint
        context?.move(to: startPoint)
        context?.addLine(to: endPoint)
        if (save) {
            lines.append(Line(startPoint: startPoint, endPoint: endPoint))
        }
        print(lines.count)
        context?.setLineWidth(CGFloat(DrawConstants.LINE_WIDTH))
        context?.setStrokeColor(UIColor.green.cgColor)
        context?.strokePath()
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            let line = Line(startPoint: lastPoint, endPoint: currentPoint)
            drawLine(line: line, save: true)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swipped {
            
        }
    }
    
}

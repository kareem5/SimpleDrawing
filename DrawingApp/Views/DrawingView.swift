//
//  DrawingView.swift
//  DrawingApp
//
//  Created by Kareem Mohammed on 9/12/18.
//  Copyright © 2018 KareemDev. All rights reserved.
//

import UIKit

class DrawingView: UIView {
    
    private var bezierPathLine: UIBezierPath!
    private var bufferImage: UIImage?
    
    private var bezierCurvePoints: [CGPoint] = [] // Create an array to store points.
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        initializeView()
    }
    
    override func draw(_ rect: CGRect) {
        bufferImage?.draw(in: rect)
        drawLine()
    }
    
    private func drawLine() {
        
        UIColor.red.setStroke()
        bezierPathLine.stroke()
    }
    
    private func initializeView() {
        
        isMultipleTouchEnabled = false
        
        bezierPathLine = UIBezierPath()
        bezierPathLine.lineWidth = 4
        
        self.backgroundColor = UIColor.clear
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewDragged(_:)))
        addGestureRecognizer(panGesture)
        
    }
    
    @objc func viewDragged(_ sender: UIPanGestureRecognizer) {
        
        let point = sender.location(in: self)
        
        if point.x < 0 || point.x > frame.width || point.y < 0 || point.y > frame.height {
            return
        }
        
        switch sender.state {
            
        case .began:
            bezierCurvePoints.append(point) // Add first point in array.
            break
            
        case .changed:
            
            bezierCurvePoints.append(point)
            
            // If we get 4 points.
            if bezierCurvePoints.count == 4 {
                
                // Draw an arc from point 0 to 3 with point 1 and 2 as control points.
                bezierPathLine.move(to: bezierCurvePoints[0])
                bezierPathLine.addCurve(to: bezierCurvePoints[3], controlPoint1: bezierCurvePoints[1], controlPoint2: bezierCurvePoints[2])
                
                let point = bezierCurvePoints[3]
                
                bezierCurvePoints.removeAll()
                
                // Store end point of arc as a start point for next arc.
                bezierCurvePoints.append(point)
                setNeedsDisplay()
            }
            
            break
            
        case .ended:
            
            saveBufferImage()
            
            // Remove all points.
            bezierCurvePoints.removeAll()
            bezierPathLine.removeAllPoints()
            break
        default:
            break
        }
    }
    
    private func saveBufferImage() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        if bufferImage == nil {
            let fillPath = UIBezierPath(rect: self.bounds)
            UIColor.clear.setFill()
            fillPath.fill()
        }
        bufferImage?.draw(at: .zero)
        drawLine()
        bufferImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
}

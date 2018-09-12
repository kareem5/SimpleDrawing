//
//  contextDrawingView.swift
//  DrawingApp
//
//  Created by Kareem Mohammed on 9/12/18.
//  Copyright © 2018 KareemDev. All rights reserved.
//

import UIKit

class contextDrawingView: UIView {

    var bufferImage: UIImage?
    private var selectedColor = UIColor.red.cgColor
    var lastPoint = CGPoint.zero
    var brushSize = 10
    
    var color: UIColor? {
        didSet {
            selectedColor = (color?.cgColor)!
        }
    }
    
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        initializeView()
    }
    
    private func initializeView() {
        
        isMultipleTouchEnabled = false
        self.backgroundColor = UIColor.clear
        
    }
    
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        bufferImage?.draw(in: rect)
    }
    
    
    // MARK: - Erase

    func eraseAll() {
        bufferImage = nil
        setNeedsDisplay()
    }
    
    // MARK: - Moving

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let beginPoint = touches.first?.location(in: self) {
            print(beginPoint)
            lastPoint = beginPoint
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let movedToPoint = touches.first?.location(in: self) {
            
            drawBetweenTwoPoints(point1: lastPoint, point2: movedToPoint)
            
            lastPoint = movedToPoint
        }
    }
    
    func drawBetweenTwoPoints(point1:CGPoint, point2:CGPoint) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            
            if bufferImage == nil {
                let fillPath = UIBezierPath(rect: self.bounds)
                UIColor.clear.setFill()
                fillPath.fill()
                
            }
            
            bufferImage?.draw(at: .zero)
            
            context.move(to: point1)
            context.addLine(to: point2)
            
            context.setLineWidth(CGFloat(brushSize))
            context.setLineCap(.round)
            
            context.setStrokeColor(selectedColor)
            context.strokePath()
            
            bufferImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let endPoint = touches.first?.location(in: self) {
            drawBetweenTwoPoints(point1: endPoint, point2: endPoint)
        }
        
    }

}

//
//  FaceView.swift
//  Homework3
//
//  Created by uics13 (Suhas V Kumar) on 9/18/16.
//  Copyright © 2016 UIowa. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    //   let width  = bounds.size.width
    //   let height = bounds.size.height
    
    var scale:CGFloat = 0.90
    var skullRadius: CGFloat{
        return min(bounds.size.width,bounds.size.height) / 2 * scale
    }
    var skullCenter: CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    //eyes
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius _radius:CGFloat) -> UIBezierPath
    {
        
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: _radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false
        )
        path.lineWidth = 5.0
        return path
    }
    
    
    
    private func getEyeCenter(eye: Eye) -> CGPoint
    {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath
    {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        
        let mouthRect = CGRect(x: skullCenter.x - 30, y: skullCenter.y + 30, width: 60, height: 2)
        return UIBezierPath(rect: mouthRect)
        
    }
    
    
    override func draw(_ rect: CGRect)
    {
        // Drawing code
        UIColor.black.set()
        pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
        
        
    }
    
    
}

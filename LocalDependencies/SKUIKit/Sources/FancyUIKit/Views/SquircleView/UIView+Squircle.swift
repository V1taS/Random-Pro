//
//  File.swift
//  
//
//  Created by SOSIN Vitaly on 24.01.2023.
//

import UIKit
import QuartzCore

private let squircleBorderName = "squircleBorder"

extension UIView {
  /**
   Apply squircle corner radius.
   */
  func squircle() {
    self.layer.applySquircle()
  }
  
  /**
   Apply squircle corner radius with a border.
   - parameters:
   - borderWidth: Border width
   - borderColor: Border color
   */
  func squircleWithBorder(width: CGFloat, color: UIColor) {
    self.layer.applySquircleWithBorder(width: width, color: color)
  }
  
  /**
   Remove squircle corner radius and border.
   */
  func removeSquircle() {
    self.layer.removeSquircle()
  }
  
  /**
   Remove squircle border.
   */
  func removeSquircleBorder() {
    self.layer.removeSquircleBorder()
  }
}

extension CALayer {
  
  /**
   Apply squircle corner radius.
   */
  func applySquircle() {
    let maskLayer = CAShapeLayer()
    maskLayer.path = squirclePath.cgPath
    self.mask = maskLayer
  }
  
  /**
   Apply squircle corner radius with a border.
   - parameters:
   - borderWidth: Border width
   - borderColor: Border color
   */
  func applySquircleWithBorder(width: CGFloat, color: UIColor) {
    applySquircle()
    let borderLayer = CAShapeLayer()
    borderLayer.name = squircleBorderName
    borderLayer.path = squirclePath.cgPath
    borderLayer.lineWidth = width
    borderLayer.strokeColor = color.cgColor
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.frame = self.bounds
    self.addSublayer(borderLayer)
  }
  
  /**
   Remove the squircle corner radius and border.
   */
  func removeSquircle() {
    removeSquircleBorder()
    self.mask?.removeFromSuperlayer()
  }
  
  /**
   Remove the squircle border.
   */
  func removeSquircleBorder() {
    self.sublayers?
      .filter { layer in return layer.name == squircleBorderName }
      .forEach { layer in
        layer.removeFromSuperlayer()
      }
  }
  
  var squirclePath: UIBezierPath {
    
    let width = bounds.width
    let height = bounds.height
    let squircleSide = min(width, height)
    CGPoint.xDelta = abs(squircleSide - width)
    CGPoint.yDelta = abs(squircleSide - height)
    
    let checkpoints = Checkpoints(width: bounds.width, height: bounds.height)
    
    let path = UIBezierPath()
    path.move(to: CGPoint(x: checkpoints.cornerDelta, y: 0))
    
    path.addLine(to: CGPoint(x: width-checkpoints.cornerDelta, y: 0))
    path.addCurve(to: CGPoint.xDeltaPoint(x: checkpoints.checkpoint0, y: squircleSide-checkpoints.checkpoint3),
                  controlPoint1: CGPoint.xDeltaPoint(x: checkpoints.checkpoint1, y: 0),
                  controlPoint2: CGPoint.xDeltaPoint(x: checkpoints.checkpoint2, y: 0))
    path.addCurve(to: CGPoint.xDeltaPoint(x: checkpoints.checkpoint3, y: squircleSide-checkpoints.checkpoint0),
                  controlPoint1: CGPoint.xDeltaPoint(x: checkpoints.checkpoint4, y: squircleSide-checkpoints.checkpoint5),
                  controlPoint2: CGPoint.xDeltaPoint(x: checkpoints.checkpoint5, y: squircleSide-checkpoints.checkpoint4))
    path.addCurve(to: CGPoint.xDeltaPoint(x: squircleSide, y: checkpoints.cornerDelta),
                  controlPoint1: CGPoint.xDeltaPoint(x: squircleSide, y: squircleSide-checkpoints.checkpoint2),
                  controlPoint2: CGPoint.xDeltaPoint(x: squircleSide, y: squircleSide-checkpoints.checkpoint1))
    
    path.addLine(to: CGPoint(x: width, y: height-checkpoints.cornerDelta))
    path.addCurve(to: CGPoint.deltaPoint(x: checkpoints.checkpoint3, y: checkpoints.checkpoint0),
                  controlPoint1: CGPoint.deltaPoint(x: squircleSide, y: checkpoints.checkpoint1),
                  controlPoint2: CGPoint.deltaPoint(x: squircleSide, y: checkpoints.checkpoint2))
    path.addCurve(to: CGPoint.deltaPoint(x: checkpoints.checkpoint0, y: checkpoints.checkpoint3),
                  controlPoint1: CGPoint.deltaPoint(x: checkpoints.checkpoint5, y: checkpoints.checkpoint4),
                  controlPoint2: CGPoint.deltaPoint(x: checkpoints.checkpoint4, y: checkpoints.checkpoint5))
    path.addCurve(to: CGPoint.deltaPoint(x: squircleSide-checkpoints.cornerDelta, y: squircleSide),
                  controlPoint1: CGPoint.deltaPoint(x: checkpoints.checkpoint2, y: squircleSide),
                  controlPoint2: CGPoint.deltaPoint(x: checkpoints.checkpoint1, y: squircleSide))
    
    path.addLine(to: CGPoint(x: checkpoints.cornerDelta, y: height))
    path.addCurve(to: CGPoint.yDeltaPoint(x: squircleSide-checkpoints.checkpoint0, y: checkpoints.checkpoint3),
                  controlPoint1: CGPoint.yDeltaPoint(x: squircleSide-checkpoints.checkpoint1, y: squircleSide),
                  controlPoint2: CGPoint.yDeltaPoint(x: squircleSide-checkpoints.checkpoint2, y: squircleSide))
    path.addCurve(to: CGPoint.yDeltaPoint(x: squircleSide-checkpoints.checkpoint3, y: checkpoints.checkpoint0),
                  controlPoint1: CGPoint.yDeltaPoint(x: squircleSide-checkpoints.checkpoint4, y: checkpoints.checkpoint5),
                  controlPoint2: CGPoint.yDeltaPoint(x: squircleSide-checkpoints.checkpoint5, y: checkpoints.checkpoint4))
    path.addCurve(to: CGPoint.yDeltaPoint(x: 0, y: squircleSide-checkpoints.cornerDelta),
                  controlPoint1: CGPoint.yDeltaPoint(x: 0, y: checkpoints.checkpoint2),
                  controlPoint2: CGPoint.yDeltaPoint(x: 0, y: checkpoints.checkpoint1))
    
    path.addLine(to: CGPoint(x: 0, y: checkpoints.cornerDelta))
    path.addCurve(to: CGPoint(x: squircleSide-checkpoints.checkpoint3, y: squircleSide-checkpoints.checkpoint0),
                  controlPoint1: CGPoint(x: 0, y: squircleSide-checkpoints.checkpoint1),
                  controlPoint2: CGPoint(x: 0, y: squircleSide-checkpoints.checkpoint2))
    path.addCurve(to: CGPoint(x: squircleSide-checkpoints.checkpoint0, y: squircleSide-checkpoints.checkpoint3),
                  controlPoint1: CGPoint(x: squircleSide-checkpoints.checkpoint5, y: squircleSide-checkpoints.checkpoint4),
                  controlPoint2: CGPoint(x: squircleSide-checkpoints.checkpoint4, y: squircleSide-checkpoints.checkpoint5))
    path.addCurve(to: CGPoint(x: checkpoints.cornerDelta, y: 0),
                  controlPoint1: CGPoint(x: squircleSide-checkpoints.checkpoint2, y: 0),
                  controlPoint2: CGPoint(x: squircleSide-checkpoints.checkpoint1, y: 0))
    
    path.close()
    
    return path
  }
}

extension CGPoint {
  static var xDelta: CGFloat = 0
  static var yDelta: CGFloat = 0
  
  static func xDeltaPoint(x: CGFloat, y: CGFloat) -> CGPoint {
    return CGPoint(x: xDelta + x, y: y)
  }
  
  static func yDeltaPoint(x: CGFloat, y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: yDelta + y)
  }
  
  static func deltaPoint(x: CGFloat, y: CGFloat) -> CGPoint {
    return CGPoint(x: xDelta + x, y: yDelta + y)
  }
}

struct Checkpoints {
  let width: CGFloat
  let height: CGFloat
  let startRatio: CGFloat = 256/87.15
  let checkpoint0Ratio: CGFloat = 256/219.33
  let checkpoint1Ratio: CGFloat = 256/198.35
  let checkpoint2Ratio: CGFloat = 256/206.63
  let checkpoint3Ratio: CGFloat = 256/251.73
  let checkpoint4Ratio: CGFloat = 256/234.35
  let checkpoint5Ratio: CGFloat = 256/246.24
  
  var squircleSide: CGFloat {
    return min(width, height)
  }
  var cornerDelta: CGFloat {
    return squircleSide/startRatio
  }
  var checkpoint0: CGFloat {
    return squircleSide/checkpoint0Ratio
  }
  var checkpoint1: CGFloat {
    return squircleSide/checkpoint1Ratio
  }
  var checkpoint2: CGFloat {
    return squircleSide/checkpoint2Ratio
  }
  var checkpoint3: CGFloat {
    return squircleSide/checkpoint3Ratio
  }
  var checkpoint4: CGFloat {
    return squircleSide/checkpoint4Ratio
  }
  var checkpoint5: CGFloat {
    return squircleSide/checkpoint5Ratio
  }
}

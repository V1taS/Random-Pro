//
//  DiagonalStrikeThroughView.swift
//  FancyUIKit
//
//  Created by Vitalii Sosin on 29.10.2023.
//

import UIKit

final class DiagonalStrikeThroughView: UIView {
  
  var strikeThroughColor: UIColor = .fancy.only.primaryRed
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.backgroundColor = .clear
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    if let context = UIGraphicsGetCurrentContext() {
      context.setStrokeColor(strikeThroughColor.cgColor)
      context.setLineWidth(3.0)
      context.move(to: CGPoint(x: 0, y: 0))
      context.addLine(to: CGPoint(x: rect.width, y: rect.height))
      context.strokePath()
    }
  }
}

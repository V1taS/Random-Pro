//
//  TypingIndicatorUIView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 26.06.2024.
//

import UIKit
import SKStyle

/// UIView для отображения анимированного индикатора набора текста.
public final class TypingIndicatorUIView: UIView {
  
  // MARK: - Properties
  private let circleSize: CGFloat = 8.0
  private let circleSpacing: CGFloat = 4.0
  private let animationDuration: Double = 0.6
  private var circles: [UIView] = []
  
  // MARK: - Initialization
  
  public init() {
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    for i in 0..<3 {
      let circle = createCircle()
      addSubview(circle)
      circles.append(circle)
      
      let delay = animationDuration * Double(i) / 3.0
      animate(circle: circle, withDelay: delay)
    }
    
    setupConstraints()
  }
  
  private func createCircle() -> UIView {
    let circle = UIView()
    circle.translatesAutoresizingMaskIntoConstraints = false
    circle.backgroundColor = SKStyleAsset.constantAzure.color
    circle.layer.cornerRadius = circleSize / 2
    return circle
  }
  
  private func setupConstraints() {
    for (index, circle) in circles.enumerated() {
      if index == 0 {
        circle.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
      } else {
        circle.leadingAnchor.constraint(equalTo: circles[index - 1].trailingAnchor, constant: circleSpacing).isActive = true
      }
      
      circle.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
      circle.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
      circle.widthAnchor.constraint(equalToConstant: circleSize).isActive = true
      circle.heightAnchor.constraint(equalToConstant: circleSize).isActive = true
      
      if index == circles.count - 1 {
        circle.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
      }
    }
  }
  
  private func animate(circle: UIView, withDelay delay: TimeInterval) {
    UIView.animate(withDuration: animationDuration, delay: delay, options: [.repeat, .autoreverse], animations: {
      circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }, completion: nil)
  }
}

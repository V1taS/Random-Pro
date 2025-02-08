//
//  GradientView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import UIKit

/// View для экрана
public final class GradientView: UIView {
  
  // MARK: - Public properties
  
  public override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public func
  
  public func applyGradient(colors: [UIColor], alpha: CGFloat = 1) {
    guard let gradientLayer = layer as? CAGradientLayer else { return }
    gradientLayer.colors = colors.map {
      if $0 == UIColor.clear {
        return $0.withAlphaComponent(.zero).cgColor
      } else {
        return $0.withAlphaComponent(alpha).cgColor
      }
    }
  }
  
  public func startAnimatingGradient() {
    guard let gradientLayer = layer as? CAGradientLayer else {
      return
    }
    
    let rotationAnimation = CABasicAnimation(keyPath: Appearance().rotation)
    rotationAnimation.toValue = Float.pi * 2.0
    rotationAnimation.duration = 4
    rotationAnimation.isCumulative = true
    rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
    
    gradientLayer.add(rotationAnimation, forKey: Appearance().rotationAnimationKey)
  }
  
  public func stopAnimatingGradient() {
    guard let gradientLayer = layer as? CAGradientLayer else { return }
    
    gradientLayer.removeAnimation(forKey: Appearance().rotationAnimationKey)
  }
}

// MARK: - Private

private extension GradientView {
  func applyDefaultBehavior() {
    backgroundColor = .clear
  }
}

// MARK: - Appearance

private extension GradientView {
  struct Appearance {
    let rotationAnimationKey = "rotationAnimationKey"
    let rotation = "transform.rotation"
  }
}

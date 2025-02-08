//
//  UIView+Blur.swift
//  
//
//  Created by Vitalii Sosin on 21.01.2023.
//

import UIKit

/// UIView делаем изображением
public extension UIView {
  func addBackgroundBlurWith(_ style: UIBlurEffect.Style, alpha: CGFloat) {
    let blurEffect = UIBlurEffect(style: style)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = bounds
    blurEffectView.alpha = .zero
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    blurEffectView.tag = 777
    self.addSubview(blurEffectView)
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
    blurEffectView.addGestureRecognizer(gestureRecognizer)
    
    UIView.animate(withDuration: 0.2) {
      blurEffectView.alpha = alpha
    }
  }
  
  func removeBackgroundBlur() {
    if let blurEffectView = viewWithTag(777) {
      UIView.animate(withDuration: 0.2, animations: {
        blurEffectView.alpha = 0
      }, completion: { _ in
        blurEffectView.removeFromSuperview()
      })
    }
  }
  
  @objc
  func didTapBackgroundView() {
#if DEBUG
    print("Обработка нажатия на фон не имплементирвана")
#endif
  }
}

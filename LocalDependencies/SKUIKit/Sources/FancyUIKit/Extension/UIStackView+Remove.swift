//
//  UIStackView+Remove.swift
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

/// Удаление View из UIStackView
public extension UIStackView {
  
  /// Удаляет конкретную UIView из UIStackView
  func removeFully(view: UIView) {
    removeArrangedSubview(view)
    view.removeFromSuperview()
  }
  
  /// Удаляет все UIView из UIStackView
  func removeFullyAllArrangedSubviews() {
    arrangedSubviews.forEach { (view) in
      removeFully(view: view)
    }
  }
}

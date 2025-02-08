//
//  SquircleView.swift
//  RandomUIKitExample
//
//  Created by SOSIN Vitaly on 24.01.2023.
//

import UIKit
import QuartzCore

/// View для экрана
public final class SquircleView: UIView {
  
  // MARK: - Private properties
  
  private var once = true
  private let borderWidth: CGFloat
  private let borderColor: UIColor
  private let gradientView = GradientView()
  
  // MARK: - Public func
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    if once {
      once = false
      self.squircleWithBorder(width: borderWidth, color: borderColor)
    }
  }
  
  // MARK: - Initialization
  
  /// Инициализация
  /// - Parameters:
  ///  - borderWidth: Ширина обводки
  ///  - borderColor: Цвет обводки
  required public init(borderWidth: CGFloat = .zero,
                       borderColor: UIColor = .clear) {
    self.borderWidth = borderWidth
    self.borderColor = borderColor
    super.init(frame: .zero)
    
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public func
  
  public func applyGradient(colors: [UIColor], alpha: CGFloat = 1) {
    gradientView.applyGradient(colors: colors, alpha: alpha)
  }
}

// MARK: - Private

private extension SquircleView {
  func configureLayout() {
    [gradientView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
      gradientView.topAnchor.constraint(equalTo: topAnchor),
      gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
      gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}


// MARK: - Appearance

private extension SquircleView {
  struct Appearance {}
}

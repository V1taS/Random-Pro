//
//  PremiumButtonView.swift
//  
//
//  Created by Антон Тропин on 03.06.23.
//

import UIKit
import FancyStyle

/// View для экрана
public final class PremiumButtonView: UIButton {
  
  public enum Style {
    
    /// Стиль границы
    var backgroundColors: [UIColor] {
      switch self {
      case .premium:
        return [.fancy.only.primaryGreen,
                .fancy.only.secondaryGreen]
      case .nonPremium:
        return [.fancy.only.primaryRed,
                .fancy.only.primaryPink]
      }
    }
    
    /// Премиум
    case premium
    
    /// Нет премиума
    case nonPremium
  }
  
  // MARK: - Public properties
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    
    titleLabel?.zoomIn(duration: Appearance().resultDuration,
                       transformScale: CGAffineTransform(scaleX: 0.9, y: 0.9))
  }
  
  // MARK: - Private properties
  
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Private properties
  
  private var shadowAnimation: CABasicAnimation?
  private let gradientLayer = CAGradientLayer()
  private var style: Style = .nonPremium
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    gradientLayer.frame = bounds
    
    let borderMaskLayer = CAShapeLayer()
    borderMaskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    borderMaskLayer.fillColor = UIColor.clear.cgColor
    borderMaskLayer.strokeColor = UIColor.black.cgColor
    borderMaskLayer.lineWidth = Appearance().borderMaskWidth
    gradientLayer.mask = borderMaskLayer
  }
  
  // MARK: - Public func
  
  /// Настраиваем вью
  /// - Parameters:
  ///  - title: Заголовок
  ///  - style: Стиль
  public func configureWith(title: String?,
                            style: Style) {
    self.style = style
    setupShadowAnimation()
    setTitle(title, for: .normal)
    applyGradient(colors: style.backgroundColors)
    
    guard let shadowAnimation else {
      return
    }
    
    titleLabel?.layer.add(shadowAnimation, forKey: "buttonShadowAnimation")
    switch style {
    case .premium:
      setTitleColor(.fancy.darkAndLightTheme.primaryGray, for: .normal)
      titleLabel?.layer.shadowColor = .fancy.only.primaryGreen.cgColor
    case .nonPremium:
      setTitleColor(.fancy.darkAndLightTheme.primaryGray, for: .normal)
      titleLabel?.layer.shadowColor = .fancy.only.primaryRed.cgColor
    }
  }
}

// MARK: - Private

private extension PremiumButtonView {
  func configureLayout() {
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: Appearance().contentHeight),
      widthAnchor.constraint(equalToConstant: Appearance().contentWidth)
    ])
    layer.insertSublayer(gradientLayer, at: .zero)
  }
  
  func applyDefaultBehavior() {
    clipsToBounds = true
    layer.masksToBounds = true
    layer.cornerRadius = Appearance().cornerRadius
    titleLabel?.font = fancyFont.primaryRegular16
  }
  
  private func applyGradient(colors: [UIColor], alpha: CGFloat = 1) {
    gradientLayer.colors = colors.map { $0.withAlphaComponent(alpha).cgColor }
    gradientLayer.locations = [0, 1]
  }
  
  private func setupShadowAnimation() {
    let appearance = Appearance()
    guard shadowAnimation == nil else {
      return
    }
    let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
    shadowAnimation.fromValue = appearance.animationFromValue
    shadowAnimation.toValue = appearance.animationToValue
    shadowAnimation.duration = appearance.animationDuration
    shadowAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    shadowAnimation.repeatCount = .infinity
    shadowAnimation.autoreverses = true
    self.shadowAnimation = shadowAnimation
    
    titleLabel?.layer.shadowOffset = appearance.titleShadowOffset
    titleLabel?.layer.shadowOpacity = appearance.titleShadowOpacity
    titleLabel?.layer.shadowRadius = appearance.titleShadowRadius
  }
}

// MARK: - Appearance

private extension PremiumButtonView {
  struct Appearance {
    let contentHeight: CGFloat = 24
    let contentWidth: CGFloat = 90
    let cornerRadius: CGFloat = 6
    
    let resultDuration: CGFloat = 0.2
    let borderMaskWidth: CGFloat = 4
    let titleShadowOffset: CGSize = CGSize(width: 0, height: 0)
    let titleShadowOpacity: Float = 0.6
    let titleShadowRadius: CGFloat = 1.5
    let animationFromValue: CGFloat = 0
    let animationToValue: CGFloat = 0.4
    let animationDuration: CGFloat = 1.1
  }
}

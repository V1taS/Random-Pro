//
//  ButtonView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import UIKit
import SKStyle

/// View для экрана
public final class ButtonView: UIButton {
  
  // MARK: - Public properties
  
  /// Настраиваем фон кнопки
  /// - Parameter gradientBackground: Градиент цветов для кнопки
  public var gradientBackground = [SKStyleAsset.constantAzure.color,
                                   SKStyleAsset.constantAzure.color.withAlphaComponent(0.8)] {
    didSet {
      applyGradient(colors: gradientBackground)
    }
  }
  
  public override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    updateStyle()
  }
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    impactFeedback.impactOccurred()
    updateStyle()
    self.zoomInWithEasing()
  }
  
  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    updateStyle()
  }
  
  public func set(isEnabled: Bool) {
    self.isEnabled = isEnabled
    updateStyle()
  }
  
  // MARK: - Private properties
  
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private func
  
  private func updateStyle() {
    if isEnabled {
      applyGradient(colors: gradientBackground)
    } else {
      applyGradient(colors: [SKStyleAsset.constantSlate.color,
                             SKStyleAsset.constantSlate.color.withAlphaComponent(0.8)])
    }
  }
  
  private func configureLayout() {
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: Appearance().contentHeight)
    ])
  }
  
  private func applyDefaultBehavior() {
    setTitleColor(SKStyleAsset.ghost.color, for: .normal)
    titleLabel?.font = .fancy.text.regular
    layer.cornerRadius = Appearance().cornerRadius
    
    applyGradient(colors: gradientBackground)
  }
  
  private func applyGradient(colors: [UIColor], alpha: CGFloat = 1) {
    guard let gradientLayer = layer as? CAGradientLayer else { return }
    gradientLayer.colors = colors.map { $0.withAlphaComponent(alpha).cgColor }
  }
}

// MARK: - Appearance

private extension ButtonView {
  struct Appearance {
    let contentHeight: CGFloat = 52
    let cornerRadius: CGFloat = 8
    let alphaButton: CGFloat = 0.9
  }
}

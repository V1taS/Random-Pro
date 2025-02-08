//
//  LabelGradientView.swift
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import FancyStyle

/// View для экрана
public final class LabelGradientView: UIView {
  
  // MARK: - Public properties
  
  public override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }
  
  // MARK: - Private properties
  private let titleLabel = UILabel()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - titleText: Заголовок на рекламном лайбле
  ///  - font: Шрифт на рекламном лайбле
  ///  - textColor: Цвет рекламного лейбла
  ///  - borderWidth: Ширина границы компонента
  ///  - borderColor: Цвет границы компонента
  ///  - gradientDVLabel: Градиент цветов для рекламного лайбла
  public func configureWith(titleText: String?,
                            font: UIFont? = nil,
                            textColor: UIColor? = nil,
                            borderWidth: CGFloat? = nil,
                            borderColor: UIColor? = nil,
                            gradientDVLabel: [UIColor]) {
    titleLabel.text = titleText
    applyGradient(colors: gradientDVLabel)
    
    if let font = font {
      titleLabel.font = font
    }
    
    if let textColor = textColor {
      titleLabel.textColor = textColor
    }
    
    if let borderWidth = borderWidth {
      layer.borderWidth = borderWidth
      layer.borderColor = borderColor?.cgColor
    }
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [titleLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.inset.left),
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: appearance.inset.top),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.inset.right),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -appearance.inset.bottom)
    ])
  }
  
  private func applyDefaultBehavior() {
    layer.cornerRadius = Appearance().cornerRadius
    
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryWhite
    titleLabel.font =  fancyFont.primaryRegular16
  }
  
  private func applyGradient(colors: [UIColor]) {
    guard let gradientLayer = layer as? CAGradientLayer else { return }
    gradientLayer.colors = colors.map { $0.cgColor }
  }
}

// MARK: - Appearance

private extension LabelGradientView {
  struct Appearance {
    let cornerRadius: CGFloat = 6
    let inset = UIEdgeInsets(top: 2,
                             left: 8,
                             bottom: 2,
                             right: 8)
  }
}

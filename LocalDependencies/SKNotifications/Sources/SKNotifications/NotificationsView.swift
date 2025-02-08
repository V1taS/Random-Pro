//
//  NotificationsView.swift
//
//
//  Created by Vitalii Sosin on 08.07.2022.
//

import UIKit

/// View для экрана
final class NotificationsView: UIView {
  
  /// Моделька для уведомления
  struct Model {
    
    /// Текст уведомления
    let body: String
    
    /// Текст уведомления
    let bodyColor: UIColor?
    
    /// Фон уведомления
    let backgroundColor: UIColor?
    
    /// Цвет иконки
    let colorGlyph: UIColor?
    
    /// Иконка
    let glyph: UIImage?
  }
  
  // MARK: - Private properties
  
  private let bodyLabel = UILabel()
  private let glyphView = UIImageView()
  private let stack = UIStackView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func configureViewWith(_ model: Model) {
    if let image = model.glyph {
      if #available(iOS 13.0, *) {
        if let colorGlyph = model.colorGlyph {
          glyphView.image = image.withTintColor(colorGlyph).withRenderingMode(.alwaysOriginal)
        } else {
          glyphView.image = image
        }
      } else {
        glyphView.image = image
      }
      stack.addArrangedSubview(glyphView)
    }
    
    backgroundColor = model.backgroundColor
    bodyLabel.text = model.body
    bodyLabel.textColor = model.bodyColor
    stack.addArrangedSubview(bodyLabel)
  }
}

// MARK: - Private

private extension NotificationsView {
  func configureLayout() {
    let appearance = Appearance()
    
    [stack].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    bodyLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      glyphView.heightAnchor.constraint(equalToConstant: Appearance().glyphSize.height),
      glyphView.widthAnchor.constraint(equalToConstant: Appearance().glyphSize.width),
      
      stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.insets),
      stack.topAnchor.constraint(equalTo: topAnchor, constant: appearance.insets),
      stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.insets),
      stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -appearance.insets)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    
    stack.axis = .horizontal
    stack.alignment = .top
    stack.distribution = .fill
    stack.spacing = appearance.stackSpacing
    
    glyphView.setContentCompressionResistancePriority(.required, for: .horizontal)
    glyphView.setContentHuggingPriority(.required, for: .horizontal)
    
    bodyLabel.numberOfLines = .zero
    bodyLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    bodyLabel.font = .systemFont(ofSize: appearance.systemFont)
    
    layer.shadowColor = UIColor.black.cgColor.copy(alpha: appearance.shadowColorAlpha)
    layer.shadowOffset = CGSize(width: .zero, height: appearance.shadowOffsetHeight)
    layer.shadowRadius = appearance.shadowRadius
    layer.shadowOpacity = appearance.shadowOpacity
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    layer.cornerRadius = appearance.cornerRadius
  }
}

// MARK: - Appearance

private extension NotificationsView {
  struct Appearance {
    let insets: CGFloat = 16
    let glyphSize = CGSize(width: 24, height: 24)
    let stackSpacing: CGFloat = 12
    let systemFont: CGFloat = 20
    let shadowColorAlpha = 0.25
    let shadowRadius: CGFloat = 6
    let shadowOpacity: Float = 1
    let cornerRadius: CGFloat = 16
    let shadowOffsetHeight = 1
  }
}

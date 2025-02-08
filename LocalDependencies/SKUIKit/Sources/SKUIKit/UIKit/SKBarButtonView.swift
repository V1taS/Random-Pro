//
//  SKBarButtonView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 24.04.2024.
//

import UIKit
import SKStyle

public final class SKBarButtonView: UIControl {
  
  // MARK: - Private properties
  
  public let iconLeftView = UIImageView()
  public let labelView = UILabel()
  public let iconRightView = UIImageView()
  private let stackView = UIStackView()
  private var action: (() -> Void)?
  private let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
  
  // MARK: - Public func
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    animateTouchDown()
  }
  
  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    animateTouchUp()
  }
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    animateTouchUp()
    action?()
    impactFeedback.impactOccurred()
  }
  
  // MARK: - Initialization
  
  public init(_ model: SKBarButtonView.Model) {
    super.init(frame: .zero)
    configureLayout()
    applyDefaultBehavior(model)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private

private extension SKBarButtonView {
  func configureLayout() {
    [iconLeftView, labelView, iconRightView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      stackView.addArrangedSubview($0)
    }
    
    [stackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      iconLeftView.widthAnchor.constraint(equalToConstant: .s4),
      iconLeftView.heightAnchor.constraint(equalToConstant: .s4),
      
      iconRightView.widthAnchor.constraint(equalToConstant: .s4),
      iconRightView.heightAnchor.constraint(equalToConstant: .s4),
      
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func applyDefaultBehavior(_ model: SKBarButtonView.Model) {
    iconLeftView.contentMode = .scaleAspectFit
    iconLeftView.layer.cornerRadius = .s2
    iconLeftView.clipsToBounds = true
    
    labelView.font = .fancy.text.regularMedium
    labelView.textColor = SKStyleAsset.ghost.color
    
    iconRightView.contentMode = .scaleAspectFit
    iconRightView.layer.cornerRadius = .s2
    iconRightView.clipsToBounds = true
    iconRightView.tintColor = SKStyleAsset.ghost.color
    
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = .s2
    
    iconLeftView.image = model.leftImage
    labelView.text = model.centerText
    iconRightView.image = model.rightImage
    action = model.action
    isEnabled = model.isEnabled
  }
  
  func animateTouchDown() {
    UIView.animate(withDuration: 0.1, animations: {
      self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    })
  }
  
  func animateTouchUp() {
    UIView.animate(withDuration: 0.1, animations: {
      self.transform = CGAffineTransform.identity
    })
  }
}

// MARK: - Model

extension SKBarButtonView {
  public struct Model {
    let leftImage: UIImage?
    let centerText: String?
    let rightImage: UIImage?
    let isEnabled: Bool
    var action: (() -> Void)?
    
    // MARK: - Initialization
    /// Инициализатор
    /// - Parameters:
    ///  - leftImage: Изображение слева
    ///  - centerText: Текст по центру
    ///  - rightImage: Изображение справа
    ///  - isEnabled: На вьюшку можно нажать
    ///  - action: Нажатие на Вью
    public init(
      leftImage: UIImage? = nil,
      centerText: String? = nil,
      rightImage: UIImage? = nil,
      isEnabled: Bool = true,
      action: (() -> Void)? = nil
    ) {
      self.leftImage = leftImage
      self.centerText = centerText
      self.rightImage = rightImage
      self.isEnabled = isEnabled
      self.action = action
    }
  }
}

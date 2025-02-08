//
//  SKChatBarButtonView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 26.06.2024.
//

import UIKit
import SKStyle

public final class SKChatBarButtonView: UIControl {
  
  // MARK: - Private properties
  
  public let iconLeftView = UIImageView()
  public var typingIndicator = TypingIndicatorUIView()
  public let titleView = UILabel()
  public let descriptionView = UILabel()
  public let iconRightView = UIImageView()
  
  private let verticalStackView = UIStackView()
  private let horizontalStackView = UIStackView()
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
  
  public init(_ model: SKChatBarButtonView.Model) {
    super.init(frame: .zero)
    configureLayout()
    applyDefaultBehavior(model)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private

private extension SKChatBarButtonView {
  func configureLayout() {
    [typingIndicator, iconLeftView, descriptionView, iconRightView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      horizontalStackView.addArrangedSubview($0)
    }
    
    [titleView, horizontalStackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      verticalStackView.addArrangedSubview($0)
    }
    
    [verticalStackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      iconLeftView.widthAnchor.constraint(equalToConstant: .s4),
      iconLeftView.heightAnchor.constraint(equalToConstant: .s4),
      typingIndicator.widthAnchor.constraint(equalToConstant: .s8),
      typingIndicator.heightAnchor.constraint(equalToConstant: .s4),
      
      iconRightView.widthAnchor.constraint(equalToConstant: .s4),
      iconRightView.heightAnchor.constraint(equalToConstant: .s4),
      
      verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      verticalStackView.topAnchor.constraint(equalTo: topAnchor),
      verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func applyDefaultBehavior(_ model: SKChatBarButtonView.Model) {
    iconLeftView.contentMode = .scaleAspectFit
    iconLeftView.layer.cornerRadius = .s2
    iconLeftView.clipsToBounds = true
    typingIndicator.isHidden = true
    
    titleView.font = .fancy.text.regularMedium
    titleView.textColor = SKStyleAsset.ghost.color
    
    descriptionView.font = .fancy.text.regular
    descriptionView.textColor = SKStyleAsset.constantSlate.color
    
    iconRightView.contentMode = .scaleAspectFit
    iconRightView.layer.cornerRadius = .s2
    iconRightView.clipsToBounds = true
    iconRightView.tintColor = SKStyleAsset.ghost.color
    
    horizontalStackView.axis = .horizontal
    horizontalStackView.alignment = .center
    horizontalStackView.spacing = .s2
    
    verticalStackView.axis = .vertical
    verticalStackView.alignment = .center
    verticalStackView.spacing = .s1
    
    iconLeftView.image = model.leftImage
    titleView.text = model.centerText
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

extension SKChatBarButtonView {
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


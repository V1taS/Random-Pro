//
//  ImageAndLabelWithButtonBigView.swift
//  
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit
import FancyStyle

/// View для экрана
public final class ImageAndLabelWithButtonBigView: UIView {
  
  // MARK: - Style
  
  public enum Style {
    
    /// Выбран
    case selected
    
    /// Не выбран
    case none
  }
  
  // MARK: - Public property
  
  /// Стиль ячейки (выбрана или не выбрана)
  public var style: Style = .none {
    didSet {
      layer.borderWidth = 2
      layer.borderColor = style == .selected ? .fancy.only.primaryBlue.cgColor : UIColor.clear.cgColor
    }
  }
  
  // MARK: - Private property
  
  private let leftSideEmojiView = UILabel()
  private let titleLabel = UILabel()
  private let rightButtonView = UIButton(type: .system)
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private var actionCell: (() -> Void)?
  private var actionButton: (() -> Void)?
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    applyDefaultBehavior()
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public func
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    actionCell?()
    self.zoomIn(duration: Appearance().resultDuration,
                transformScale: CGAffineTransform(scaleX: 0.95, y: 0.95))
    impactFeedback.impactOccurred()
  }
  
  /// Настраиваем вью
  /// - Parameters:
  ///  - leftSideEmoji: Смайлик слева
  ///  - titleText: Текст
  ///  - rightButtonImage: Кнопка справа
  ///  - actionCell: Нажатие на ячейку
  ///  - actionButton: Нажатие на кнопку справа
  public func configureWith(leftSideEmoji: Character?,
                            titleText: String?,
                            rightButtonImage: UIImage?,
                            actionCell: (() -> Void)?,
                            actionButton: (() -> Void)?) {
    leftSideEmojiView.text = String(leftSideEmoji ?? " ")
    titleLabel.text = titleText
    self.actionCell = actionCell
    self.actionButton = actionButton
    rightButtonView.setImage(rightButtonImage, for: .normal)
  }
}

// MARK: - Private

private extension ImageAndLabelWithButtonBigView {
  func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.secondaryWhite
    clipsToBounds = true
    layer.cornerRadius = Appearance().cornerRadius
    
    titleLabel.font = fancyFont.primaryMedium18
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    rightButtonView.setContentHuggingPriority(.required, for: .horizontal)
    rightButtonView.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
  }
  
  func configureLayout() {
    let appearance = Appearance()
    
    [leftSideEmojiView, titleLabel, rightButtonView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      leftSideEmojiView.widthAnchor.constraint(equalToConstant: appearance.imageSize),
      leftSideEmojiView.heightAnchor.constraint(equalToConstant: appearance.imageSize),
      rightButtonView.widthAnchor.constraint(equalToConstant: appearance.imageSize),
      rightButtonView.heightAnchor.constraint(equalToConstant: appearance.imageSize),
      
      leftSideEmojiView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                 constant: appearance.insets.left),
      leftSideEmojiView.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      
      titleLabel.leadingAnchor.constraint(equalTo: leftSideEmojiView.trailingAnchor,
                                          constant: appearance.insets.left / 2),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      rightButtonView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      rightButtonView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -appearance.insets.right),
      rightButtonView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: appearance.insets.top),
      rightButtonView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -appearance.insets.bottom)
    ])
  }
  
  @objc
  func rightButtonAction() {
    guard let actionButton else {
      return
    }
    actionButton()
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension ImageAndLabelWithButtonBigView {
  struct Appearance {
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    let imageSize: CGFloat = 32
    let resultDuration: CGFloat = 0.2
    let borderMaskWidth: CGFloat = 4
    let cornerRadius: CGFloat = 16
  }
}


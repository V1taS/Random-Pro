//
//  CardLockView.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 12.07.2023.
//

import UIKit
import FancyStyle

/// View для экрана
public final class CardLockView: UIView {
  
  /// Состояние вьюшки
  public enum CardState {
    
    /// Заблокирована
    case lock
    
    /// Выбрана
    case checkmark
    
    /// Ничего
    case none
  }
  
  // MARK: - Private properties
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let lockLabelView = UILabel()
  private let checkmarkView = UILabel()
  private var cardAction: (() -> Void)?
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
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - image: Изображение
  ///  - title: Название
  ///  - cardState: Стиль карточки
  ///  - cardAction: Действие по нажатию на карточку
  public func configureWith(image: UIImage?,
                            title: String?,
                            cardState: CardState,
                            cardAction: (() -> Void)? = nil) {
    titleLabel.text = title
    imageView.image = image
    self.cardAction = cardAction
    
    switch cardState {
    case .lock:
      lockLabelView.isHidden = false
      checkmarkView.isHidden = true
    case .checkmark:
      lockLabelView.isHidden = true
      checkmarkView.isHidden = false
    case .none:
      lockLabelView.isHidden = true
      checkmarkView.isHidden = true
    }
  }
  
  /// Установить замочек на иконке
  public func setIsLocked(_ isLocked: Bool) {
    lockLabelView.isHidden = !isLocked
  }
  
  /// Установить галочку справа
  public func setIsCheckmark(_ isCheckmark: Bool) {
    checkmarkView.isHidden = !isCheckmark
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    [imageView, titleLabel, lockLabelView, checkmarkView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      imageView.heightAnchor.constraint(equalToConstant: appearance.cardSize.height),
      imageView.widthAnchor.constraint(equalToConstant: appearance.cardSize.width),
      
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                      constant: appearance.defaultInset),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      lockLabelView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: appearance.defaultInset),
      lockLabelView.topAnchor.constraint(equalTo: topAnchor,
                                         constant: -appearance.defaultInset),
      
      checkmarkView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: appearance.middleInsets + appearance.minInsets),
      checkmarkView.topAnchor.constraint(equalTo: topAnchor,
                                         constant: -appearance.middleInsets - appearance.minInsets)
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    
    titleLabel.font = fancyFont.primaryMedium16
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    titleLabel.numberOfLines = appearance.numberOfLines
    titleLabel.textAlignment = .center
    
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = appearance.cornerRadius
    imageView.clipsToBounds = true
    lockLabelView.text = "🔒"
    lockLabelView.font = fancyFont.primaryRegular32
    checkmarkView.text = "✅"
    checkmarkView.font = fancyFont.primaryRegular24
    
    titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    
    let cardTap = UITapGestureRecognizer(target: self, action: #selector(cardViewAction))
    cardTap.cancelsTouchesInView = false
    addGestureRecognizer(cardTap)
    isUserInteractionEnabled = true
  }
  
  @objc
  private func cardViewAction() {
    guard cardAction != nil else {
      return
    }
    
    cardAction?()
    impactFeedback.impactOccurred()
    zoomIn(duration: Appearance().resultDuration,
           transformScale: CGAffineTransform(scaleX: 0.9, y: 0.9))
  }
}

// MARK: - Appearance

private extension CardLockView {
  struct Appearance {
    let cornerRadius: CGFloat = 16
    let cardSize = CGSize(width: 130, height: 130)
    let shadowRadius: CGFloat = 4
    let shadowOpacity: Float = 0.2
    let minInsets: CGFloat = 4
    let middleInsets: CGFloat = 8
    let defaultInset: CGFloat = 16
    let numberOfLines = 2
    let resultDuration: CGFloat = 0.2
  }
}

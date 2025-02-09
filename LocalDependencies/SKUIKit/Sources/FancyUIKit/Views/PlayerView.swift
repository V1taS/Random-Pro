//
//  PlayerView.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit
import FancyStyle

/// View для экрана
public final class PlayerView: UIView {
  
  /// Стиль карточки
  public enum StyleCard: String, CaseIterable, Equatable & Codable {

    /// Стиль по умолчанию
    case defaultStyle
    
    /// Стиль темно-зеленый
    case darkGreen
    
    /// Стиль темно-синий
    case darkBlue
    
    /// Стиль темно-оранжевый
    case darkOrange
    
    /// Стиль темно-красный
    case darkRed
    
    /// Стиль темно-фиолетовый
    case darkPurple
    
    /// Стиль темно-розовый
    case darkPink
    
    /// Стиль темно-желтый
    case darkYellow
    
    /// Цвет текста на карточке
    var nameTextColor: UIColor {
      switch self {
      case .defaultStyle:
        return .fancy.only.primaryWhite
      default:
        return .fancy.only.primaryWhite
      }
    }
    
    /// Цвет фона карточки
    var backgroundColor: [UIColor] {
      switch self {
      case .darkGreen:
        return [.fancy.only.primaryGray,
                .fancy.only.primaryGreen]
      case .defaultStyle:
        return [.fancy.only.lightGray,
                .fancy.only.lightGray]
      case .darkBlue:
        return [.fancy.only.primaryGray,
                .fancy.only.secondaryBlue]
      case .darkOrange:
        return [.fancy.only.primaryGray,
                .fancy.only.primaryOrange]
      case .darkRed:
        return [.fancy.only.primaryGray,
                .fancy.only.primaryRed]
      case .darkPurple:
        return [.fancy.only.primaryGray,
                .fancy.only.primaryPurple]
      case .darkPink:
        return [.fancy.only.primaryGray,
                .fancy.only.primaryPink]
      case .darkYellow:
        return [.fancy.only.primaryGray,
                .fancy.only.primaryYellow]
      }
    }
  }
  
  /// Смайлики на карточке
  public enum StyleEmoji {
    
    /// Буз смайла
    case none
    
    /// Футбольный мяч
    case ball
    
    /// Лайк
    case like
    
    /// Звезда
    case star
    
    /// Настраиваемый стиль
    case customEmoji(Character?)
    
    var emoji: Character? {
      switch self {
      case .none:
        return nil
      case .ball:
        return "⚽️"
      case .like:
        return "👍"
      case .star:
        return "⭐️"
      case .customEmoji(let emoji):
        return emoji
      }
    }
  }
  
  // MARK: - Public properties
  
  public override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }
  
  // MARK: - Private properties
  
  private let avatarImageView = UIImageView()
  private let emojiLabel = UILabel()
  private let nameLabel = UILabel()
  private let gradientView = GradientView()
  private let lockLabelView = UILabel()
  private let checkmarkView = UILabel()
  
  private var emojiAction: (() -> Void)?
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
  ///  - avatar: Аватарка
  ///  - name: Имя
  ///  - styleCard: Стиль карточки
  ///  - styleEmoji: Стиль смайликов
  ///  - setIsCheckmark: Установить галочку
  ///  - setIsLocked: Установить замочек на иконке
  ///  - emojiAction: Действие по нажатию на смайл
  ///  - cardAction: Действие по нажатию на карточку
  public func configureWith(avatar: UIImage?,
                            name: String?,
                            styleCard: StyleCard,
                            styleEmoji: StyleEmoji = .none,
                            setIsCheckmark: Bool = false,
                            setIsLocked: Bool = false,
                            emojiAction: (() -> Void)? = nil,
                            cardAction: (() -> Void)? = nil) {
    gradientView.applyGradient(colors: styleCard.backgroundColor)
    nameLabel.text = name
    nameLabel.textColor = styleCard.nameTextColor
    avatarImageView.image = avatar
    self.emojiAction = emojiAction
    self.cardAction = cardAction
    lockLabelView.isHidden = !setIsLocked
    checkmarkView.isHidden = !setIsCheckmark
    
    if let emoji = styleEmoji.emoji {
      emojiLabel.text = String(emoji)
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
    
    [avatarImageView, emojiLabel, nameLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      gradientView.addSubview($0)
    }
    
    [gradientView, lockLabelView, checkmarkView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: appearance.cardSize.height),
      widthAnchor.constraint(equalToConstant: appearance.cardSize.width),
      
      gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
      gradientView.topAnchor.constraint(equalTo: topAnchor),
      gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
      gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      avatarImageView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor,
                                               constant: appearance.avatarImageInset),
      avatarImageView.topAnchor.constraint(equalTo: gradientView.topAnchor,
                                           constant: appearance.avatarImageInset),
      avatarImageView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor,
                                                constant: -appearance.avatarImageInset),
      avatarImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor,
                                              constant: -appearance.minInsets),
      
      emojiLabel.topAnchor.constraint(equalTo: gradientView.topAnchor,
                                      constant: appearance.minInsets),
      emojiLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor,
                                           constant: -appearance.minInsets),
      
      nameLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor,
                                         constant: appearance.middleInsets),
      nameLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor,
                                        constant: -appearance.middleInsets),
      nameLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor,
                                          constant: -appearance.middleInsets),
      
      lockLabelView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: appearance.middleInsets),
      lockLabelView.topAnchor.constraint(equalTo: topAnchor,
                                         constant: -appearance.middleInsets),
      
      checkmarkView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: appearance.middleInsets),
      checkmarkView.topAnchor.constraint(equalTo: topAnchor,
                                              constant: -appearance.middleInsets)
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    layer.cornerRadius = appearance.cornerRadius
    gradientView.layer.cornerRadius = appearance.cornerRadius
    
    emojiLabel.font = fancyFont.primaryMedium18
    
    nameLabel.font = fancyFont.primaryBold10
    nameLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    nameLabel.numberOfLines = appearance.numberOfLines
    nameLabel.textAlignment = .center
    
    avatarImageView.contentMode = .scaleAspectFit
    gradientView.clipsToBounds = true
    lockLabelView.text = "🔒"
    checkmarkView.text = "✅"
    
    nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    avatarImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    
    let emojiTap = UITapGestureRecognizer(target: self, action: #selector(emojiLabelAction))
    emojiTap.cancelsTouchesInView = false
    emojiLabel.addGestureRecognizer(emojiTap)
    emojiLabel.isUserInteractionEnabled = true
    
    let cardTap = UITapGestureRecognizer(target: self, action: #selector(cardViewAction))
    cardTap.cancelsTouchesInView = false
    addGestureRecognizer(cardTap)
    isUserInteractionEnabled = true
  }
  
  @objc
  private func emojiLabelAction() {
    guard emojiAction != nil else {
      return
    }
    
    emojiAction?()
    impactFeedback.impactOccurred()
  }
  
  @objc
  private func cardViewAction() {
    guard cardAction != nil else {
      return
    }
    
    cardAction?()
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension PlayerView {
  struct Appearance {
    let cornerRadius: CGFloat = 16
    let cardSize = CGSize(width: 90, height: 100)
    let shadowRadius: CGFloat = 4
    let shadowOpacity: Float = 0.2
    let minInsets: CGFloat = 4
    let middleInsets: CGFloat = 8
    let numberOfLines = 2
    let avatarImageInset: CGFloat = 4
    
    let checkmarkImage = UIImage(systemName: "checkmark.circle.fill",
                                 withConfiguration: UIImage.SymbolConfiguration(scale: .large))
  }
}

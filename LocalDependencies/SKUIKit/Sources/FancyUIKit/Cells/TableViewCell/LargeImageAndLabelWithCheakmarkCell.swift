//
//  LargeImageAndLabelWithCheakmarkCell.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 25.01.2023.
//

import UIKit
import FancyStyle

// MARK: - LargeImageAndLabelWithCheakmarkCell

public final class LargeImageAndLabelWithCheakmarkCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = LargeImageAndLabelWithCheakmarkCell.description()
  
  // MARK: - Private property
  
  private let titleLabel = UILabel()
  private let checkmarkImageView = UIImageView()
  private let leftSideImageView = UIImageView()
  private let leftSideSquircleView = SquircleView()
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private var action: ((_ isCheckmark: Bool) -> Void)?
  private let lockLabelView = UILabel()
  
  // MARK: - Initilisation
  
  public override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Public func
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    backgroundColor = .fancy.darkAndLightTheme.secondaryGray.withAlphaComponent(0.1)
    contentView.backgroundColor = .fancy.darkAndLightTheme.secondaryGray.withAlphaComponent(0.1)
  }
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    action?(!checkmarkImageView.isHidden)
    impactFeedback.impactOccurred()
  }
  
  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
  }
  
  /// Установить галочку справа
  public func setIsCheckmark(_ isCheckmark: Bool) {
    checkmarkImageView.isHidden = !isCheckmark
  }
  
  /// Установить замочек на иконке
  public func setIsLocked(_ isLocked: Bool) {
    lockLabelView.isHidden = !isLocked
  }
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - leftSideImage: Картинка слева
  ///  - titleText: Заголовок
  ///  - setIsCheckmark: Установить галочку справа
  ///  - setIsLocked: Установить замочек на иконке
  ///  - action: Действие при нажатии
  public func configureCellWith(leftSideImage: UIImage?,
                                titleText: String?,
                                setIsCheckmark: Bool,
                                setIsLocked: Bool,
                                action: ((_ isCheckmark: Bool) -> Void)?) {
    self.action = action
    titleLabel.text = titleText
    checkmarkImageView.isHidden = !setIsCheckmark
    lockLabelView.isHidden = !setIsLocked
    checkmarkImageView.image = Appearance().checkmarkImage
    checkmarkImageView.setImageColor(color: .fancy.only.primaryBlue)
    leftSideImageView.image = leftSideImage
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    [leftSideImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      leftSideSquircleView.addSubview($0)
    }
    
    [titleLabel, checkmarkImageView, leftSideSquircleView, lockLabelView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      leftSideSquircleView.widthAnchor.constraint(equalToConstant: appearance.imageSize),
      leftSideSquircleView.heightAnchor.constraint(equalToConstant: appearance.imageSize),
      
      leftSideSquircleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: appearance.insets.left),
      leftSideSquircleView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: appearance.insets.top),
      leftSideSquircleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: -appearance.insets.bottom),
      
      leftSideImageView.leadingAnchor.constraint(equalTo: leftSideSquircleView.leadingAnchor),
      leftSideImageView.topAnchor.constraint(equalTo: leftSideSquircleView.topAnchor),
      leftSideImageView.trailingAnchor.constraint(equalTo: leftSideSquircleView.trailingAnchor),
      leftSideImageView.bottomAnchor.constraint(equalTo: leftSideSquircleView.bottomAnchor),
      
      lockLabelView.trailingAnchor.constraint(equalTo: leftSideSquircleView.trailingAnchor,
                                              constant: appearance.midInset),
      lockLabelView.topAnchor.constraint(equalTo: leftSideSquircleView.topAnchor,
                                         constant: -appearance.minInset),
      
      titleLabel.leadingAnchor.constraint(equalTo: leftSideSquircleView.trailingAnchor,
                                          constant: appearance.insets.left),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      checkmarkImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -appearance.insets.right),
      checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    checkmarkImageView.contentMode = .right
    checkmarkImageView.setContentHuggingPriority(.required, for: .horizontal)
    
    titleLabel.font = fancyFont.primaryRegular16
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    leftSideSquircleView.clipsToBounds = true
    
    lockLabelView.text = "🔒"
  }
}

// MARK: - Appearance

private extension LargeImageAndLabelWithCheakmarkCell {
  struct Appearance {
    let minInset: CGFloat = 8
    let midInset: CGFloat = 12
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    let imageSize: CGFloat = 56
    let checkmarkImage = UIImage(systemName: "checkmark",
                                 withConfiguration: UIImage.SymbolConfiguration(scale: .large))
  }
}

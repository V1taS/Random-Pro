//
//  SquircleImageAndDoubleTitleCell.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 25.01.2023.
//

import UIKit
import FancyStyle

// MARK: - SquircleImageAndDoubleTitleCell

public final class SquircleImageAndDoubleTitleCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = SquircleImageAndDoubleTitleCell.description()
  
  // MARK: - Private property
  
  private let primaryLable = UILabel()
  private let secondaryLabel = UILabel()
  private let leftSideImageView = UIImageView()
  private let leftSideSquircleView = SquircleView()
  
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
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - squircleBGColors: Squircle цвет фона
  ///  - squircleBGAlpha: Squircle прозрачность
  ///  - leftSideImage: Картинка слева
  ///  - leftSideImageColor: Цвет картинки слева
  ///  - primaryText: Первичный текст
  ///  - primaryTextColor: Первичный цвет текста
  ///  - primaryTextFont: Первичный шрифт текста
  ///  - secondaryText: Вторичный текст
  ///  - secondaryTextColor: Вторичный цвет текст
  ///  - secondaryTextFont: Вторичный шрифт текст
  public func configureCellWith(squircleBGColors: [UIColor],
                                squircleBGAlpha: CGFloat = 1,
                                leftSideImage: UIImage?,
                                leftSideImageColor: UIColor?,
                                primaryText: String?,
                                primaryTextColor: UIColor = .fancy.darkAndLightTheme.primaryGray,
                                primaryTextFont: UIFont = fancyFont.primaryRegular18,
                                secondaryText: String?,
                                secondaryTextColor: UIColor = .fancy.darkAndLightTheme.primaryGray,
                                secondaryTextFont: UIFont = fancyFont.primaryRegular18) {
    primaryLable.text = primaryText
    primaryLable.textColor = primaryTextColor
    primaryLable.font = primaryTextFont
    
    secondaryLabel.text = secondaryText
    secondaryLabel.textColor = secondaryTextColor
    secondaryLabel.font = secondaryTextFont
    leftSideImageView.image = leftSideImage
    leftSideImageView.setImageColor(color: leftSideImageColor ?? .fancy.darkAndLightTheme.primaryGray)
    leftSideSquircleView.applyGradient(colors: squircleBGColors,
                                       alpha: squircleBGAlpha)
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    [leftSideImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      leftSideSquircleView.addSubview($0)
    }
    
    [primaryLable, secondaryLabel, leftSideSquircleView].forEach {
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
      
      leftSideImageView.leadingAnchor.constraint(equalTo: leftSideSquircleView.leadingAnchor,
                                                 constant: appearance.minInset),
      leftSideImageView.topAnchor.constraint(equalTo: leftSideSquircleView.topAnchor,
                                             constant: appearance.minInset),
      leftSideImageView.trailingAnchor.constraint(equalTo: leftSideSquircleView.trailingAnchor,
                                                  constant: -appearance.minInset),
      leftSideImageView.bottomAnchor.constraint(equalTo: leftSideSquircleView.bottomAnchor,
                                                constant: -appearance.minInset),
      
      primaryLable.leadingAnchor.constraint(equalTo: leftSideSquircleView.trailingAnchor,
                                            constant: appearance.insets.left),
      primaryLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      secondaryLabel.leadingAnchor.constraint(equalTo: primaryLable.trailingAnchor),
      secondaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -appearance.insets.right),
      secondaryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    secondaryLabel.font = fancyFont.primaryRegular18
    secondaryLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    secondaryLabel.textAlignment = .right
    secondaryLabel.setContentHuggingPriority(.required, for: .horizontal)
    
    primaryLable.font = fancyFont.primaryRegular18
    primaryLable.textColor = .fancy.darkAndLightTheme.primaryGray
    primaryLable.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }
}

// MARK: - Appearance

private extension SquircleImageAndDoubleTitleCell {
  struct Appearance {
    let minInset: CGFloat = 3
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    let imageSize: CGFloat = 32
  }
}

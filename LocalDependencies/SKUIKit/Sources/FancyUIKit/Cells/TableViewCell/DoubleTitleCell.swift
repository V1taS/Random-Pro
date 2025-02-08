//
//  DoubleTitleCell.swift
//
//  Created by Tatiana Sosina on 22.05.2022.
//

import UIKit
import FancyStyle

// MARK: - DoubleTitleCell

public final class DoubleTitleCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = DoubleTitleCell.description()
  
  // MARK: - Private property
  
  private let primaryLabel = UILabel()
  private let secondaryLabel = UILabel()
  
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

  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - primaryText: Первичный текст
  ///  - primaryTextColor: Первичный цвет текста
  ///  - primaryTextFont: Первичный шрифт текста
  ///  - secondaryText: Вторичный текст
  ///  - secondaryTextColor: Вторичный цвет текст
  ///  - secondaryTextFont: Вторичный шрифт текст
  public func configureCellWith(primaryText: String?,
                                primaryTextColor: UIColor = .fancy.darkAndLightTheme.primaryGray,
                                primaryTextFont: UIFont = fancyFont.primaryRegular18,
                                secondaryText: String?,
                                secondaryTextColor: UIColor = .fancy.darkAndLightTheme.primaryGray,
                                secondaryTextFont: UIFont = fancyFont.primaryRegular18) {
    primaryLabel.text = primaryText
    primaryLabel.textColor = primaryTextColor
    primaryLabel.font = primaryTextFont
    
    secondaryLabel.text = secondaryText
    secondaryLabel.textColor = secondaryTextColor
    secondaryLabel.font = secondaryTextFont
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [primaryLabel, secondaryLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    NSLayoutConstraint.activate([
      primaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                            constant: appearance.insets.left),
      primaryLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                        constant: appearance.insets.top),
      primaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                           constant: -appearance.insets.bottom),
      
      secondaryLabel.leadingAnchor.constraint(equalTo: primaryLabel.trailingAnchor),
      secondaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -appearance.insets.right),
      secondaryLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                          constant: appearance.insets.top),
      secondaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -appearance.insets.bottom)
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
    
    primaryLabel.font = fancyFont.primaryRegular18
    primaryLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    primaryLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }
}

// MARK: - Appearance

private extension DoubleTitleCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
  }
}

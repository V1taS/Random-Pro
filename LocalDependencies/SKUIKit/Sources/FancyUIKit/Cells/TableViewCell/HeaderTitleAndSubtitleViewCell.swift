//
//  HeaderTitleAndSubtitleViewCell.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 16.01.2023.
//

import UIKit
import FancyStyle

// MARK: - HeaderTitleAndSubtitleViewCell

public final class HeaderTitleAndSubtitleViewCell: UITableViewCell {
  
  // MARK: - Public properties
  
  /// Identifier для ячейки
  public static let reuseIdentifier = HeaderTitleAndSubtitleViewCell.description()
  
  // MARK: - Private properties
  
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  
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
  ///  - title: Заголовок
  ///  - subtitle: Под заголовок
  ///  - titleColor: Цвет заголовка
  ///  - subtitleColor: Цвет под заголовка
  ///  - titleFont: Шрифт заголовка
  ///  - subtitleFont: Шрифт под заголовка
  ///  - titleTextAlignment: Выравнивание заголовка
  ///  - subtitleTextAlignment: Выравнивание под заголовка
  public func configureCellWith(title: String?,
                                subtitle: String?,
                                titleColor: UIColor? = nil,
                                subtitleColor: UIColor? = nil,
                                titleFont: UIFont? = nil,
                                subtitleFont: UIFont? = nil,
                                titleTextAlignment: NSTextAlignment? = nil,
                                subtitleTextAlignment: NSTextAlignment? = nil) {
    titleLabel.text = title
    subtitleLabel.text = subtitle
    
    if let titleColor {
      titleLabel.textColor = titleColor
    }
    
    if let subtitleColor {
      subtitleLabel.textColor = subtitleColor
    }
    
    if let titleFont {
      titleLabel.font = titleFont
    }
    
    if let subtitleFont {
      subtitleLabel.font = subtitleFont
    }
    
    if let titleTextAlignment {
      titleLabel.textAlignment = titleTextAlignment
    }
    
    if let subtitleTextAlignment {
      subtitleLabel.textAlignment = subtitleTextAlignment
    }
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [titleLabel, subtitleLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                          constant: appearance.defaultInsets),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                           constant: -appearance.defaultInsets),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                      constant: appearance.minInset),
      
      subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                             constant: appearance.defaultInsets),
      subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                              constant: -appearance.defaultInsets),
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                         constant: appearance.minInset),
      subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                            constant: -appearance.minInset)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    titleLabel.numberOfLines = .zero
    titleLabel.font = fancyFont.primaryBold32
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    titleLabel.textAlignment = .center
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    
    subtitleLabel.numberOfLines = .zero
    subtitleLabel.font = fancyFont.primaryMedium18
    subtitleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    subtitleLabel.textAlignment = .center
    subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
  }
}

// MARK: - Appearance

private extension HeaderTitleAndSubtitleViewCell {
  struct Appearance {
    let minInset: CGFloat = 4
    let defaultInsets: CGFloat = 16
  }
}

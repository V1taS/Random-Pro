//
//  CustomTextCell.swift
//
//  Created by Vitalii Sosin on 22.05.2022.
//

import UIKit
import FancyStyle

// MARK: - CustomTextCell

public final class CustomTextCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = CustomTextCell.description()
  
  // MARK: - Private property
  
  private let titleLabel = UILabel()
  
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
  ///  - titleText: Текст заголовка
  ///  - textColor: Цвет текста
  ///  - textFont: Шрифт текста
  ///  - textAlignment: Выравнивание текста
  public func configureCellWith(titleText: String?,
                                textColor: UIColor?,
                                textFont: UIFont? = fancyFont.primaryRegular18,
                                textAlignment: NSTextAlignment) {
    titleLabel.text = titleText
    titleLabel.textColor = textColor
    titleLabel.font = textFont
    titleLabel.textAlignment = textAlignment
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [titleLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                          constant: appearance.insets.left),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                      constant: appearance.insets.top),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                           constant: -appearance.insets.right),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                         constant: -appearance.insets.bottom)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    titleLabel.font = fancyFont.primaryRegular18
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = .zero
  }
}

// MARK: - Appearance

private extension CustomTextCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
  }
}

//
//  CustomDoubleTextHeaderCollectionCell.swift
//  
//
//  Created by Vitalii Sosin on 13.08.2022.
//

import UIKit
import FancyStyle

// MARK: - CustomDoubleTextHeaderCollectionCell

public final class CustomDoubleTextHeaderCollectionCell: UICollectionReusableView {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = CustomDoubleTextHeaderCollectionCell.description()
  
  // MARK: - Private property
  
  private let primaryLabel = UILabel()
  private let secondaryLabel = UILabel()
  private let editButton = UIButton()
  private var editAction: (() -> Void)?
  
  // MARK: - Initilisation
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    fatalError()
  }
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - primaryText: Первичный текст
  ///  - primaryTextColor: Первичный цвет текста
  ///  - primaryTextFont: Первичный шрифт текста
  ///  - secondaryText: Вторичный текст
  ///  - secondaryTextColor: Вторичный цвет текст
  ///  - secondaryTextFont: Вторичный шрифт текст
  ///  - editImage: Изображение для кнопки
  ///  - editAction: Экшен
  public func configureCellWith(primaryText: String?,
                                primaryTextColor: UIColor = .fancy.darkAndLightTheme.primaryGray,
                                primaryTextFont: UIFont = fancyFont.primaryRegular18,
                                secondaryText: String?,
                                secondaryTextColor: UIColor = .fancy.darkAndLightTheme.primaryGray,
                                secondaryTextFont: UIFont = fancyFont.primaryRegular18,
                                editImage: UIImage? = nil,
                                editAction: (() -> Void)? = nil) {
    primaryLabel.text = primaryText
    primaryLabel.textColor = primaryTextColor
    primaryLabel.font = primaryTextFont
    
    secondaryLabel.text = secondaryText
    secondaryLabel.textColor = secondaryTextColor
    secondaryLabel.font = secondaryTextFont
    self.editAction = editAction
    editButton.setImage(editImage, for: .normal)
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [primaryLabel, secondaryLabel, editButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    NSLayoutConstraint.activate([
      primaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: appearance.insets.left),
      primaryLabel.topAnchor.constraint(equalTo: topAnchor,
                                        constant: appearance.insets.top),
      primaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                           constant: -appearance.insets.bottom),
      
      editButton.leadingAnchor.constraint(equalTo: primaryLabel.trailingAnchor,
                                          constant: appearance.insets.left),
      editButton.topAnchor.constraint(equalTo: topAnchor,
                                      constant: appearance.insets.top),
      editButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                         constant: -appearance.insets.bottom),
      
      
      secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.insets.right),
      secondaryLabel.topAnchor.constraint(equalTo: topAnchor,
                                          constant: appearance.insets.top),
      secondaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                             constant: -appearance.insets.bottom)
    ])
  }
  
  @objc func editButtonTapped() {
    guard editAction != nil else {
      return
    }
    editAction?()
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    
    secondaryLabel.font = fancyFont.primaryRegular18
    secondaryLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    secondaryLabel.textAlignment = .right
    secondaryLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    primaryLabel.font = fancyFont.primaryRegular18
    primaryLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    primaryLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    
    editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
  }
}

// MARK: - Appearance

private extension CustomDoubleTextHeaderCollectionCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
  }
}

//
//  SaleTableViewCell.swift
//  FancyUIKit
//
//  Created by Vitalii Sosin on 29.10.2023.
//

import UIKit
import FancyStyle

// MARK: - SmallButtonCell

public final class SaleTableViewCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = SaleTableViewCell.description()
  
  // MARK: - Private property
  
  private let oldPriceLabel = UILabel()
  private let newPriceLabel = UILabel()
  private let titleLabel = UILabel()
  private let strikeThroughView = DiagonalStrikeThroughView()
  private let verticalStack = UIStackView()
  
  // MARK: - Initilisation
  
  public override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    strikeThroughView.setNeedsDisplay()
  }
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - title: Заголовок
  ///  - oldPrice: Старая цена
  ///  - newPrice: Новая цена
  public func configureCellWith(title: String?, oldPrice: String?, newPrice: String?) {
    oldPriceLabel.text = oldPrice
    newPriceLabel.text = newPrice
    titleLabel.text = title
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    [strikeThroughView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      oldPriceLabel.addSubview($0)
    }
    [titleLabel, oldPriceLabel, newPriceLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      verticalStack.addArrangedSubview($0)
    }
    [verticalStack].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                             constant: appearance.insets.left),
      verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor,
                                         constant: appearance.insets.top),
      verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                              constant: -appearance.insets.right),
      verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                            constant: -appearance.insets.bottom),
      
      strikeThroughView.leadingAnchor.constraint(equalTo: oldPriceLabel.leadingAnchor),
      strikeThroughView.trailingAnchor.constraint(equalTo: oldPriceLabel.trailingAnchor),
      strikeThroughView.topAnchor.constraint(equalTo: oldPriceLabel.topAnchor),
      strikeThroughView.bottomAnchor.constraint(equalTo: oldPriceLabel.bottomAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    oldPriceLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    oldPriceLabel.font = .fancy.primaryRegular32
    newPriceLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    newPriceLabel.font = .fancy.primaryBold32
    
    titleLabel.textColor = .fancy.only.primaryRed
    titleLabel.font = .fancy.primaryBold32
    titleLabel.numberOfLines = .zero
    titleLabel.textAlignment = .center
    
    verticalStack.axis = .vertical
    verticalStack.alignment = .center
    verticalStack.spacing = 8
    verticalStack.setCustomSpacing(16, after: titleLabel)
  }
}

// MARK: - Appearance

private extension SaleTableViewCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
  }
}

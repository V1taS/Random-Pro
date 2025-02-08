//
//  LabelBigGrayCell.swift
//  
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit
import FancyStyle

// MARK: - LabelBigGrayCell

public final class LabelBigGrayCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = LabelBigGrayCell.description()
  
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
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - titleText: Текст
  public func configureCellWith(titleText: String?) {
    titleLabel.text = titleText
  }
}

// MARK: - Private

private extension LabelBigGrayCell {
  func configureLayout() {
    let appearance = Appearance()
    [titleLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: appearance.imageSize),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                          constant: appearance.minInset),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                           constant: -appearance.minInset)
    ])
  }
  
  func applyDefaultBehavior() {
    selectionStyle = .none
    contentView.backgroundColor = .fancy.darkAndLightTheme.secondaryWhite
    backgroundColor = .fancy.darkAndLightTheme.secondaryWhite
    clipsToBounds = true
    layer.cornerRadius = Appearance().cornerRadius
  }
}

// MARK: - Appearance

private extension LabelBigGrayCell {
  struct Appearance {
    let cornerRadius: CGFloat = 16
    let minInset: CGFloat = 16
    let imageSize: CGFloat = 32
  }
}

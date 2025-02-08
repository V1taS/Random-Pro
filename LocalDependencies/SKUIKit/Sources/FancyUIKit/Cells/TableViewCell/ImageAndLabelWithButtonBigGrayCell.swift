//
//  ImageAndLabelWithButtonBigGrayCell.swift
//
//  Created by Vitalii Sosin on 16.06.2023.
//

import UIKit
import FancyStyle

// MARK: - ImageAndLabelWithButtonBigGrayCell

public final class ImageAndLabelWithButtonBigGrayCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = ImageAndLabelWithButtonBigGrayCell.description()
  
  /// Стиль ячейки (выбрана или не выбрана)
  public var style: ImageAndLabelWithButtonBigView.Style = .none {
    didSet {
      imageAndLabelWithButtonBigView.style = style
    }
  }
  
  // MARK: - Private property
  
  private let imageAndLabelWithButtonBigView = ImageAndLabelWithButtonBigView()
  
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
    
    imageAndLabelWithButtonBigView.style = .none
  }
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - leftSideEmoji: Смайлик слева
  ///  - titleText: Текст
  ///  - rightButtonImage: Кнопка справа
  ///  - actionCell: Нажатие на ячейку
  ///  - actionButton: Нажатие на кнопку справа
  public func configureCellWith(leftSideEmoji: Character?,
                                titleText: String?,
                                rightButtonImage: UIImage?,
                                actionCell: (() -> Void)?,
                                actionButton: (() -> Void)?) {
    imageAndLabelWithButtonBigView.configureWith(
      leftSideEmoji: leftSideEmoji,
      titleText: titleText,
      rightButtonImage: rightButtonImage,
      actionCell: actionCell,
      actionButton: actionButton
    )
  }
}

// MARK: - Private

private extension ImageAndLabelWithButtonBigGrayCell {
  func configureLayout() {
    [imageAndLabelWithButtonBigView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      imageAndLabelWithButtonBigView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageAndLabelWithButtonBigView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageAndLabelWithButtonBigView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageAndLabelWithButtonBigView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    selectionStyle = .none
    clipsToBounds = true
    layer.cornerRadius = Appearance().cornerRadius
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
  }
}

// MARK: - Appearance

private extension ImageAndLabelWithButtonBigGrayCell {
  struct Appearance {
    let cornerRadius: CGFloat = 16
  }
}

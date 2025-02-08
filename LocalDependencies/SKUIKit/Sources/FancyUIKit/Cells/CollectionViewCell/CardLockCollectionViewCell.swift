//
//  CardLockCollectionViewCell.swift
//  
//
//  Created by Vitalii Sosin on 12.07.2023.
//

import UIKit

/// Ячейка с игроком
public final class CardLockCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Public properties
  
  public static let reuseIdentifier = CardLockCollectionViewCell.description()
  
  // MARK: - Private properties
  
  private let cardLockView = CardLockView()
  
  // MARK: - Initialization
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - image: Изображение
  ///  - title: Название
  ///  - cardState: Стиль карточки
  ///  - cardAction: Действие по нажатию на карточку
  public func configureCellWith(image: UIImage?,
                                title: String?,
                                cardState: CardLockView.CardState,
                                cardAction: (() -> Void)? = nil) {
    cardLockView.configureWith(
      image: image,
      title: title,
      cardState: cardState,
      cardAction: cardAction
    )
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    [cardLockView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      cardLockView.topAnchor.constraint(equalTo: contentView.topAnchor),
      cardLockView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      cardLockView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      cardLockView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
  }
}

// MARK: - Appearance

private extension CardLockCollectionViewCell {
  struct Appearance {}
}

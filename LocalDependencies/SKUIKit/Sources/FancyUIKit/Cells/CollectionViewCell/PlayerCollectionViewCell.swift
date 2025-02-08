//
//  PlayerCollectionViewCell.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit
import FancyStyle

/// Ячейка с игроком
public final class PlayerCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Public properties
  
  public static let reuseIdentifier = PlayerCollectionViewCell.description()
  
  // MARK: - Private properties
  
  private let playerView = PlayerView()
  
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
  ///  - avatar: Аватарка
  ///  - name: Имя
  ///  - styleCard: Стиль карточки
  ///  - styleEmoji: Стиль смайликов
  ///  - setIsCheckmark: Установить галочку
  ///  - setIsLocked: Установить замочек на иконке
  ///  - emojiAction: Действие по нажатию на смайл
  ///  - cardAction: Действие по нажатию на карточку
  public func configureCellWith(avatar: UIImage?,
                                name: String?,
                                styleCard: PlayerView.StyleCard,
                                styleEmoji: PlayerView.StyleEmoji = .none,
                                setIsCheckmark: Bool = false,
                                setIsLocked: Bool = false,
                                emojiAction: (() -> Void)? = nil,
                                cardAction: (() -> Void)? = nil) {
    playerView.configureWith(
      avatar: avatar,
      name: name,
      styleCard: styleCard,
      styleEmoji: styleEmoji,
      setIsCheckmark: setIsCheckmark,
      setIsLocked: setIsLocked,
      emojiAction: emojiAction,
      cardAction: cardAction
    )
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    [playerView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
  }
}

// MARK: - Appearance

private extension PlayerCollectionViewCell {
  struct Appearance {}
}

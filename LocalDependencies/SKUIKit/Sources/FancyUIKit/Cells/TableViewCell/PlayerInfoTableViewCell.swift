//
//  PlayerInfoTableViewCell.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 13.08.2022.
//

import UIKit
import FancyStyle

// MARK: - PlayerInfoTableViewCell

public final class PlayerInfoTableViewCell: UITableViewCell {
  
  /// Identifier для ячейки
  public static let reuseIdentifier = PlayerInfoTableViewCell.description()
  
  // MARK: - Private property
  
  private let avatarImageView = UIImageView()
  private let namePlayerLabel = UILabel()
  private let nameTeamLabel = UILabel()
  private let stackView = UIStackView()
  private let emojiButton = UIButton()
  private let cellButton = UIButton()
  
  private var emojiAction: (() -> Void)?
  private var contentAction: (() -> Void)?
  
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
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
  ///  - avatar: Аватарка
  ///  - namePlayer: Имя игрока
  ///  - namePlayerColor: Цвет имени игрока
  ///  - namePlayerFont: Шрифт имени игрока
  ///  - nameTeam: Имя команды
  ///  - nameTeamColor: Цвет имени команды
  ///  - nameTeamFont: Шрифт имени команды
  ///  - emoji: Смайлик
  ///  - emojiMenu: Меню, отображаемое кнопкой.
  ///  - emojiMenuPrimaryAction: Активировать меню
  ///  - cellMenu: Меню, отображаемое кнопкой.
  ///  - emojiMenuPrimaryAction: Активировать меню
  ///  - emojiAction: Действие по нажатию на смайл
  ///  - contentAction: Действие по нажатию на контент
  @available(iOS 13.0, *)
  public func configureCellWith(avatar: UIImage?,
                                namePlayer: String?,
                                namePlayerColor: UIColor = .fancy.darkAndLightTheme.primaryGray,
                                namePlayerFont: UIFont = fancyFont.primaryMedium18,
                                nameTeam: String?,
                                nameTeamColor: UIColor = .fancy.only.primaryBlue,
                                nameTeamFont: UIFont = fancyFont.primaryRegular16,
                                emoji: Character? = "⚪️",
                                emojiMenu: UIMenu? = nil,
                                emojiMenuPrimaryAction: Bool = false,
                                cellMenu: UIMenu? = nil,
                                cellMenuPrimaryAction: Bool = false,
                                emojiAction: (() -> Void)? = nil,
                                contentAction: (() -> Void)? = nil) {
    avatarImageView.image = avatar
    
    namePlayerLabel.text = namePlayer
    namePlayerLabel.textColor = namePlayerColor
    namePlayerLabel.font = namePlayerFont
    
    nameTeamLabel.text = nameTeam
    nameTeamLabel.textColor = nameTeamColor
    nameTeamLabel.font = nameTeamFont
    
    self.emojiAction = emojiAction
    self.contentAction = contentAction
    
    if let emoji = emoji {
      emojiButton.setTitle(String(emoji), for: .normal)
    }
    
    if #available(iOS 14.0, *) {
      emojiButton.menu = emojiMenu
      emojiButton.showsMenuAsPrimaryAction = emojiMenuPrimaryAction
      
      cellButton.menu = cellMenu
      cellButton.showsMenuAsPrimaryAction = cellMenuPrimaryAction
    }
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero

    if #available(iOS 14.0, *) {
      emojiButton.menu = nil
      emojiButton.showsMenuAsPrimaryAction = false

      cellButton.menu = nil
      cellButton.showsMenuAsPrimaryAction = false
    }
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [namePlayerLabel, nameTeamLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      stackView.addArrangedSubview($0)
    }
    
    [avatarImageView, stackView, cellButton, emojiButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      avatarImageView.widthAnchor.constraint(equalToConstant: appearance.avatarImageSize.width),
      avatarImageView.heightAnchor.constraint(equalToConstant: appearance.avatarImageSize.height),
      
      avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: appearance.insets.left),
      avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: appearance.insets.top),
      avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -appearance.insets.bottom),
      
      stackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor,
                                         constant: appearance.insets.left),
      stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      cellButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      cellButton.topAnchor.constraint(equalTo: contentView.topAnchor),
      cellButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      cellButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      
      emojiButton.leadingAnchor.constraint(greaterThanOrEqualTo: stackView.trailingAnchor,
                                           constant: appearance.insets.left),
      emojiButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      emojiButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                            constant: -appearance.insets.right)
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    avatarImageView.contentMode = .scaleAspectFit
    
    namePlayerLabel.font = fancyFont.primaryMedium18
    namePlayerLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    namePlayerLabel.numberOfLines = appearance.numberOfLines
    namePlayerLabel.textAlignment = .left
    
    nameTeamLabel.font = fancyFont.primaryRegular16
    nameTeamLabel.textColor = .fancy.only.primaryBlue
    nameTeamLabel.numberOfLines = appearance.numberOfLines
    nameTeamLabel.textAlignment = .left
    
    emojiButton.titleLabel?.font = fancyFont.primaryMedium18
    emojiButton.setContentHuggingPriority(.required, for: .horizontal)
    
    stackView.axis = .vertical
    stackView.spacing = appearance.stackViewSpacing
    stackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    emojiButton.addTarget(self, action: #selector(emojiLabelAction), for: .touchUpInside)
    cellButton.addTarget(self, action: #selector(contentViewAction), for: .touchUpInside)
  }
  
  @objc
  private func emojiLabelAction() {
    guard emojiAction != nil else {
      return
    }
    
    emojiAction?()
    impactFeedback.impactOccurred()
  }
  
  @objc
  private func contentViewAction() {
    guard contentAction != nil else {
      return
    }
    
    contentAction?()
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension PlayerInfoTableViewCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    let avatarImageSize = CGSize(width: 60, height: 60)
    let numberOfLines = 1
    let stackViewSpacing: CGFloat = 4
  }
}

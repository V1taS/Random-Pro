//
//  ListPlayersScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из View в Presenter
protocol ListPlayersScreenViewOutput: AnyObject {
  
  /// Было добавлено имя игрока
  ///  - Parameter name: Имя игрока
  func playerAdded(name: String?)
  
  /// Игрок был удален
  ///  - Parameter id: Уникальный номер игрока
  func playerRemoved(id: String)
  
  /// Обновить реакцию у игрока
  /// - Parameters:
  ///  - emoji: Реакция
  ///  - id: Уникальный номер игрока
  func updatePlayer(emoji: String, id: String)
  
  /// Обновить статус у игрока
  /// - Parameters:
  ///  - state: Статус игрока
  ///  - id: Уникальный номер игрока
  func updatePlayer(state: TeamsScreenPlayerModel.PlayerState, id: String)
  
  /// Пол игрока был изменен
  /// - Parameter index: Индекс пола игрока
  func genderValueChanged(_ index: Int)
}

/// События которые отправляем от Presenter ко View
protocol ListPlayersScreenViewInput {
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [ListPlayersScreenType])
}

/// Псевдоним протокола UIView & ListPlayersScreenViewInput
typealias ListPlayersScreenViewProtocol = UIView & ListPlayersScreenViewInput

/// View для экрана
final class ListPlayersScreenView: ListPlayersScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: ListPlayersScreenViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
  private let textField = TextFieldView()
  private var models: [ListPlayersScreenType] = []
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func updateContentWith(models: [ListPlayersScreenType]) {
    self.models = models
    tableView.reloadData()
  }
}

// MARK: - UITableViewDelegate

extension ListPlayersScreenView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let appearance = Appearance()
    let deleteAction = UIContextualAction(style: .destructive,
                                          title: appearance.deleteTitle) { [weak self] _, _, _ in
      guard let self = self else {
        return
      }
      
      let model = self.models[indexPath.row]
      switch model {
      case .player(player: let player, _):
        self.output?.playerRemoved(id: player.id)
      default:
        break
      }
    }
    deleteAction.image = appearance.deleteImage
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    let model = models[indexPath.row]
    switch model {
    case .player:
      return true
    default:
      return false
    }
  }
}

// MARK: - UITableViewDataSource

extension ListPlayersScreenView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    var viewCell = UITableViewCell()
    let appearance = Appearance()
    
    switch model {
    case let .player(playerModel, teamsCount):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: PlayerInfoTableViewCell.reuseIdentifier
      ) as? PlayerInfoTableViewCell {
        var statePlayer: String? = playerModel.state.localizedName
        if playerModel.state == .random {
          statePlayer = nil
        }
        
        cell.configureCellWith(
          avatar: UIImage(named: playerModel.avatar),
          namePlayer: playerModel.name,
          nameTeam: statePlayer,
          emoji: Character(playerModel.emoji ?? "⚪️"),
          emojiMenu: emojiMenuAction(id: playerModel.id),
          emojiMenuPrimaryAction: true,
          cellMenu: contentMenuAction(teamsCount: teamsCount, id: playerModel.id),
          cellMenuPrimaryAction: true
        )
        viewCell = cell
      }
    case let .insets(inset):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomPaddingCell.reuseIdentifier
      ) as? CustomPaddingCell {
        cell.configureCellWith(height: CGFloat(inset))
        cell.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
        cell.contentView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
        viewCell = cell
      }
    case .textField:
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: TextFieldWithButtonCell.reuseIdentifier
      ) as? TextFielAddPlayerCell {
        let checkmarkImage = UIImage(systemName: Appearance().checkmarkImageName,
                                     withConfiguration: Appearance().largeConfig)
        cell.configureCellWith(
          textField: textField,
          textFieldBorderColor: fancyColor.darkAndLightTheme.secondaryGray,
          buttonImage: checkmarkImage,
          listGender: [appearance.male, appearance.female],
          buttonAction: { [weak self] in
            guard let self = self else {
              return
            }
            self.output?.playerAdded(name: self.textField.text)
            self.textField.text = ""
          },
          genderValueChanged: { [weak self] selectedGenderIndex in
            guard let self = self else {
              return
            }
            
            self.output?.genderValueChanged(selectedGenderIndex)
          }
        )
        viewCell = cell
      }
    case .divider:
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: DividerTableViewCell.reuseIdentifier
      ) as? DividerTableViewCell {
        viewCell = cell
      }
    case let .doubleTitle(playersCount, forGameCount):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: DoubleTitleCell.reuseIdentifier
      ) as? DoubleTitleCell {
        cell.configureCellWith(
          primaryText: "\(appearance.allTitle): \(playersCount)",
          primaryTextColor: fancyColor.darkAndLightTheme.primaryGray,
          primaryTextFont: RandomFont.primaryMedium10,
          secondaryText: "\(appearance.forGameTitle): \(forGameCount)",
          secondaryTextColor: fancyColor.darkAndLightTheme.primaryGray,
          secondaryTextFont: RandomFont.primaryMedium10
        )
        viewCell = cell
      }
    }
    return viewCell
  }
}

// MARK: - UITextFieldDelegate

extension ListPlayersScreenView: UITextFieldDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch models[indexPath.row] {
    case .insets(let inset):
      return CGFloat(inset)
    default:
      return UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text else {
      return true
    }
    
    if !text.isEmpty {
      output?.playerAdded(name: textField.text)
      textField.text = ""
    }
    return false
  }
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let appearance = Appearance()
    if range.location >= appearance.maxCharactersTF {
      return false
    }
    return true
  }
}

// MARK: - Private

private extension ListPlayersScreenView {
  func contentMenuAction(teamsCount: Int, id: String) -> UIMenu {
    let appearance = Appearance()
    var menuItems: [UIAction] = []
    
    menuItems.append(UIAction(
      title: TeamsScreenPlayerModel.PlayerState.random.localizedName,
      image: appearance.contentMenuRandomImage, handler: { [weak self] _ in
        self?.output?.updatePlayer(state: .random, id: id)
      }
    ))
    
    if teamsCount >= appearance.contentMenuTeamOne {
      menuItems.append(UIAction(
        title: TeamsScreenPlayerModel.PlayerState.teamOne.localizedName,
        image: appearance.contentMenuTeamOneImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(state: .teamOne, id: id)
        }
      ))
    }
    
    if teamsCount >= appearance.contentMenuTeamTwo {
      menuItems.append(UIAction(
        title: TeamsScreenPlayerModel.PlayerState.teamTwo.localizedName,
        image: appearance.contentMenuTeamTwoImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(state: .teamTwo, id: id)
        }
      ))
    }
    
    if teamsCount >= appearance.contentMenuTeamThree {
      menuItems.append(UIAction(
        title: TeamsScreenPlayerModel.PlayerState.teamThree.localizedName,
        image: appearance.contentMenuTeamThreeImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(state: .teamThree, id: id)
        }
      ))
    }
    
    if teamsCount >= appearance.contentMenuTeamFour {
      menuItems.append(UIAction(
        title: TeamsScreenPlayerModel.PlayerState.teamFour.localizedName,
        image: appearance.contentMenuTeamFourImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(state: .teamFour, id: id)
        }
      ))
    }
    
    if teamsCount >= appearance.contentMenuTeamFive {
      menuItems.append(UIAction(
        title: TeamsScreenPlayerModel.PlayerState.teamFive.localizedName,
        image: appearance.contentMenuTeamFiveImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(state: .teamFive, id: id)
        }
      ))
    }
    
    if teamsCount >= appearance.contentMenuTeamSix {
      menuItems.append(UIAction(
        title: TeamsScreenPlayerModel.PlayerState.teamSix.localizedName,
        image: appearance.contentMenuTeamSixImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(state: .teamSix, id: id)
        }
      ))
    }
    
    menuItems.append(UIAction(
      title: TeamsScreenPlayerModel.PlayerState.doesNotPlay.localizedName,
      image: appearance.contentMenuDoesNotPlayImage,
      attributes: .destructive,
      handler: { [weak self] _ in
        self?.output?.updatePlayer(state: .doesNotPlay, id: id)
      }
    ))
    return UIMenu(title: appearance.contentMenuStatePlayer,
                  image: nil,
                  identifier: nil,
                  options: [],
                  children: menuItems)
  }
  
  func emojiMenuAction(id: String) -> UIMenu {
    let appearance = Appearance()
    let menuItems: [UIAction] = [
      UIAction(
        title: appearance.emojiMenuFlameTitle,
        image: appearance.emojiMenuFlameImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(emoji: "🔥", id: id)
        }
      ),
      UIAction(
        title: appearance.emojiMenuStarTitle,
        image: appearance.emojiMenuStarImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(emoji: "⭐️", id: id)
        }
      ),
      UIAction(
        title: appearance.emojiMenuBallTitle,
        image: appearance.emojiMenuBallImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(emoji: "⚽️", id: id)
        }
      ),
      UIAction(
        title: appearance.emojiMenuTshirtTitle,
        image: appearance.emojiMenuTshirtImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(emoji: "👕", id: id)
        }
      ),
      UIAction(
        title: appearance.emojiMenuRedTitle,
        image: appearance.emojiMenuRedImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(emoji: "🔴", id: id)
        }
      ),
      UIAction(
        title: appearance.emojiMenuGreenTitle,
        image: appearance.emojiMenuGreenImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(emoji: "🟢", id: id)
        }
      ),
      UIAction(
        title: appearance.emojiMenuPillsTitle,
        image: appearance.emojiMenuPillsImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(emoji: "💊", id: id)
        }
      ),
      UIAction(
        title: appearance.emojiMenuAirplaneTitle,
        image: appearance.emojiMenuAirplaneImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(emoji: "🛩", id: id)
        }
      ),
      UIAction(
        title: appearance.emojiMenuMoneyTitle,
        image: appearance.emojiMenuMoneyImage, handler: { [weak self] _ in
          self?.output?.updatePlayer(emoji: "🤑", id: id)
        }
      ),
      UIAction(
        title: appearance.emojiMenuReactionTitle,
        image: appearance.emojiMenuReactionImage,
        attributes: .destructive,
        handler: { [weak self] _ in
          self?.output?.updatePlayer(emoji: "⚪️", id: id)
        }
      )
    ]
    return UIMenu(title: appearance.emojiMenuTitle,
                  image: nil,
                  identifier: nil,
                  options: [],
                  children: menuItems)
  }
  
  func configureLayout() {
    [tableView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    tableView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    textField.layer.borderColor = fancyColor.darkAndLightTheme.secondaryGray.cgColor
    
    textField.placeholder = appearance.textFieldPlaceholder
    textField.delegate = self
    textField.returnKeyType = .done
    textField.autocapitalizationType = .words
    
    tableView.keyboardDismissMode = .onDrag
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(PlayerInfoTableViewCell.self,
                       forCellReuseIdentifier: PlayerInfoTableViewCell.reuseIdentifier)
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(TextFielAddPlayerCell.self,
                       forCellReuseIdentifier: TextFieldWithButtonCell.reuseIdentifier)
    tableView.register(DividerTableViewCell.self,
                       forCellReuseIdentifier: DividerTableViewCell.reuseIdentifier)
    tableView.register(DoubleTitleCell.self,
                       forCellReuseIdentifier: DoubleTitleCell.reuseIdentifier)
    
    tableView.showsVerticalScrollIndicator = false
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }
}

// MARK: - Appearance

private extension ListPlayersScreenView {
  struct Appearance {
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 20,
                                                  weight: .bold,
                                                  scale: .large)
    let checkmarkImageName = "checkmark.circle.fill"
    let deleteImage = UIImage(systemName: "trash")
    let allTitle = RandomStrings.Localizable.total
    let forGameTitle = RandomStrings.Localizable.onGame
    let deleteTitle = RandomStrings.Localizable.remove
    let textFieldPlaceholder = RandomStrings.Localizable.playerName
    let maxCharactersTF = 20
    let estimatedRowHeight: CGFloat = 70
    
    // Content menu
    
    let contentMenuRandomImage = UIImage(systemName: "die.face.5")
    let contentMenuDoesNotPlayImage = UIImage(systemName: "xmark.circle.fill")
    let contentMenuStatePlayer = RandomStrings.Localizable.statusOfPlayer
    
    let contentMenuTeamOne = 1
    let contentMenuTeamOneImage = UIImage(systemName: "1.square")
    
    let contentMenuTeamTwo = 2
    let contentMenuTeamTwoImage = UIImage(systemName: "2.square")
    
    let contentMenuTeamThree = 3
    let contentMenuTeamThreeImage = UIImage(systemName: "3.square")
    
    let contentMenuTeamFour = 4
    let contentMenuTeamFourImage = UIImage(systemName: "4.square")
    
    let contentMenuTeamFive = 5
    let contentMenuTeamFiveImage = UIImage(systemName: "5.square")
    
    let contentMenuTeamSix = 6
    let contentMenuTeamSixImage = UIImage(systemName: "6.square")
    
    // Emoji menu
    
    let emojiMenuTitle = RandomStrings.Localizable.reactions
    
    let emojiMenuFlameTitle = RandomStrings.Localizable.fire
    let emojiMenuFlameImage = UIImage(systemName: "flame")
    
    let emojiMenuStarTitle = RandomStrings.Localizable.star
    let emojiMenuStarImage = UIImage(systemName: "star")
    
    let emojiMenuBallTitle = RandomStrings.Localizable.ball
    let emojiMenuBallImage = UIImage(systemName: "circle.dashed.inset.filled")
    
    let emojiMenuTshirtTitle = RandomStrings.Localizable.shape
    let emojiMenuTshirtImage = UIImage(systemName: "tshirt")
    
    let emojiMenuRedTitle = RandomStrings.Localizable.red
    let emojiMenuRedImage = UIImage(systemName: "eyedropper")
    
    let emojiMenuGreenTitle = RandomStrings.Localizable.green
    let emojiMenuGreenImage = UIImage(systemName: "eyedropper")
    
    let emojiMenuPillsTitle = RandomStrings.Localizable.tablet
    let emojiMenuPillsImage = UIImage(systemName: "pills")
    
    let emojiMenuAirplaneTitle = RandomStrings.Localizable.plane
    let emojiMenuAirplaneImage = UIImage(systemName: "airplane.departure")
    
    let emojiMenuMoneyTitle = RandomStrings.Localizable.money
    let emojiMenuMoneyImage = UIImage(systemName: "dollarsign.circle")
    
    let emojiMenuReactionTitle = RandomStrings.Localizable.removeReaction
    let emojiMenuReactionImage = UIImage(systemName: "trash")
    
    let male = RandomStrings.Localizable.m
    let female = RandomStrings.Localizable.f
  }
}

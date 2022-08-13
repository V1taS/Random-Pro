//
//  ListPlayersScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol ListPlayersScreenViewOutput: AnyObject {
  
  /// Было добавлено имя игрока
  func addedPlayer(neme: String?)
}

/// События которые отправляем от Presenter ко View
protocol ListPlayersScreenViewInput: AnyObject {
  
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
  
  private let tableView = UITableView()
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
  
  // MARK: - Private func
  
  private func configureLayout() {
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
  
  private func applyDefaultBehavior() {
    backgroundColor = RandomColor.primaryWhite
    tableView.backgroundColor = RandomColor.primaryWhite
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(PlayerInfoTableViewCell.self,
                       forCellReuseIdentifier: PlayerInfoTableViewCell.reuseIdentifier)
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(TextFieldWithButtonCell.self,
                       forCellReuseIdentifier: TextFieldWithButtonCell.reuseIdentifier)
    
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.contentInset.top = Appearance().inset.top
    tableView.showsVerticalScrollIndicator = false
  }
}

// MARK: - UITableViewDelegate

extension ListPlayersScreenView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

// MARK: - UITableViewDataSource

extension ListPlayersScreenView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    var viewCell = UITableViewCell()
    viewCell.isHiddenSeparator = false
    
    switch model {
    case .player(let playerModel):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: PlayerInfoTableViewCell.reuseIdentifier
      ) as? PlayerInfoTableViewCell {
        cell.configureCellWith(
          avatar: UIImage(data: playerModel.avatar ?? Data()),
          namePlayer: playerModel.name,
          nameTeam: playerModel.state.rawValue,
          emoji: Character(playerModel.emoji ?? ""),
          emojiAction: {
            // TODO: - to do
          },
          contentAction: {
            // TODO: - to do
          }
        )
        viewCell = cell
      }
    case .insets(let inset):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomPaddingCell.reuseIdentifier
      ) as? CustomPaddingCell {
        cell.configureCellWith(height: CGFloat(inset))
        viewCell = cell
      }
    case .textField(let placeholder):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: TextFieldWithButtonCell.reuseIdentifier
      ) as? TextFieldWithButtonCell {
        let textField = TextFieldView()
        textField.placeholder = placeholder
        textField.delegate = self
        
        cell.configureCellWith(
          textField: textField,
          buttonImageSystemName: Appearance().buttonImageSystemName,
          buttonAction: { [weak self] in
            guard let self = self else {
              return
            }
            self.output?.addedPlayer(neme: textField.text)
          }
        )
        viewCell = cell
      }
    }
    
    if tableView.isFirst(for: indexPath) {
      viewCell.layer.cornerRadius = Appearance().cornerRadius
      viewCell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    if tableView.isLast(for: indexPath) {
      viewCell.isHiddenSeparator = true
      viewCell.layer.cornerRadius = Appearance().cornerRadius
      viewCell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    return viewCell
  }
}

// MARK: - UITextFieldDelegate

extension ListPlayersScreenView: UITextFieldDelegate {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    if range.location >= 20 {
      return false
    }
    return true
  }
}

// MARK: - Appearance

private extension ListPlayersScreenView {
  struct Appearance {
    let inset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    let cornerRadius: CGFloat = 8
    let buttonImageSystemName = "checkmark.circle.fill"
  }
}

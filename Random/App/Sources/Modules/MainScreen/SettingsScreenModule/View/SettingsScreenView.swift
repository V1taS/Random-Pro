//
//  SettingsScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol SettingsScreenViewOutput: AnyObject {
  
  /// Событие, без повторений
  /// - Parameter isOn: Без повторений `true` или `false`
  func withoutRepetitionAction(isOn: Bool)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Событие, кнопка `Список объектов` была нажата
  func listOfObjectsAction()
  
  /// Событие, кнопка `Создать список` была нажата
  func createListAction()
  
  /// Событие, кнопка `Выбора карточки игрока` была нажата
  func playerCardSelectionAction()
}

/// События которые отправляем от Presenter ко View
protocol SettingsScreenViewInput {
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [SettingsScreenTableViewType])
}

/// Псевдоним протокола UIView & SettingsScreenViewInput
typealias SettingsScreenViewProtocol = UIView & SettingsScreenViewInput

/// View для экрана
final class SettingsScreenView: SettingsScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: SettingsScreenViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
  private var models: [SettingsScreenTableViewType] = []
  
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
  
  func updateContentWith(models: [SettingsScreenTableViewType]) {
    self.models = models
    tableView.reloadData()
  }
}

// MARK: - UITableViewDelegate

extension SettingsScreenView: UITableViewDelegate {
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch models[indexPath.row] {
    case let .titleAndChevron(_, actionId):
      switch actionId {
      case .listOfObjects:
        output?.listOfObjectsAction()
      case .createList:
        output?.createListAction()
      case .playerCardSelection:
        output?.playerCardSelectionAction()
      }
    default: break
    }
  }
}

// MARK: - UITableViewDataSource

extension SettingsScreenView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    var viewCell = UITableViewCell()
    
    switch model {
    case let .titleAndSwitcher(title, isEnabled):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: LabelAndSwitchCell.reuseIdentifier
      ) as? LabelAndSwitchCell {
        cell.configureCellWith(titleText: title,
                               isResultSwitch: isEnabled)
        cell.switchAction = { [weak self] isOn in
          self?.output?.withoutRepetitionAction(isOn: isOn)
        }
        viewCell = cell
      }
    case let .titleAndDescription(title, description):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: DoubleTitleCell.reuseIdentifier
      ) as? DoubleTitleCell {
        cell.configureCellWith(primaryText: title,
                               secondaryText: description)
        viewCell = cell
      }
    case let .titleAndChevron(title, _):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: LabelAndChevronCell.reuseIdentifier
      ) as? LabelAndChevronCell {
        cell.configureCellWith(titleText: title)
        viewCell = cell
      }
    case let .cleanButtonModel(title):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: SmallButtonCell.reuseIdentifier
      ) as? SmallButtonCell {
        cell.action = { [weak self] in
          self?.output?.cleanButtonAction()
        }
        cell.configureCellWith(titleButton: title)
        viewCell = cell
      }
    case let .insets(inset):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomPaddingCell.reuseIdentifier
      ) as? CustomPaddingCell {
        cell.configureCellWith(height: CGFloat(inset))
        cell.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
        cell.contentView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
        viewCell = cell
      }
    case .divider:
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: DividerTableViewCell.reuseIdentifier
      ) as? DividerTableViewCell {
        viewCell = cell
      }
    case let .labelWithSegmentedControl(title, listOfItems, startSelectedSegmentIndex, valueChanged):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: LabelWithSegmentedControlCell.reuseIdentifier
      ) as? LabelWithSegmentedControlCell {
        cell.configureCellWith(
          titleText: title,
          startSelectedSegmentIndex: startSelectedSegmentIndex,
          listOfItemsInSegmentedControl: listOfItems,
          segmentControlValueChanged: { index in
            valueChanged?(index)
          }
        )
        viewCell = cell
      }
    case let .titleAndSwitcherAction(title, value):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: LabelAndSwitchCell.reuseIdentifier
      ) as? LabelAndSwitchCell {
        cell.configureCellWith(titleText: title,
                               isResultSwitch: value.isEnabled)
        cell.switchAction = { isOn in
          value.completion?(isOn)
        }
        viewCell = cell
      }
    }
    
    if tableView.isFirst(for: indexPath) {
      viewCell.layer.cornerRadius = Appearance().cornerRadius
      viewCell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      viewCell.clipsToBounds = true
    }
    
    if tableView.isLast(for: indexPath) {
      viewCell.isHiddenSeparator = true
      viewCell.layer.cornerRadius = Appearance().cornerRadius
      viewCell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
      viewCell.clipsToBounds = true
    }
    return viewCell
  }
}

// MARK: - Private

private extension SettingsScreenView {
  func configureLayout() {
    let appearance = Appearance()
    [tableView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.defaultInset),
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.defaultInset),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    tableView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(LabelAndSwitchCell.self,
                       forCellReuseIdentifier: LabelAndSwitchCell.reuseIdentifier)
    tableView.register(DoubleTitleCell.self,
                       forCellReuseIdentifier: DoubleTitleCell.reuseIdentifier)
    tableView.register(LabelAndChevronCell.self,
                       forCellReuseIdentifier: LabelAndChevronCell.reuseIdentifier)
    tableView.register(SmallButtonCell.self,
                       forCellReuseIdentifier: SmallButtonCell.reuseIdentifier)
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(DividerTableViewCell.self,
                       forCellReuseIdentifier: DividerTableViewCell.reuseIdentifier)
    tableView.register(LabelWithSegmentedControlCell.self,
                       forCellReuseIdentifier: LabelWithSegmentedControlCell.reuseIdentifier)
    
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.contentInset.top = Appearance().defaultInset
  }
}

// MARK: - Appearance

private extension SettingsScreenView {
  struct Appearance {
    let defaultInset: CGFloat = 16
    let cornerRadius: CGFloat = 8
  }
}

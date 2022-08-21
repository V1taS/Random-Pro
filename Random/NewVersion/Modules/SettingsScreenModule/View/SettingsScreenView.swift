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
  
  /// Событие, кнопка `Список чисел` была нажата
  func listOfObjectsAction()
}

/// События которые отправляем от Presenter ко View
protocol SettingsScreenViewInput: AnyObject {
  
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
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    [tableView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.inset.left),
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.inset.right),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = RandomColor.secondaryWhite
    tableView.backgroundColor = RandomColor.secondaryWhite
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(LabelAndSwitchCell.self,
                       forCellReuseIdentifier: LabelAndSwitchCell.reuseIdentifier)
    tableView.register(DoubleTitleCell.self,
                       forCellReuseIdentifier: DoubleTitleCell.reuseIdentifier)
    tableView.register(LabelAndImageCell.self,
                       forCellReuseIdentifier: LabelAndImageCell.reuseIdentifier)
    tableView.register(SmallButtonCell.self,
                       forCellReuseIdentifier: SmallButtonCell.reuseIdentifier)
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(DividerTableViewCell.self,
                       forCellReuseIdentifier: DividerTableViewCell.reuseIdentifier)
    
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.contentInset.top = Appearance().inset.top
  }
}

// MARK: - UITableViewDelegate

extension SettingsScreenView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch models[indexPath.row] {
    case .titleAndImage:
      output?.listOfObjectsAction()
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
    case .titleAndSwitcher(title: let title, isEnabled: let isEnabled):
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
    case .titleAndDescription(title: let title, description: let description):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: DoubleTitleCell.reuseIdentifier
      ) as? DoubleTitleCell {
        cell.configureCellWith(primaryText: title,
                               secondaryText: description)
        viewCell = cell
      }
    case .titleAndImage(title: let title, asideImage: let asideImage):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: LabelAndImageCell.reuseIdentifier
      ) as? LabelAndImageCell {
        cell.configureCellWith(titleText: title,
                               imageAside: UIImage(data: asideImage ?? Data()))
        viewCell = cell
      }
    case .cleanButtonModel(title: let title):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: SmallButtonCell.reuseIdentifier
      ) as? SmallButtonCell {
        cell.action = { [weak self] in
          self?.output?.cleanButtonAction()
        }
        cell.configureCellWith(titleButton: title)
        viewCell = cell
      }
    case .insets(let inset):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomPaddingCell.reuseIdentifier
      ) as? CustomPaddingCell {
        cell.configureCellWith(height: CGFloat(inset))
        cell.backgroundColor = RandomColor.primaryWhite
        cell.contentView.backgroundColor = RandomColor.primaryWhite
        viewCell = cell
      }
    case .divider:
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: DividerTableViewCell.reuseIdentifier
      ) as? DividerTableViewCell {
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

// MARK: - Appearance

private extension SettingsScreenView {
  struct Appearance {
    let inset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    let cornerRadius: CGFloat = 8
  }
}

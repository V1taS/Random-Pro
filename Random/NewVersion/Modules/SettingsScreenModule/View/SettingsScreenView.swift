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
  func listOfNumbersAction()
}

/// События которые отправляем от Presenter ко View
protocol SettingsScreenViewInput: AnyObject {
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWitch(models: [SettingsScreenCell])
}

/// Псевдоним протокола UIView & SettingsScreenViewInput
typealias SettingsScreenViewProtocol = UIView & SettingsScreenViewInput

/// View для экрана
final class SettingsScreenView: SettingsScreenViewProtocol {
  
  // MARK: - Public properties
  
  // MARK: - Internal properties
  
  weak var output: SettingsScreenViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = UITableView()
  private var models: [SettingsScreenCell] = []
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public func
  
  // MARK: - Internal func
  
  func updateContentWitch(models: [SettingsScreenCell]) {
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
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = RandomColor.primaryWhite
    tableView.backgroundColor = RandomColor.primaryWhite
    
    // Сами self(SettingsScreenView) получает события от tableView
    tableView.delegate = self
    
    // Сами self(SettingsScreenView) устанавливаем данные для отображения в tableView
    tableView.dataSource = self
    
    // Зарегистрировали ячейку в табличке
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
    
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.contentInset.top = 16
  }
}

// MARK: - UITableViewDelegate

extension SettingsScreenView: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model = models[indexPath.row]
    
    switch model {
    case .listOfNumbers:
      output?.listOfNumbersAction()
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
    
    switch model {
    case .withoutRepetition(let result):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: LabelAndSwitchCell.reuseIdentifier
      ) as! LabelAndSwitchCell
      
      cell.configureCellWith(titleText: result?.title,
                             isResultSwitch: result?.isOn ?? false)
      cell.switchAction = { [weak self] isOn in
        self?.output?.withoutRepetitionAction(isOn: isOn)
      }
      cell.layer.cornerRadius = 8
      cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      return cell
    case .numbersGenerated(let result):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: DoubleTitleCell.reuseIdentifier
      ) as! DoubleTitleCell
      
      cell.configureCellWith(primaryText: result?.primaryText,
                             secondaryText: result?.secondaryText)
      return cell
    case .lastNumber(let result):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: DoubleTitleCell.reuseIdentifier
      ) as! DoubleTitleCell
      
      cell.configureCellWith(primaryText: result?.primaryText,
                             secondaryText: result?.secondaryText)
      return cell
    case .listOfNumbers(let result):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: LabelAndImageCell.reuseIdentifier
      ) as! LabelAndImageCell
      
      cell.configureCellWith(titleText: result?.title,
                             imageAside: result?.asideImage)
      return cell
    case .cleanButton(let title):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: SmallButtonCell.reuseIdentifier
      ) as! SmallButtonCell
      
      cell.action = { [weak self] in
        self?.output?.cleanButtonAction()
      }
      cell.configureCellWith(titleButton: title)
      cell.isHiddenSeparator = true
      cell.layer.cornerRadius = 8
      cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
      return cell
    case .padding(let height):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomPaddingCell.reuseIdentifier
      ) as! CustomPaddingCell
      
      cell.configureCellWith(height: height)
      return cell
    }
  }
}

// MARK: - Appearance

private extension SettingsScreenView {
  struct Appearance {
    
  }
}

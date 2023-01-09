//
//  MainSettingsScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol MainSettingsScreenViewOutput: AnyObject {
  
  /// Тема приложения была изменена
  /// - Parameter isEnabled: Темная тема включена
  func darkThemeChanged(_ isEnabled: Bool)
  
  /// Выбран раздел настройки главного экрана
  func customMainSectionsSelected()
  
  /// Кнопка обратной связи была нажата
  func feedBackButtonAction()
}

/// События которые отправляем от Presenter ко View
protocol MainSettingsScreenViewInput {
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [MainSettingsScreenType])
}

/// Псевдоним протокола UIView & MainSettingsScreenViewInput
typealias MainSettingsScreenViewProtocol = UIView & MainSettingsScreenViewInput

/// View для экрана
final class MainSettingsScreenView: MainSettingsScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: MainSettingsScreenViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
  private var models: [MainSettingsScreenType] = []
  
  private let feedBackLabel = UILabel()
  private let feedBackButton = UIButton(type: .system)
  private let stackFeedBack = UIStackView()
  
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
  
  func updateContentWith(models: [MainSettingsScreenType]) {
    self.models = models
    tableView.reloadData()
  }
}

// MARK: - UITableViewDelegate

extension MainSettingsScreenView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch models[indexPath.row] {
    case .titleAndImage(_, _, let type):
      switch type {
      case .customMainSections:
        output?.customMainSectionsSelected()
      }
    default: break
    }
  }
}

// MARK: - UITableViewDataSource

extension MainSettingsScreenView: UITableViewDataSource {
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
          self?.output?.darkThemeChanged(isOn)
        }
        viewCell = cell
      }
    case let .titleAndImage(title, asideImage, _):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: LabelAndImageCell.reuseIdentifier
      ) as? LabelAndImageCell {
        cell.configureCellWith(titleText: title,
                               imageAside: UIImage(data: asideImage ?? Data()),
                               imageColor: RandomColor.primaryGray)
        viewCell = cell
      }
    case let .insets(inset):
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

// MARK: - Private

private extension MainSettingsScreenView {
  func configureLayout() {
    let appearance = Appearance()
    [feedBackLabel, feedBackButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      stackFeedBack.addArrangedSubview($0)
    }
    
    [tableView, stackFeedBack].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: stackFeedBack.topAnchor,
                                        constant: -appearance.insets.bottom),
      
      stackFeedBack.leadingAnchor.constraint(equalTo: leadingAnchor,
                                             constant: appearance.insets.left),
      stackFeedBack.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -appearance.insets.right),
      stackFeedBack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                            constant: -appearance.insets.bottom)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    
    backgroundColor = RandomColor.primaryWhite
    tableView.backgroundColor = RandomColor.primaryWhite
    
    stackFeedBack.axis = .vertical
    stackFeedBack.alignment = .center
    stackFeedBack.spacing = appearance.minInset
    
    feedBackLabel.textColor = RandomColor.primaryGray
    feedBackLabel.font = RandomFont.primaryRegular16
    feedBackLabel.text = "\(appearance.feedbackButtonTitle):"
    
    feedBackButton.setTitle(appearance.addressRecipients, for: .normal)
    feedBackButton.setTitleColor(RandomColor.primaryBlue, for: .normal)
    feedBackButton.titleLabel?.font = RandomFont.primaryRegular16
    feedBackButton.addTarget(self,
                             action: #selector(feedBackButtonAction),
                             for: .touchUpInside)
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = appearance.estimatedRowHeight
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(LabelAndSwitchCell.self,
                       forCellReuseIdentifier: LabelAndSwitchCell.reuseIdentifier)
    tableView.register(LabelAndImageCell.self,
                       forCellReuseIdentifier: LabelAndImageCell.reuseIdentifier)
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(DividerTableViewCell.self,
                       forCellReuseIdentifier: DividerTableViewCell.reuseIdentifier)
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.showsVerticalScrollIndicator = false
  }
  
  @objc
  func feedBackButtonAction() {
    output?.feedBackButtonAction()
  }
}

// MARK: - Appearance

private extension MainSettingsScreenView {
  struct Appearance {
    let estimatedRowHeight: CGFloat = 70
    let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    let cornerRadius: CGFloat = 8
    let minInset: CGFloat = 4
    
    let feedbackButtonTitle = NSLocalizedString("Обратная связь", comment: "")
    let addressRecipients = "Random_Pro_support@iCloud.com"
  }
}

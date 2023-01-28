//
//  SelecteAppIconScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol SelecteAppIconScreenViewOutput: AnyObject {
  
  /// Было выбрано изображение
  /// - Parameter type: Тип изображения
  func didSelectImage(type: SelecteAppIconType)
  
  /// Нет премиум доступа
  func noPremiumAccessAction()
}

/// События которые отправляем от Presenter ко View
protocol SelecteAppIconScreenViewInput {
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [SelecteAppIconScreenType])
}

/// Псевдоним протокола UIView & SelecteAppIconScreenViewInput
typealias SelecteAppIconScreenViewProtocol = UIView & SelecteAppIconScreenViewInput

/// View для экрана
final class SelecteAppIconScreenView: SelecteAppIconScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: SelecteAppIconScreenViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
  private var models: [SelecteAppIconScreenType] = []
  
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
  
  func updateContentWith(models: [SelecteAppIconScreenType]) {
    self.models = models
    tableView.reloadData()
  }
}

// MARK: - Private

private extension SelecteAppIconScreenView {
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
    
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    tableView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = appearance.estimatedRowHeight
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(LargeImageAndLabelWithCheakmarkCell.self,
                       forCellReuseIdentifier: LargeImageAndLabelWithCheakmarkCell.reuseIdentifier)
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(DividerTableViewCell.self,
                       forCellReuseIdentifier: DividerTableViewCell.reuseIdentifier)
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.showsVerticalScrollIndicator = false
  }
}

// MARK: - UITableViewDelegate

extension SelecteAppIconScreenView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch models[indexPath.row] {
    case let .largeImageAndLabelWithCheakmark(_, _, _, isSetLocked, iconType):
      if isSetLocked {
        output?.noPremiumAccessAction()
      } else {
        output?.didSelectImage(type: iconType)
      }
    default: break
    }
  }
}

// MARK: - UITableViewDataSource

extension SelecteAppIconScreenView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    var viewCell = UITableViewCell()
    
    switch model {
    case let .largeImageAndLabelWithCheakmark(imageName, title, setIsCheakmark, isSetLocked, _):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: LargeImageAndLabelWithCheakmarkCell.reuseIdentifier
      ) as? LargeImageAndLabelWithCheakmarkCell {
        cell.configureCellWith(leftSideImage: UIImage(named: imageName),
                               titleText: title,
                               setIsCheckmark: setIsCheakmark,
                               setIsLocked: isSetLocked) { _ in }
        viewCell = cell
      }
    case let .insets(value):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomPaddingCell.reuseIdentifier
      ) as? CustomPaddingCell {
        cell.configureCellWith(height: CGFloat(value))
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
    }
    return viewCell
  }
}

// MARK: - Appearance

private extension SelecteAppIconScreenView {
  struct Appearance {
    let cornerRadius: CGFloat = 8
    let estimatedRowHeight: CGFloat = 70
  }
}

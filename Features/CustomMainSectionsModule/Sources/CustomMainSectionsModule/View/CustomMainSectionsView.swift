//
//  CustomMainSectionsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit
import RandomUIKit
import ApplicationInterface

/// События которые отправляем из View в Presenter
protocol CustomMainSectionsViewOutput: AnyObject {
  
  /// Секция была изменена
  /// - Parameters:
  ///  - isEnabled: Включена секция
  ///  - type: Тип секции
  func sectionChanged(_ isEnabled: Bool, type: MainScreenSectionProtocol)
  
  /// Секция была изменена
  /// - Parameters:
  ///  - index: Место по порядку
  ///  - type: Тип секции
  func sectionChanged(_ index: Int, type: MainScreenSectionProtocol)
}

/// События которые отправляем от Presenter ко View
protocol CustomMainSectionsViewInput {
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [MainScreenSectionProtocol])
}

/// Псевдоним протокола UIView & CustomMainSectionsViewInput
typealias CustomMainSectionsViewProtocol = UIView & CustomMainSectionsViewInput

/// View для экрана
final class CustomMainSectionsView: CustomMainSectionsViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: CustomMainSectionsViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
  private var models: [MainScreenSectionProtocol] = []
  
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
  
  func updateContentWith(models: [MainScreenSectionProtocol]) {
    self.models = models
    tableView.reloadData()
  }
}

// MARK: - UITableViewDelegate

extension CustomMainSectionsView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView,
                 editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .none
  }
  
  func tableView(_ tableView: UITableView,
                 shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  func tableView(_ tableView: UITableView,
                 moveRowAt sourceIndexPath: IndexPath,
                 to destinationIndexPath: IndexPath) {
    let model = models[sourceIndexPath.row]
    models.remove(at: sourceIndexPath.row)
    models.insert(model, at: destinationIndexPath.row)
    tableView.reloadData()
    output?.sectionChanged(destinationIndexPath.row, type: model)
  }
}

// MARK: - UITableViewDataSource

extension CustomMainSectionsView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    var viewCell = UITableViewCell()
    
    if let cell = tableView.dequeueReusableCell(
      withIdentifier: ImageAndLabelWithSwitchCell.reuseIdentifier
    ) as? ImageAndLabelWithSwitchCell {
      cell.configureCellWith(leftSideImage: UIImage(systemName: model.type.imageSectionSystemName),
                             titleText: model.type.titleSection,
                             isResultSwitch: model.isEnabled)
      cell.switchAction = { [weak self] isOn in
        self?.output?.sectionChanged(isOn,
                                     type: model)
      }
      viewCell = cell
    }
    
    if tableView.isLast(for: indexPath) {
      viewCell.isHiddenSeparator = true
    }
    return viewCell
  }
}

// MARK: - Private

private extension CustomMainSectionsView {
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
    tableView.separatorStyle = .singleLine
    tableView.delegate = self
    tableView.dataSource = self
    tableView.isEditing = true
    
    tableView.register(ImageAndLabelWithSwitchCell.self,
                       forCellReuseIdentifier: ImageAndLabelWithSwitchCell.reuseIdentifier)
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(DividerTableViewCell.self,
                       forCellReuseIdentifier: DividerTableViewCell.reuseIdentifier)
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.showsVerticalScrollIndicator = false
  }
}

// MARK: - Appearance

private extension CustomMainSectionsView {
  struct Appearance {
    let estimatedRowHeight: CGFloat = 70
  }
}

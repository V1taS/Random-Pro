//
//  FortuneWheelSelectedSectionView.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol FortuneWheelSelectedSectionViewOutput: AnyObject {
  
  /// Выбрана секция
  func sectionSelected(_ section: FortuneWheelModel.Section)
  
  /// Редактируем текущую секцию
  ///  - Parameters:
  ///   - section: Секция
  func editCurrentSectionWith(section: FortuneWheelModel.Section)
  
  /// Удалить секцию
  /// - Parameters:
  ///  - section: Секция
  func deleteSection(_ section: FortuneWheelModel.Section)
  
  /// Создать новую секцию
  func createNewSection()
}

/// События которые отправляем от Presenter ко View
protocol FortuneWheelSelectedSectionViewInput {
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [FortuneWheelSelectedSectionTableViewType])
  
  /// Обновить только секции
  ///  - Parameter models: Массив моделек
  func updateWheelSectionWith(models: [FortuneWheelSelectedSectionTableViewType])
}

/// Псевдоним протокола UIView & FortuneWheelSelectedSectionViewInput
typealias FortuneWheelSelectedSectionViewProtocol = UIView & FortuneWheelSelectedSectionViewInput

/// View для экрана
final class FortuneWheelSelectedSectionView: FortuneWheelSelectedSectionViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelSelectedSectionViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
  private var models: [FortuneWheelSelectedSectionTableViewType] = []
  private var caheIndexPathsToReload: Set<IndexPath> = []
  
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
  
  func updateContentWith(models: [FortuneWheelSelectedSectionTableViewType]) {
    self.models = models
    tableView.reloadData()
  }
  
  func updateWheelSectionWith(models: [FortuneWheelSelectedSectionTableViewType]) {
    self.models = models
    UIView.performWithoutAnimation {
      tableView.beginUpdates()
      tableView.reloadRows(at: Array(caheIndexPathsToReload), with: .none)
      tableView.endUpdates()
    }
  }
}

// MARK: - UITableViewDelegate

extension FortuneWheelSelectedSectionView: UITableViewDelegate {
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
  
  func tableView(_ tableView: UITableView,
                 trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let appearance = Appearance()
    let deleteAction = UIContextualAction(style: .destructive,
                                          title: appearance.deleteTitle) { [weak self] _, _, _ in
      guard let self = self else {
        return
      }
      
      let model = self.models[indexPath.row]
      switch model {
      case let .wheelSection(section):
        self.output?.deleteSection(section)
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
    case .wheelSection:
      return true
    default:
      return false
    }
  }
}

// MARK: - UITableViewDataSource

extension FortuneWheelSelectedSectionView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    var viewCell = UITableViewCell()
    let appearance = Appearance()
    
    switch model {
    case let .insets(inset):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomPaddingCell.reuseIdentifier
      ) as? CustomPaddingCell {
        cell.configureCellWith(height: CGFloat(inset))
        cell.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
        cell.contentView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
        viewCell = cell
      }
    case let .headerText(text):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomTextCell.reuseIdentifier
      ) as? CustomTextCell {
        cell.configureCellWith(
          titleText: text,
          textColor: RandomColor.darkAndLightTheme.secondaryGray,
          textFont: RandomFont.primaryMedium14,
          textAlignment: .left
        )
        viewCell = cell
      }
    case let .wheelSection(section):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: ImageAndLabelWithButtonBigGrayCell.reuseIdentifier
      ) as? ImageAndLabelWithButtonBigGrayCell {
        caheIndexPathsToReload.insert(indexPath)
        cell.configureCellWith(
          leftSideEmoji: Character(section.icon ?? " "),
          titleText: section.title,
          rightButtonImage: appearance.squareAndPencilImage,
          actionCell: { [weak self] in
            self?.output?.sectionSelected(section)
          },
          actionButton: { [weak self] in
            self?.output?.editCurrentSectionWith(section: section)
          }
        )
        cell.style = section.isSelected ? .selected : .none
        viewCell = cell
      }
    case .createNewSectionButton:
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: ButtonTableViewCell.reuseIdentifier
      ) as? ButtonTableViewCell {
        cell.configureCellWith { [weak self] buttonView in
          guard let self else {
            return
          }
          buttonView.setTitle(RandomStrings.Localizable.add, for: .normal)
          buttonView.addTarget(self,
                               action: #selector(self.createNewSectionAction),
                               for: .touchUpInside)
        }
        viewCell = cell
      }
    }
    return viewCell
  }
  
  @objc
  func createNewSectionAction() {
    output?.createNewSection()
  }
}

// MARK: - Private

private extension FortuneWheelSelectedSectionView {
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
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.contentInset.top = Appearance().defaultInset
    
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(ImageAndLabelWithButtonBigGrayCell.self,
                       forCellReuseIdentifier: ImageAndLabelWithButtonBigGrayCell.reuseIdentifier)
    tableView.register(CustomTextCell.self,
                       forCellReuseIdentifier: CustomTextCell.reuseIdentifier)
    tableView.register(ButtonTableViewCell.self,
                       forCellReuseIdentifier: ButtonTableViewCell.reuseIdentifier)
  }
}

// MARK: - Appearance

private extension FortuneWheelSelectedSectionView {
  struct Appearance {
    let defaultInset: CGFloat = 16
    let squareAndPencilImage = UIImage(systemName: "square.and.pencil")
    let deleteTitle = RandomStrings.Localizable.remove
    let deleteImage = UIImage(systemName: "trash")
  }
}

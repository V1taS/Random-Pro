//
//  ListAddItemsScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol ListAddItemsScreenViewOutput: AnyObject {
  
  /// Было добавлен текст
  ///  - Parameter text: Текст
  func textAdded(_ text: String?)
  
  /// Текст был удален
  ///  - Parameter id: Уникальный номер текста
  func textRemoved(id: String)
}

/// События которые отправляем от Presenter ко View
protocol ListAddItemsScreenViewInput: AnyObject {
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [ListAddItemsScreenModel])
}

/// Псевдоним протокола UIView & ListAddItemsScreenViewInput
typealias ListAddItemsScreenViewProtocol = UIView & ListAddItemsScreenViewInput

/// View для экрана
final class ListAddItemsScreenView: ListAddItemsScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: ListAddItemsScreenViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
  private let textField = TextFieldView()
  private var models: [ListAddItemsScreenModel] = []
  
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
  
  func updateContentWith(models: [ListAddItemsScreenModel]) {
    self.models = models
    tableView.reloadData()
  }
}

// MARK: - UITableViewDelegate

extension ListAddItemsScreenView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let appearance = Appearance()
    let deleteAction = UIContextualAction(style: .destructive,
                                          title: appearance.deleteTitle) { [weak self] _, _, _ in
      guard let self = self else {
        return
      }
      
      let model = self.models[indexPath.row]
      switch model {
      case .text(let result):
        self.output?.textRemoved(id: result.id)
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
    case .text:
      return true
    default:
      return false
    }
  }
}

// MARK: - UITableViewDataSource

extension ListAddItemsScreenView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    var viewCell = UITableViewCell()
    let appearance = Appearance()
    
    switch model {
    case .text(let result):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomTextCell.reuseIdentifier
      ) as? CustomTextCell {
        cell.configureCellWith(
          titleText: result.text,
          textColor: RandomColor.primaryGray,
          textFont: RandomFont.primaryMedium18,
          textAlignment: .left
        )
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
    case .textField:
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: TextFieldWithButtonCell.reuseIdentifier
      ) as? TextFieldWithButtonCell {
        let checkmarkImage = UIImage(systemName: Appearance().checkmarkImageName,
                                     withConfiguration: Appearance().largeConfig)
        cell.configureCellWith(
          textField: textField,
          buttonImage: checkmarkImage,
          buttonAction: { [weak self] in
            guard let self = self else {
              return
            }
            self.output?.textAdded(self.textField.text)
            self.textField.text = ""
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
    case .doubleTitle(let textCount, _):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: DoubleTitleCell.reuseIdentifier
      ) as? DoubleTitleCell {
        cell.configureCellWith(
          primaryText: "\(appearance.allTitle): \(textCount)",
          primaryTextColor: RandomColor.secondaryGray,
          primaryTextFont: RandomFont.primaryMedium10,
          secondaryText: nil,
          secondaryTextColor: RandomColor.secondaryGray,
          secondaryTextFont: RandomFont.primaryMedium10
        )
        viewCell = cell
      }
    }
    return viewCell
  }
}

// MARK: - UITextFieldDelegate

extension ListAddItemsScreenView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text else {
      return true
    }
    
    if !text.isEmpty {
      output?.textAdded(textField.text)
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

private extension ListAddItemsScreenView {
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
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    tableView.backgroundColor = RandomColor.primaryWhite
    
    textField.placeholder = appearance.textFieldPlaceholder
    textField.delegate = self
    textField.returnKeyType = .done
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = appearance.estimatedRowHeight
    tableView.keyboardDismissMode = .onDrag
    
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(CustomTextCell.self,
                       forCellReuseIdentifier: CustomTextCell.reuseIdentifier)
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(TextFieldWithButtonCell.self,
                       forCellReuseIdentifier: TextFieldWithButtonCell.reuseIdentifier)
    tableView.register(DividerTableViewCell.self,
                       forCellReuseIdentifier: DividerTableViewCell.reuseIdentifier)
    tableView.register(DoubleTitleCell.self,
                       forCellReuseIdentifier: DoubleTitleCell.reuseIdentifier)
    
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.showsVerticalScrollIndicator = false
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }
}

// MARK: - Appearance

private extension ListAddItemsScreenView {
  struct Appearance {
    let deleteTitle = NSLocalizedString("Удалить", comment: "")
    let deleteImage = UIImage(systemName: "trash")
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 20,
                                                  weight: .bold,
                                                  scale: .large)
    let checkmarkImageName = "checkmark.circle.fill"
    let allTitle = NSLocalizedString("Всего", comment: "")
    let textFieldPlaceholder = NSLocalizedString("Добавить", comment: "")
    let maxCharactersTF = 9_999
    let estimatedRowHeight: CGFloat = 44
  }
}

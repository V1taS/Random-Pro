//
//  FortuneWheelEditSectionView.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol FortuneWheelEditSectionViewOutput: AnyObject {
  
  /// Создать объект
  /// - Parameters:
  ///  - emoticon: Смайлик
  ///  - titleSection: Название секции
  ///  - textSection: Название объекта
  func createObject(_ emoticon: Character?,
                    _ titleSection: String?,
                    _ textObject: String?)
  
  /// Удалить объект
  /// - Parameters:
  ///  - object: Объект (текст)
  func deleteObject(_ object: String?)
}

/// События которые отправляем от Presenter ко View
protocol FortuneWheelEditSectionViewInput {
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [FortuneWheelEditSectionTableViewType])
}

/// Псевдоним протокола UIView & FortuneWheelEditSectionViewInput
typealias FortuneWheelEditSectionViewProtocol = UIView & FortuneWheelEditSectionViewInput

/// View для экрана
final class FortuneWheelEditSectionView: FortuneWheelEditSectionViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelEditSectionViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
  private var models: [FortuneWheelEditSectionTableViewType] = []
  private var caheIndexPathsToReload: Set<IndexPath> = []
  private let sectionTextField = TextFieldView()
  private let objectTextField = TextFieldView()
  private var emoticonCache: Character = "😍"
  
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
  
  func updateContentWith(models: [FortuneWheelEditSectionTableViewType]) {
    self.models = models
    tableView.reloadData()
  }
}

// MARK: - UITextFieldDelegate

extension FortuneWheelEditSectionView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text, textField == objectTextField else {
      return true
    }
    
    if !text.isEmpty {
      output?.createObject(
        emoticonCache,
        sectionTextField.text,
        objectTextField.text
      )
      objectTextField.text = ""
    }
    return false
  }
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    if range.location >= 20 {
      return false
    }
    return true
  }
}

// MARK: - UITableViewDelegate

extension FortuneWheelEditSectionView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch models[indexPath.row] {
    case .insets(let inset):
      return CGFloat(inset)
    case .divider:
      return CGFloat(1)
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
      case let .wheelObject(object):
        self.output?.deleteObject(object)
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
    case .wheelObject:
      return true
    default:
      return false
    }
  }
}

// MARK: - UITableViewDataSource

extension FortuneWheelEditSectionView: UITableViewDataSource {
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
    case let .wheelObject(object):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomTextCell.reuseIdentifier
      ) as? CustomTextCell {
        caheIndexPathsToReload.insert(indexPath)
        
        cell.configureCellWith(
          titleText: object,
          textColor: RandomColor.darkAndLightTheme.primaryGray,
          textFont: RandomFont.primaryMedium24,
          textAlignment: .left
        )
        viewCell = cell
      }
    case let .textfieldAddSection(text):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: TextFieldGrayWithEmoticonCell.reuseIdentifier
      ) as? TextFieldGrayWithEmoticonCell {
        cell.configureCellWith(
          textField: sectionTextField,
          textFieldBorderColor: RandomColor.only.secondaryGray,
          emoticon: emoticonCache) { [weak self] emoticon, style in
            self?.emoticonCache = emoticon ?? "😍"
          }
        sectionTextField.text = text
        viewCell = cell
      }
    case .textfieldAddObjects:
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: TextFieldGrayWithButtonCell.reuseIdentifier
      ) as? TextFieldGrayWithButtonCell {
        let checkmarkImage = UIImage(systemName: Appearance().checkmarkImageName,
                                     withConfiguration: Appearance().largeConfig)
        cell.configureCellWith(
          textField: objectTextField,
          textFieldBorderColor: RandomColor.only.secondaryGray,
          buttonImage: checkmarkImage,
          buttonAction: { [weak self] in
            guard let self else {
              return
            }
            
            if self.objectTextField.text?.isEmpty ?? true {
              // TODO: - Кинуть ошибку
              return
            }
            
            self.output?.createObject(
              self.emoticonCache,
              self.sectionTextField.text,
              self.objectTextField.text
            )
            self.objectTextField.text = nil
          })
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

// MARK: - Private

private extension FortuneWheelEditSectionView {
  func configureLayout() {
    let appearance = Appearance()
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
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    tableView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    sectionTextField.delegate = self
    sectionTextField.placeholder = "Заголовок"
    objectTextField.delegate = self
    objectTextField.placeholder = "Новый объект"
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.contentInset.top = Appearance().defaultInset
    
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(CustomTextCell.self,
                       forCellReuseIdentifier: CustomTextCell.reuseIdentifier)
    tableView.register(DividerTableViewCell.self,
                       forCellReuseIdentifier: DividerTableViewCell.reuseIdentifier)
    tableView.register(TextFieldGrayWithButtonCell.self,
                       forCellReuseIdentifier: TextFieldGrayWithButtonCell.reuseIdentifier)
    tableView.register(TextFieldGrayWithEmoticonCell.self,
                       forCellReuseIdentifier: TextFieldGrayWithEmoticonCell.reuseIdentifier)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }
}

// MARK: - Appearance

private extension FortuneWheelEditSectionView {
  struct Appearance {
    let defaultInset: CGFloat = 16
    let checkmarkImageName = "checkmark.circle.fill"
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 20,
                                                  weight: .bold,
                                                  scale: .large)
    let deleteTitle = RandomStrings.Localizable.remove
    let deleteImage = UIImage(systemName: "trash")
  }
}

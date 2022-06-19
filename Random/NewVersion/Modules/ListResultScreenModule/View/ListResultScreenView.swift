//
//  ListResultScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol ListResultScreenViewOutput: AnyObject {
  
}

/// События которые отправляем от Presenter ко View
protocol ListResultScreenViewInput: AnyObject {
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [Any])
}

/// Псевдоним протокола UIView & ListResultScreenViewInput
typealias ListResultScreenViewProtocol = UIView & ListResultScreenViewInput

/// View для экрана
final class ListResultScreenView: ListResultScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: ListResultScreenViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = UITableView()
  private var models: [Any] = []
  
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
  
  func updateContentWith(models: [Any]) {
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
    tableView.register(CustomTextCell.self,
                       forCellReuseIdentifier: CustomTextCell.reuseIdentifier)
    
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.contentInset.top = Appearance().inset.top
  }
}

// MARK: - UITableViewDelegate

extension ListResultScreenView: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension ListResultScreenView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    
    if let text = model as? String {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomTextCell.reuseIdentifier
      ) as! CustomTextCell
      
      cell.configureCellWith(titleText: text,
                             textColor: RandomColor.primaryGray,
                             textAlignment: .center)
      
      if tableView.isFirst(for: indexPath) {
        cell.layer.cornerRadius = Appearance().cornerRadius
        cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      }
      
      if tableView.isLast(for: indexPath) {
        cell.isHiddenSeparator = true
        cell.layer.cornerRadius = Appearance().cornerRadius
        cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
      }
      
      return cell
    }
    return UITableViewCell()
  }
}

// MARK: - Appearance

private extension ListResultScreenView {
  struct Appearance {
    let inset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    let cornerRadius: CGFloat = 8
  }
}

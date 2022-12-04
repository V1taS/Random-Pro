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
  
  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String)
}

/// События которые отправляем от Presenter ко View
protocol ListResultScreenViewInput: AnyObject {
  
  /// Обновить контент
  ///  - Parameter list: Список результатов
  func updateContentWith(list: [String])
  
  ///  Получить изображение контента
  func returnCurrentContentImage(completion: @escaping (Data?) -> Void)
}

/// Псевдоним протокола UIView & ListResultScreenViewInput
typealias ListResultScreenViewProtocol = UIView & ListResultScreenViewInput

/// View для экрана
final class ListResultScreenView: ListResultScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: ListResultScreenViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
  private var list: [String] = []
  private let contentPlugImage = UIImageView()
  
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
  
  func updateContentWith(list: [String]) {
    self.list = list
    tableView.reloadData()
  }
  
  func returnCurrentContentImage(completion: @escaping (Data?) -> Void) {
    showContentPlug()
    return tableView.screenShotFullContent { [weak self] screenshot in
      let imgData = screenshot?.pngData()
      completion(imgData)
      self?.hideContentPlug()
    }
  }
}

// MARK: - UITableViewDelegate

extension ListResultScreenView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let result = list[indexPath.row]
    output?.resultCopied(text: result)
  }
}

// MARK: - UITableViewDataSource

extension ListResultScreenView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    list.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let result = list[indexPath.row]
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: CustomTextCell.reuseIdentifier
    ) as? CustomTextCell else {
      assertionFailure("Не получилось прокастить ячейку")
      return UITableViewCell()
    }
    
    cell.isHiddenSeparator = false
    cell.configureCellWith(titleText: result,
                           textColor: RandomColor.primaryGray,
                           textAlignment: .center)
    
    if tableView.isFirst(for: indexPath) {
      cell.layer.cornerRadius = Appearance().cornerRadius
      cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      cell.clipsToBounds = true
    }
    
    if tableView.isLast(for: indexPath) {
      cell.isHiddenSeparator = true
      cell.layer.cornerRadius = Appearance().cornerRadius
      cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
      cell.clipsToBounds = true
    }
    return cell
  }
}

// MARK: - Private

private extension ListResultScreenView {
  func showContentPlug() {
    contentPlugImage.isHidden = false
    contentPlugImage.image = self.asImage
  }
  
  func hideContentPlug() {
    contentPlugImage.isHidden = true
    contentPlugImage.image = nil
  }
  
  func configureLayout() {
    let appearance = Appearance()
    [tableView, contentPlugImage].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.insets.left),
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.insets.right),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      contentPlugImage.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentPlugImage.topAnchor.constraint(equalTo: topAnchor),
      contentPlugImage.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentPlugImage.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.primaryWhite
    tableView.backgroundColor = RandomColor.primaryWhite
    tableView.showsVerticalScrollIndicator = false
    tableView.separatorColor = RandomColor.secondaryGray
    
    contentPlugImage.isHidden = true
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CustomTextCell.self,
                       forCellReuseIdentifier: CustomTextCell.reuseIdentifier)
    
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    tableView.contentInset.top = Appearance().insets.top
  }
}

// MARK: - Appearance

private extension ListResultScreenView {
  struct Appearance {
    let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    let cornerRadius: CGFloat = 8
  }
}

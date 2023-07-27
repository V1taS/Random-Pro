//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol ___FILEBASENAMEASIDENTIFIER___Output: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol ___FILEBASENAMEASIDENTIFIER___Input {
  
  /// Устанавливает модели в таблицу
  /// - Parameter models: модели
  func configure(with models: [Any])
}

/// Псевдоним протокола UIView & ___FILEBASENAMEASIDENTIFIER___Input
typealias ___FILEBASENAMEASIDENTIFIER___Protocol = UIView & ___FILEBASENAMEASIDENTIFIER___Input

/// View для экрана
final class ___FILEBASENAMEASIDENTIFIER___: ___FILEBASENAMEASIDENTIFIER___Protocol {
  
  // MARK: - Internal properties
  
  weak var output: ___FILEBASENAMEASIDENTIFIER___Output?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
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
  
  func configure(with models: [Any]) {
    self.models = models
    tableView.reloadData()
  }
}

// MARK: - UITableViewDelegate

extension ___FILEBASENAMEASIDENTIFIER___: UITableViewDelegate {
  //  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //    switch models[indexPath.row] {
  //    case .insets(let inset):
  //      return CGFloat(inset)
  //    case .divider:
  //      return CGFloat(1)
  //    default:
  //      return UITableView.automaticDimension
  //    }
  //  }
}

// MARK: - UITableViewDelegate

extension ___FILEBASENAMEASIDENTIFIER___: UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    var viewCell = UITableViewCell()
    if let cell = tableView.dequeueReusableCell(
      withIdentifier: CustomPaddingCell.reuseIdentifier
    ) as? CustomPaddingCell {
      cell.configureCellWith(height: CGFloat(inset))
      cell.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
      cell.contentView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
      viewCell = cell
    }
    return viewCell
  }
}

// MARK: - Private

private extension ___FILEBASENAMEASIDENTIFIER___ {
  func configureLayout() {
    let appearance = Appearance()
    
    [tableView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                     constant: appearance.tableViewInsets.top),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                         constant: appearance.tableViewInsets.left),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                          constant: -appearance.tableViewInsets.right),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                        constant: -appearance.tableViewInsets.bottom)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    tableView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = appearance.estimatedRowHeight
    tableView.keyboardDismissMode = .onDrag
    
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }
}

// MARK: - Appearance

private extension ___FILEBASENAMEASIDENTIFIER___ {
  struct Appearance {
    let tableViewInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    let estimatedRowHeight: CGFloat = 70
  }
}

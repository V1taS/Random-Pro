//
//  AdminFeatureToggleView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.07.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol AdminFeatureToggleViewOutput: AnyObject {
  
  /// Кнопка авторизоваться была нажата
  /// - Parameters:
  ///  - login: Логин админа
  ///  - password: Пароль админа
  func loginButtonAction(login: String, password: String)
  
  /// Неверный логин или пароль
  func loginOrPasswordError()
  
  /// Кнопка сохранить настройки была нажата
  func saveSettingsButtonAction()
}

/// События которые отправляем от Presenter ко View
protocol AdminFeatureToggleViewInput: AnyObject {
  
  /// Запустить лоадер
  func startLoader()
  
  /// Остановить лоадер
  func stopLoader()
  
  /// Показать экран авторизации
  ///  - Parameter isShow: Показать / Скрыть экран
  func loginPage(isShow: Bool)
  
  /// Обновить контент
  /// - Parameter models: Модели для ячеек
  func updateContentWith(models: [AdminFeatureToggleModel])
}

/// Псевдоним протокола UIView & AdminFeatureToggleViewInput
typealias AdminFeatureToggleViewProtocol = UIView & AdminFeatureToggleViewInput

/// View для экрана
final class AdminFeatureToggleView: AdminFeatureToggleViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: AdminFeatureToggleViewOutput?
  
  // MARK: - Private properties
  
  private let loginContainer = UIStackView()
  private let loginButton = ButtonView()
  private let loginTextField = TextFieldView()
  private let passwordTextField = TextFieldView()
  private let loginStackView = UIStackView()
  
  private let tableView = UITableView()
  private let saveSettingsButton = ButtonView()
  private var models: [AdminFeatureToggleModel] = []
  
  private let loader = UIActivityIndicatorView()
  
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
  
  func loginPage(isShow: Bool) {
    loginContainer.isHidden = !isShow
  }
  
  func startLoader() {
    loader.isHidden = false
    loader.startAnimating()
  }
  
  func stopLoader() {
    loader.isHidden = true
    loader.stopAnimating()
  }
  
  func updateContentWith(models: [AdminFeatureToggleModel]) {
    self.models = models
    tableView.reloadData()
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [tableView, saveSettingsButton, loginContainer, loader].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [loginButton, loginStackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      loginContainer.addSubview($0)
    }
    
    [loginTextField, passwordTextField].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      loginStackView.addArrangedSubview($0)
    }
    
    NSLayoutConstraint.activate([
      loginContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
      loginContainer.topAnchor.constraint(equalTo: topAnchor),
      loginContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
      loginContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      loginTextField.leadingAnchor.constraint(equalTo: loginContainer.leadingAnchor,
                                              constant: appearance.defaultInset),
      loginTextField.trailingAnchor.constraint(equalTo: loginContainer.trailingAnchor,
                                               constant: -appearance.defaultInset),
      loginTextField.topAnchor.constraint(equalTo: loginContainer.topAnchor,
                                          constant: appearance.loginTextFieldTopSpacing),
      
      loginButton.leadingAnchor.constraint(equalTo: loginContainer.leadingAnchor,
                                           constant: appearance.defaultInset),
      loginButton.trailingAnchor.constraint(equalTo: loginContainer.trailingAnchor,
                                            constant: -appearance.defaultInset),
      loginButton.bottomAnchor.constraint(equalTo: loginContainer.bottomAnchor,
                                          constant: -appearance.loginButtonBottomSpacing),
      
      loader.centerXAnchor.constraint(equalTo: centerXAnchor),
      loader.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                         constant: appearance.defaultInset),
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                          constant: -appearance.defaultInset),
      
      saveSettingsButton.topAnchor.constraint(equalTo: tableView.bottomAnchor,
                                              constant: appearance.defaultInset),
      saveSettingsButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: appearance.defaultInset),
      saveSettingsButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -appearance.defaultInset),
      saveSettingsButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                 constant: -appearance.defaultInset),
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    tableView.backgroundColor = RandomColor.primaryWhite
    loginContainer.backgroundColor = RandomColor.primaryWhite
    
    loginTextField.placeholder = appearance.loginValue
    loginTextField.delegate = self
    loginTextField.keyboardType = .default
    
    passwordTextField.placeholder = appearance.passwordValue
    passwordTextField.delegate = self
    passwordTextField.keyboardType = .numberPad
    
    loginStackView.axis = .vertical
    loginStackView.spacing = appearance.loginStackViewSpacing
    loginStackView.distribution = .fillEqually
    
    loader.isHidden = true
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.showsVerticalScrollIndicator = false
    tableView.register(LabelAndSwitchWithSegmentedCell.self,
                       forCellReuseIdentifier: LabelAndSwitchWithSegmentedCell.reuseIdentifier)
    tableView.tableFooterView = UIView()
    tableView.tableHeaderView = UIView()
    
    loginButton.setTitle(appearance.loginButtonTitle, for: .normal)
    loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
    
    saveSettingsButton.setTitle(appearance.saveSettingsButtonTitle, for: .normal)
    saveSettingsButton.addTarget(self, action: #selector(saveSettingsButtonAction), for: .touchUpInside)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }
}

// MARK: - Private

private extension AdminFeatureToggleView {
  @objc
  func saveSettingsButtonAction() {
    output?.saveSettingsButtonAction()
  }
  
  @objc
  func loginButtonAction() {
    guard let login = loginTextField.text,
          !login.isEmpty,
          let password = passwordTextField.text,
          !password.isEmpty else {
      output?.loginOrPasswordError()
      return
    }
    output?.loginButtonAction(login: login, password: password)
  }
}

// MARK: - UITextFieldDelegate

extension AdminFeatureToggleView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    loginTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    return true
  }
}

// MARK: - UITableViewDelegate

extension AdminFeatureToggleView: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension AdminFeatureToggleView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: LabelAndSwitchWithSegmentedCell.reuseIdentifier
    ) as? LabelAndSwitchWithSegmentedCell else {
      assertionFailure("Не получилось прокастить ячейку")
      return UITableViewCell()
    }
    
    let model = models[indexPath.row]
    cell.isHiddenSeparator = false
    
    cell.removeAllSegments()
    model.advLabels.enumerated().forEach { index, label in
      cell.insertSegment(withTitle: label.rawValue, at: index, animated: false)
    }
    cell.selectedSegmentIndex = model.currentIndexADVLabels
    cell.configureCellWith(titleText: model.sectionName, isResultSwitch: model.isFeatureToggle)
    
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
}

// MARK: - Appearance

private extension AdminFeatureToggleView {
  struct Appearance {
    let defaultInset: CGFloat = 16
    let loginStackViewSpacing: CGFloat = 16
    let loginTextFieldTopSpacing: CGFloat = 150
    let loginButtonBottomSpacing: CGFloat = 64
    let cornerRadius: CGFloat = 8
    let loginValue = "Admin login"
    let passwordValue = "Admin password"
    let loginButtonTitle = "Login"
    let saveSettingsButtonTitle = "Save settings"
  }
}

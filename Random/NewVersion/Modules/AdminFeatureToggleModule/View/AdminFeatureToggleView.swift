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
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [loginContainer, loader].forEach {
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
                                           constant: appearance.middleHorizontalSpacing),
      loginTextField.trailingAnchor.constraint(equalTo: loginContainer.trailingAnchor,
                                            constant: -appearance.middleHorizontalSpacing),
      loginTextField.topAnchor.constraint(equalTo: loginContainer.topAnchor,
                                          constant: appearance.loginTextFieldTopSpacing),
      
      loginButton.leadingAnchor.constraint(equalTo: loginContainer.leadingAnchor,
                                           constant: appearance.middleHorizontalSpacing),
      loginButton.trailingAnchor.constraint(equalTo: loginContainer.trailingAnchor,
                                            constant: -appearance.middleHorizontalSpacing),
      loginButton.bottomAnchor.constraint(equalTo: loginContainer.bottomAnchor,
                                          constant: -appearance.loginButtonBottomSpacing),
      
      loader.centerXAnchor.constraint(equalTo: centerXAnchor),
      loader.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.secondaryWhite
    
    /// Авторизация в Админ панель
    loginContainer.backgroundColor = RandomColor.secondaryWhite
    
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
    
    loginButton.setTitle(appearance.loginButtonTitle, for: .normal)
    loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }
}

// MARK: - Private

private extension AdminFeatureToggleView {
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

// MARK: - Appearance

private extension AdminFeatureToggleView {
  struct Appearance {
    let middleHorizontalSpacing: CGFloat = 16
    let loginStackViewSpacing: CGFloat = 16
    let loginTextFieldTopSpacing: CGFloat = 150
    let loginButtonBottomSpacing: CGFloat = 64
    let loginValue = "Admin login"
    let passwordValue = "Admin password"
    let loginButtonTitle = "Login"
  }
}

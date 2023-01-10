//
//  RaffleScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.01.2023.
//

import UIKit
import RandomUIKit
import AuthenticationServices

/// События которые отправляем из View в Presenter
protocol RaffleScreenViewOutput: AnyObject {
  
  /// Пользователь нажал Войти / Зарегистрироваться
  func actionOnSignInWithApple()
}

/// События которые отправляем от Presenter ко View
protocol RaffleScreenViewInput {
  
  /// Запустить анимацию загрузки
  func startLoader()
  
  /// Остановить анимацию загрузки
  func stopLoader()
}

/// Псевдоним протокола UIView & RaffleScreenViewInput
typealias RaffleScreenViewProtocol = UIView & RaffleScreenViewInput

/// View для экрана
final class RaffleScreenView: RaffleScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: RaffleScreenViewOutput?
  
  // MARK: - Private properties
  
  private let loaderView = UIActivityIndicatorView(style: .large)
  private let authButton = ASAuthorizationAppleIDButton(
    authorizationButtonType: .default,
    authorizationButtonStyle: UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
)
  
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
  
  func startLoader() {
    loaderView.isHidden = false
    loaderView.startAnimating()
  }
  
  func stopLoader() {
    loaderView.stopAnimating()
    loaderView.isHidden = true
  }
}

// MARK: - Private

private extension RaffleScreenView {
  func configureLayout() {
    let appearance = Appearance()
    
    [authButton, loaderView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      authButton.heightAnchor.constraint(equalToConstant: appearance.authButtonHeight),
      authButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                          constant: appearance.defaultInset),
      authButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                           constant: -appearance.defaultInset),
      authButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                         constant: -appearance.defaultInset),
      
      loaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
      loaderView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.primaryWhite
    loaderView.isHidden = true
    authButton.addTarget(self, action: #selector(actionOnSignInWithApple), for: .touchUpInside)
  }
  
  @objc
  func actionOnSignInWithApple() {
    output?.actionOnSignInWithApple()
  }
}

// MARK: - Appearance

private extension RaffleScreenView {
  struct Appearance {
    let defaultInset: CGFloat = 16
    let authButtonHeight: CGFloat = 52
  }
}

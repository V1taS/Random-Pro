//
//  ForceUpdateAppView.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import UIKit
import FancyUIKit
import FancyStyle
import Lottie

/// События которые отправляем из View в Presenter
protocol ForceUpdateAppViewOutput: AnyObject {
  
  /// Обновить приложение
  func updateButtonAction()
}

/// События которые отправляем от Presenter ко View
protocol ForceUpdateAppViewInput {
  
  /// Запустить заглушку
  func startStubAnimation()
  
  /// Остановить заглушку
  func stopStubAnimation()
}

/// Псевдоним протокола UIView & ForceUpdateAppViewInput
typealias ForceUpdateAppViewProtocol = UIView & ForceUpdateAppViewInput

/// View для экрана
final class ForceUpdateAppView: ForceUpdateAppViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: ForceUpdateAppViewOutput?
  
  // MARK: - Private properties
  
  private let stubAnimationView = LottieAnimationView(name: Appearance().stubImage)
  private let titleLabel = UILabel()
  private let feedBackButton = ButtonView()
  
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
  
  func startStubAnimation() {
    stubAnimationView.play()
  }
  
  func stopStubAnimation() {
    stubAnimationView.stop()
  }
}

// MARK: - Private

private extension ForceUpdateAppView {
  func configureLayout() {
    let appearance = Appearance()
    [stubAnimationView, titleLabel, feedBackButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      stubAnimationView.centerXAnchor.constraint(equalTo: centerXAnchor),
      stubAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
      stubAnimationView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5),
      
      titleLabel.topAnchor.constraint(equalTo: stubAnimationView.bottomAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                          constant: appearance.inset),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                           constant: -appearance.inset),
      
      feedBackButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.inset),
      feedBackButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.inset),
      feedBackButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.inset)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    
    stubAnimationView.contentMode = .scaleAspectFit
    stubAnimationView.loopMode = .loop
    stubAnimationView.animationSpeed = Appearance().animationSpeed
    
    titleLabel.numberOfLines = .zero
    titleLabel.font = RandomFont.primaryMedium18
    titleLabel.textColor = fancyColor.darkAndLightTheme.primaryBlack
    titleLabel.textAlignment = .center
    titleLabel.text = RandomStrings.Localizable.oopsYourVersionOfRandomProIsOutOfDate
    
    feedBackButton.setTitle(RandomStrings.Localizable.update, for: .normal)
    feedBackButton.addTarget(self,
                             action: #selector(updateButtonAction),
                             for: .touchUpInside)
    
  }
  
  @objc
  func updateButtonAction() {
    output?.updateButtonAction()
  }
}

// MARK: - Appearance

private extension ForceUpdateAppView {
  struct Appearance {
    let inset: CGFloat = 16
    let stubImage = RandomAsset.appUpdatePlug.name
    let animationSpeed: CGFloat = 0.5
  }
}

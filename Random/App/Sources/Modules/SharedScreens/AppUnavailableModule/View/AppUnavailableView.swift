//
//  AppUnavailableView.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import UIKit
import FancyUIKit
import FancyStyle
import Lottie

/// События которые отправляем из View в Presenter
protocol AppUnavailableViewOutput: AnyObject {
  
  /// Кнопка обратной связи была нажата
  func feedBackButtonAction()
}

/// События которые отправляем от Presenter ко View
protocol AppUnavailableViewInput {
  
  /// Запустить заглушку
  func startStubAnimation()
  
  /// Остановить заглушку
  func stopStubAnimation()
}

/// Псевдоним протокола UIView & AppUnavailableViewInput
typealias AppUnavailableViewProtocol = UIView & AppUnavailableViewInput

/// View для экрана
final class AppUnavailableView: AppUnavailableViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: AppUnavailableViewOutput?
  
  // MARK: - Private properties
  
  private let stubAnimationView = LottieAnimationView(name: Appearance().stubImage)
  private let titleLabel = UILabel()
  private let feedBackButton = UIButton(type: .system)
  
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

private extension AppUnavailableView {
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
      
      titleLabel.topAnchor.constraint(equalTo: stubAnimationView.bottomAnchor,
                                      constant: appearance.inset),
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
    titleLabel.font = fancyFont.primaryMedium18
    titleLabel.textColor = fancyColor.darkAndLightTheme.primaryBlack
    titleLabel.textAlignment = .center
    titleLabel.text = RandomStrings.Localizable.wowRandomProOnAShortTechBreak
    
    feedBackButton.setTitle(Appearance().addressRecipients, for: .normal)
    feedBackButton.setTitleColor(fancyColor.only.primaryBlue, for: .normal)
    feedBackButton.titleLabel?.font = fancyFont.primaryRegular16
    feedBackButton.addTarget(self,
                             action: #selector(feedBackButtonAction),
                             for: .touchUpInside)
  }
  
  @objc
  func feedBackButtonAction() {
    output?.feedBackButtonAction()
  }
}

// MARK: - Appearance

private extension AppUnavailableView {
  struct Appearance {
    let inset: CGFloat = 16
    let stubImage = RandomAsset.appUnavailablePlug.name
    let animationSpeed: CGFloat = 0.5
    let addressRecipients = "Random_Pro_support@iCloud.com"
  }
}

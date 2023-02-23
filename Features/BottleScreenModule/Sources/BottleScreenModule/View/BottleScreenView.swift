//
//  BottleScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol BottleScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку
  func bottleRotationButtonAction()
}

/// События которые отправляем от Presenter ко View
protocol BottleScreenViewInput {
  
  /// Остановить вращение бутылочки
  func stopBottleRotation()
  
  /// Сброс текущего положения на начальное
  func resetPositionBottle()
}

typealias BottleScreenViewProtocol = UIView & BottleScreenViewInput

final class BottleScreenView: BottleScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: BottleScreenViewOutput?
  
  // MARK: - Private properties
  
  private let resultLabel = UILabel()
  private let bottleRotationButton = ButtonView()
  private let bottleImageView = UIImageView()
  private var isFirstStart = true
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupDefaultSettings()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Intarnal func
  
  func stopBottleRotation() {
    bottleImageView.pauseRotation()
    bottleRotationButton.set(isEnabled: true)
  }
  
  func resetPositionBottle() {
    bottleImageView.stopRotation()
    isFirstStart = true
    bottleRotationButton.set(isEnabled: true)
  }
}
// MARK: - Private

private extension BottleScreenView {
  func setupConstraints() {
    let appearance = Appearance()
    
    [bottleRotationButton, bottleImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      bottleRotationButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      bottleRotationButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      bottleRotationButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset),
      
      bottleImageView.heightAnchor.constraint(equalTo: heightAnchor,
                                              multiplier: appearance.bottleHeightMultiplier,
                                              constant: .zero),
      bottleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      bottleImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }
  
  func setupDefaultSettings() {
    let appearance = Appearance()
    
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    bottleImageView.image = appearance.bottleImage
    bottleImageView.contentMode = .scaleAspectFit
    
    bottleRotationButton.setTitle(appearance.buttonTitle, for: .normal)
    bottleRotationButton.addTarget(self, action: #selector(bottleRotationButtonAction), for: .touchUpInside)
  }
  
  @objc
  func bottleRotationButtonAction() {
    if isFirstStart {
      bottleImageView.startRotation(duration: Appearance().bottleHeightMultiplier)
      isFirstStart = false
    } else {
      bottleImageView.resumeRotation()
    }
    bottleRotationButton.set(isEnabled: false)
    output?.bottleRotationButtonAction()
  }
}

// MARK: - Appearance

private extension BottleScreenView {
  struct Appearance {
    let buttonTitle = NSLocalizedString("Крутить бутылочку", comment: "")
    let defaultInset: CGFloat = 16
    let bottleImage = UIImage(named: "Bottle")
    let bottleHeightMultiplier: Double = 0.4
  }
}

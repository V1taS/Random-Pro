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
  func generateButtonAction()
}

/// События которые отправляем от Presenter ко View
protocol BottleScreenViewInput {
  
  /// Остановка анимации бутылочки
  func stopAnimation()
  
  /// Отклик при вращении бутылочки
  func hapticFeedback()
  
  /// Сброс текущего положения на начальное
  func resetPositionBottle()
}

typealias BottleScreenViewProtocol = UIView & BottleScreenViewInput

final class BottleScreenView: BottleScreenViewProtocol {

  // MARK: - Internal property
  
  weak var output: BottleScreenViewOutput?
  
  // MARK: - Internal property
  
  private let resultLabel = UILabel()
  private let generateButton = ButtonView()
  private let bottleImageView = UIImageView()
  private var isFirstStart = true
  
  // MARK: - Internal func
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDefaultSettings()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func hapticFeedback() {
    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
  }
  
  func stopAnimation() {
    bottleImageView.pauseRotation()
    generateButton.set(isEnabled: true)
  }
  
  func resetPositionBottle() {
    bottleImageView.stopRotation()
    isFirstStart = true
  }
  
  // MARK: - Private func
  
  private func setupDefaultSettings() {
    let appearance = Appearance()
    
    backgroundColor = RandomColor.primaryWhite
    
    bottleImageView.image = appearance.bottleImage
    bottleImageView.contentMode = .scaleAspectFit

    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
  }
  
  @objc private func generateButtonAction() {
    if isFirstStart {
      bottleImageView.startRotation(duration: Appearance().sizeInset)
      isFirstStart = false
    } else {
      bottleImageView.resumeRotation()
    }
    generateButton.set(isEnabled: false)
    output?.generateButtonAction()
  }

  private func setupConstraints() {
    let appearance = Appearance()
    
    [generateButton, bottleImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset),
      
      bottleImageView.heightAnchor.constraint(equalTo: heightAnchor,
                                              multiplier: appearance.sizeInset,
                                              constant: .zero),
      bottleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      bottleImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }
}

// MARK: - Appearance

private extension BottleScreenView {
  struct Appearance {
    let buttonTitle = NSLocalizedString("Крутить бутылочку", comment: "")
    let defaultInset: CGFloat = 16
    let bottleImage = UIImage(named: "Bottle")
    let sizeInset: Double = 0.4
  }
}

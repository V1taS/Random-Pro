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
  
}

typealias BottleScreenViewProtocol = UIView & BottleScreenViewInput

final class BottleScreenView: BottleScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: BottleScreenViewOutput?
  
  private let resultLabel = UILabel()
  private let generateButton = ButtonView()
  private let bottleImageView = UIImageView()
  
  // MARK: - Internal func
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDefaultSettings()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private func
  
  private func setupDefaultSettings() {
    let appearance = Appearance()
    
    backgroundColor = RandomColor.primaryWhite
    
    bottleImageView.image = appearance.bottleImage
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
  }
  
  @objc private func generateButtonAction() {
    bottleImageView.startAnimating()
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
      
      bottleImageView.heightAnchor.constraint(equalToConstant: 180),
      bottleImageView.widthAnchor.constraint(equalToConstant: 60),
      bottleImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      bottleImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}

// MARK: - Appearance

private extension BottleScreenView {
  struct Appearance {
    let buttonTitle = NSLocalizedString("Крутить бутылочку", comment: "")
    let defaultInset: CGFloat = 16
    let bottleImage = UIImage(named: "Bottle")
  }
}

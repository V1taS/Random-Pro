//
//  ContactScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol ContactScreenViewOutput: AnyObject {
  
  /// Кнопка нажата пользователем
  func generateButtonAction()
}

/// События которые отправляем от Presenter ко View
protocol ContactScreenViewInput {
  
  /// Устанавливаем данные в result
  ///  - Parameter text: Результат генерации
  func setResult(_ text: String?)
}

/// Псевдоним протокола UIView & ContactScreenViewInput
typealias ContactScreenViewProtocol = UIView & ContactScreenViewInput

final class ContactScreenView: ContactScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: ContactScreenViewOutput?
  
  // MARK: - Private property
  
  private let resultLabel = UILabel()
  private let generateButton = ButtonView()
  
  // MARK: - Internal func
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDefaultSettings()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setResult(_ text: String?) {
    resultLabel.text = text
  }
}

// MARK: - Private

private extension ContactScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
    resultLabel.text = appearance.resultTitle
    resultLabel.font = RandomFont.primaryMedium32
    resultLabel.textColor = RandomColor.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = .zero
    
    generateButton.setTitle(appearance.titleButton, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [resultLabel, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.middleSpacing),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.middleSpacing),
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.middleSpacing),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.middleSpacing),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.middleSpacing)
    ])
  }
  
  @objc
  func generateButtonAction() {
    output?.generateButtonAction()
  }
}

// MARK: - Appearance

extension ContactScreenView {
  struct Appearance {
    let resultTitle = "?"
    let titleButton = NSLocalizedString("Сгенерировать", comment: "")
    let middleSpacing: CGFloat = 16
  }
}

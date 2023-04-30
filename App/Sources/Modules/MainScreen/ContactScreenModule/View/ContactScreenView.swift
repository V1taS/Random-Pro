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
  
  /// Было нажатие на результат генерации
  func resultLabelAction()
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
    resultLabel.zoomIn(duration: Appearance().resultDuration,
                       transformScale: CGAffineTransform(scaleX: .zero, y: .zero))
  }
}

// MARK: - Private

private extension ContactScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    resultLabel.text = appearance.resultTitle
    resultLabel.font = RandomFont.primaryMedium32
    resultLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = .zero
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    let resultLabelAction = UITapGestureRecognizer(target: self, action: #selector(resultAction))
    resultLabelAction.cancelsTouchesInView = false
    resultLabel.addGestureRecognizer(resultLabelAction)
    resultLabel.isUserInteractionEnabled = true
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [resultLabel, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.defaultInset),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.defaultInset),
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset)
    ])
  }
  
  @objc
  func generateButtonAction() {
    output?.generateButtonAction()
  }
  
  @objc
  func resultAction() {
    output?.resultLabelAction()
  }
}

// MARK: - Appearance

extension ContactScreenView {
  struct Appearance {
    let defaultInset: CGFloat = 16
    let resultDuration: CGFloat = 0.2
    
    let resultTitle = "?"
    let buttonTitle = NSLocalizedString("Сгенерировать", comment: "")
  }
}

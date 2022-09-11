//
//  ListScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol ListScreenViewOutput: AnyObject {
  
  /// Кнопка генерации была нажата
  func generateButtonAction()
}

/// События которые отправляем из Presenter во View
protocol ListScreenViewInput {
  
  /// Обновить контент
  /// - Parameter text: Текст
  func updateContentWith(text: String?)
}

/// Псевдоним протокола UIView & ListScreenViewInput
typealias ListScreenViewProtocol = UIView & ListScreenViewInput

final class ListScreenView: ListScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: ListScreenViewOutput?
  
  // MARK: - Private property
  
  private let resultTextView = UITextView()
  private let generateButton = ButtonView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDefaultSettings()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func updateContentWith(text: String?) {
    resultTextView.text = text
  }
}

// MARK: - Private

private extension ListScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
    resultTextView.textColor = RandomColor.primaryGray
    resultTextView.font = RandomFont.primaryMedium32
    resultTextView.textAlignment = .center
    resultTextView.isEditable = false
    resultTextView.backgroundColor = RandomColor.primaryWhite
    
    let padding = resultTextView.textContainer.lineFragmentPadding
    resultTextView.textContainerInset =  UIEdgeInsets(top: .zero,
                                                      left: -padding,
                                                      bottom: .zero,
                                                      right: -padding)
    
    generateButton.setTitle(appearance.titleButton, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
  }
  
  @objc
  func generateButtonAction() {
    output?.generateButtonAction()
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [resultTextView, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultTextView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.mediumSpasing),
      resultTextView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.mediumSpasing),
      resultTextView.topAnchor.constraint(equalTo: topAnchor,
                                          constant: appearance.mediumSpasing),
      resultTextView.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                             constant: -appearance.mediumSpasing),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.mediumSpasing),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.mediumSpasing),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.mediumSpasing)
    ])
  }
}

// MARK: - Appearance

private extension ListScreenView {
  struct Appearance {
    let titleButton = NSLocalizedString("Сгенерировать", comment: "")
    let mediumSpasing: CGFloat = 16
  }
}

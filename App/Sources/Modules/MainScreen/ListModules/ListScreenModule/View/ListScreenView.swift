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
  
  /// Было нажатие на результат генерации
  ///  - Parameter text: Результат генерации
  func resultLabelAction()
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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    resultTextView.centerVerticalText()
  }
  
  // MARK: - Internal func
  
  func updateContentWith(text: String?) {
    resultTextView.text = text
    resultTextView.centerVerticalText()
    resultTextView.zoomIn(duration: Appearance().resultDuration,
                          transformScale: CGAffineTransform(scaleX: .zero, y: .zero))
  }
}

// MARK: - Private

private extension ListScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    resultTextView.textColor = RandomColor.darkAndLightTheme.primaryGray
    resultTextView.font = RandomFont.primaryMedium32
    resultTextView.textAlignment = .center
    resultTextView.isEditable = false
    resultTextView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    let padding = resultTextView.textContainer.lineFragmentPadding
    resultTextView.textContainerInset =  UIEdgeInsets(top: .zero,
                                                      left: -padding,
                                                      bottom: .zero,
                                                      right: -padding)
    resultTextView.centerVerticalText()
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    let resultLabelAction = UITapGestureRecognizer(target: self, action: #selector(resultAction))
    resultLabelAction.cancelsTouchesInView = false
    resultTextView.addGestureRecognizer(resultLabelAction)
    resultTextView.isUserInteractionEnabled = true
  }
  
  @objc
  func generateButtonAction() {
    output?.generateButtonAction()
  }
  
  @objc
  func resultAction() {
    output?.resultLabelAction()
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [resultTextView, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultTextView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      resultTextView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      resultTextView.topAnchor.constraint(equalTo: topAnchor,
                                          constant: appearance.defaultInset),
      resultTextView.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                             constant: -appearance.defaultInset),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset)
    ])
  }
}

// MARK: - Appearance

private extension ListScreenView {
  struct Appearance {
    let defaultInset: CGFloat = 16
    let resultDuration: CGFloat = 0.2
    
    let buttonTitle = NSLocalizedString("Сгенерировать", comment: "")
  }
}

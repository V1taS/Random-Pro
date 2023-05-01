//
//  LetterScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 16.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

protocol LetterScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку и происходит генерация 'Английских букв'
  func generateEngButtonAction()
  
  /// Пользователь нажал на кнопку и происходит генерация  'Русских букв'
  func generateRusButtonAction()
  
  /// Было нажатие на результат генерации
  ///  - Parameter text: Результат генерации
  func resultLabelAction()
}

protocol LetterScreenViewInput {
  
  /// Обновить контент
  /// - Parameter model: Модель
  func updateContentWith(model: LetterScreenModel)
}

typealias LetterScreenViewProtocol = UIView & LetterScreenViewInput

final class LetterScreenView: LetterScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: LetterScreenViewOutput?
  
  // MARK: - Private property
  
  private let resultLabel = UILabel()
  private let scrollResult = ScrollLabelGradientView()
  private let generateButton = ButtonView()
  private let letterSegmentedControl = UISegmentedControl()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupConstraints()
    setupDefaultSettings()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func updateContentWith(model: LetterScreenModel) {
    scrollResult.listLabels = model.listResult
    letterSegmentedControl.selectedSegmentIndex = model.languageIndexSegmented
    
    resultLabel.text = model.result
    resultLabel.zoomIn(duration: Appearance().resultDuration,
                       transformScale: CGAffineTransform(scaleX: .zero, y: .zero))
  }
}

// MARK: - Private

private extension LetterScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    resultLabel.font = RandomFont.primaryBold70
    resultLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    letterSegmentedControl.insertSegment(withTitle: appearance.russionCharacterTitle,
                                         at: appearance.russionCharacterIndex, animated: false)
    letterSegmentedControl.insertSegment(withTitle: appearance.englishCharacterTitle,
                                         at: appearance.englishCharacterIndex, animated: false)
    letterSegmentedControl.selectedSegmentIndex = appearance.russionCharacterIndex
    
    let resultLabelAction = UITapGestureRecognizer(target: self, action: #selector(resultAction))
    resultLabelAction.cancelsTouchesInView = false
    resultLabel.addGestureRecognizer(resultLabelAction)
    resultLabel.isUserInteractionEnabled = true
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [resultLabel, scrollResult, generateButton, letterSegmentedControl].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset),
      
      letterSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: appearance.defaultInset),
      letterSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -appearance.defaultInset),
      letterSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      
      scrollResult.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollResult.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollResult.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                           constant: -appearance.minInset)
    ])
  }
  
  @objc
  func generateButtonAction() {
    let appearance = Appearance()
    
    if letterSegmentedControl.selectedSegmentIndex == appearance.russionCharacterIndex {
      output?.generateRusButtonAction()
      return
    }
    
    if letterSegmentedControl.selectedSegmentIndex == appearance.englishCharacterIndex {
      output?.generateEngButtonAction()
      return
    }
  }
  
  @objc
  func resultAction() {
    output?.resultLabelAction()
  }
}

// MARK: - Appearance

private extension LetterScreenView {
  struct Appearance {
    let buttonTitle = NSLocalizedString("Сгенерировать букву", comment: "")
    let russionCharacterTitle = NSLocalizedString("Русские буквы", comment: "")
    let englishCharacterTitle = NSLocalizedString("Английские буквы", comment: "")
    let minInset: CGFloat = 8
    let defaultInset: CGFloat = 16
    let englishCharacterIndex: Int = 1
    let russionCharacterIndex: Int = 0
    let resultDuration: CGFloat = 0.2
  }
}

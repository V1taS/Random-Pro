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
}

protocol LetterScreenViewInput: AnyObject {
  
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
  
  // MARK: - Internal func
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupConstraints()
    setupDefaultSettings()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateContentWith(model: LetterScreenModel) {
    resultLabel.text = model.result
    scrollResult.listLabels = model.listResult
    letterSegmentedControl.selectedSegmentIndex = model.languageIndexSegmented
  }
  
  // MARK: - Private func
  
  private func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
    resultLabel.font = RandomFont.primaryBold70
    resultLabel.textColor = RandomColor.primaryGray
    
    generateButton.setTitle(appearance.textButton, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    letterSegmentedControl.insertSegment(withTitle: appearance.russionText,
                                         at: appearance.rusControl, animated: false)
    letterSegmentedControl.insertSegment(withTitle: appearance.englishText,
                                         at: appearance.engControl, animated: false)
    letterSegmentedControl.selectedSegmentIndex = appearance.rusControl
  }
  
  @objc
  private func generateButtonAction() {
    let appearance = Appearance()
    
    if letterSegmentedControl.selectedSegmentIndex == appearance.rusControl {
      output?.generateRusButtonAction()
      return
    }
    
    if letterSegmentedControl.selectedSegmentIndex == appearance.engControl {
      output?.generateEngButtonAction()
      return
    }
  }
  
  private func setupConstraints() {
    let appearance = Appearance()
    
    [resultLabel, scrollResult, generateButton, letterSegmentedControl].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.middleHorizontalSize),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.middleHorizontalSize),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.middleHorizontalSize),
      
      letterSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: appearance.middleHorizontalSize),
      letterSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -appearance.middleHorizontalSize),
      letterSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      
      scrollResult.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollResult.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollResult.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                           constant: -appearance.lessVerticalSpacing)
    ])
  }
}

// MARK: - private LetterScreenView

private extension LetterScreenView {
  struct Appearance {
    let textButton = NSLocalizedString("Сгенерировать букву", comment: "")
    let russionText = NSLocalizedString("Русские буквы", comment: "")
    let englishText = NSLocalizedString("Английские буквы", comment: "")
    let lessVerticalSpacing: CGFloat = 8
    let middleHorizontalSize: CGFloat = 16
    let highVirticalSize: CGFloat = 24
    let engControl: Int = 1
    let rusControl: Int = 0
  }
}

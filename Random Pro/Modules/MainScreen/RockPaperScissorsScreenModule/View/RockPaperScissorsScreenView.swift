//
//  RockPaperScissorsScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol RockPaperScissorsScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку
  func generateButtonAction()
}

/// События которые отправляем от Presenter ко View
protocol RockPaperScissorsScreenViewInput {
  
  ///  Обновить контент
  ///  - Parameters:
  ///   - leftSideModel: отображение результата генерации слева
  ///   - rightSideModel:  отображение результата генерации справа
  func updateContentWith(leftSideModel: RockPaperScissorsScreenModel,
                         rightSideModel: RockPaperScissorsScreenModel)
  
  /// Сброс текущей генерации на начальную
  func resetCurrentGeneration()
}

typealias RockPaperScissorsScreenViewProtocol = UIView & RockPaperScissorsScreenViewInput

final class RockPaperScissorsScreenView: RockPaperScissorsScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: RockPaperScissorsScreenViewOutput?
  
  // MARK: - Private properties
  
  private let generateButton = ButtonView()
  private let resultLabel = UILabel()
  private let rightResultEmojiLabel = UILabel()
  private let leftResultEmojiLabel = UILabel()
  
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
  
  func updateContentWith(leftSideModel: RockPaperScissorsScreenModel,
                         rightSideModel: RockPaperScissorsScreenModel) {
    resultLabel.text = "\(leftSideModel.title) / \(rightSideModel.title)"
    rightResultEmojiLabel.text = rightSideModel.emoji
    leftResultEmojiLabel.text = leftSideModel.emoji
  }
  
  func resetCurrentGeneration() {
    rightResultEmojiLabel.text = "?"
    leftResultEmojiLabel.text = "?"
    resultLabel.text = ""
  }
}

// MARK: - Private

private extension RockPaperScissorsScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
    resultLabel.font = RandomFont.primaryMedium24
    resultLabel.textAlignment = .center
    
    leftResultEmojiLabel.text = appearance.questionTitle
    leftResultEmojiLabel.font = .systemFont(ofSize: appearance.systemFont)
    
    rightResultEmojiLabel.text = appearance.questionTitle
    rightResultEmojiLabel.font = .systemFont(ofSize: appearance.systemFont)
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
  }
  
  @objc func generateButtonAction() {
    output?.generateButtonAction()
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [resultLabel, leftResultEmojiLabel, rightResultEmojiLabel, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      resultLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                       constant: appearance.maxInset),
      
      leftResultEmojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -72),
      leftResultEmojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      leftResultEmojiLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2, constant: 0),
      
      rightResultEmojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 72),
      rightResultEmojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      rightResultEmojiLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2, constant: 0),

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

private extension RockPaperScissorsScreenView {
  struct Appearance {
    let buttonTitle = NSLocalizedString("Cгенерировать", comment: "")
    let questionTitle = "?"
    let systemFont: CGFloat = 120
    let defaultInset: CGFloat = 16
    let maxInset: CGFloat = 48
  }
}

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
  ///  - displayingGenerationResultOnLeft: отображение результата генерации слева
  ///  - displayingGenerationResultOnRight: отображение результата генерации справа
  func updateContentWith(displayingGenerationResultOnLeft: RockPaperScissorsScreenModel,
                         displayingGenerationResultOnRight: RockPaperScissorsScreenModel)
  
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
  
  func updateContentWith(displayingGenerationResultOnLeft: RockPaperScissorsScreenModel,
                         displayingGenerationResultOnRight: RockPaperScissorsScreenModel) {
    resultLabel.text = "\(displayingGenerationResultOnLeft.title) / \(displayingGenerationResultOnRight.title)"
    rightResultEmojiLabel.text = displayingGenerationResultOnRight.emoji
    leftResultEmojiLabel.text = displayingGenerationResultOnLeft.emoji
  }
  
  func resetCurrentGeneration() {
    rightResultEmojiLabel.text = "?"
    leftResultEmojiLabel.text = "?"
    resultLabel.text = nil
  }
}

// MARK: - Private

private extension RockPaperScissorsScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
    resultLabel.font = RandomFont.primaryMedium24
    resultLabel.textAlignment = .center
    
    leftResultEmojiLabel.text = appearance.questionLabel
    leftResultEmojiLabel.font = .systemFont(ofSize: appearance.systemFont)
    
    rightResultEmojiLabel.text = appearance.questionLabel
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
                                       constant: appearance.upperResultInsert),
      
      leftResultEmojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: appearance.lateralInsert),
      leftResultEmojiLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                constant: appearance.upperInsert),
      leftResultEmojiLabel.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                                   constant: -appearance.maximumInset),

      rightResultEmojiLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                      constant: -appearance.lateralInsert),
      rightResultEmojiLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                 constant: appearance.upperInsert),
      rightResultEmojiLabel.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                                    constant: -appearance.maximumInset),
      
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
    let questionLabel = "?"
    let systemFont: CGFloat = 120
    let defaultInset: CGFloat = 16
    let maximumInset: CGFloat = 80
    let lateralInsert: CGFloat = 48
    let upperInsert: CGFloat = 60
    let upperResultInsert: CGFloat = 48
  }
}

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
  ///   - model: модель RockPaperScissorsScreenModel
  func updateContentWith(model: RockPaperScissorsScreenModel)
  
  /// Сброс текущей генерации на начальную
  func resetCurrentGeneration()
}

typealias RockPaperScissorsScreenViewProtocol = UIView & RockPaperScissorsScreenViewInput

final class RockPaperScissorsScreenView: RockPaperScissorsScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: RockPaperScissorsScreenViewOutput?
  
  // MARK: - Private properties
  
  private let generateButton = ButtonView()
  private let scoreLabel = UILabel()
  private let resultImageLeftLabel = UILabel()
  private let resultImageRightLabel = UILabel()
  private let rightImageView = UIImageView()
  private let leftImageView = UIImageView()
  
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
  
  func updateContentWith(model: RockPaperScissorsScreenModel) {
    scoreLabel.text = model.result
    resultImageLeftLabel.text = model.leftSideScreen.title
    resultImageRightLabel.text = model.rightSideScreen.title
    
    switch model.leftSideScreen {
    case let .rock(imageData):
      let image = UIImage(data: imageData ?? Data())
      leftImageView.image = image
    case let .paper(imageData):
      let image = UIImage(data: imageData ?? Data())
      leftImageView.image = image
    case let .scissors(imageData):
      let image = UIImage(data: imageData ?? Data())
      leftImageView.image = image
    }
    
    switch model.rightSideScreen {
    case let .rock(imageData):
      let image = UIImage(data: imageData ?? Data())
      rightImageView.image = image
    case let .paper(imageData):
      let image = UIImage(data: imageData ?? Data())
      rightImageView.image = image
    case let .scissors(imageData):
      let image = UIImage(data: imageData ?? Data())
      rightImageView.image = image
    }
  }
  
  func resetCurrentGeneration() {
    rightImageView.image = nil
    leftImageView.image = nil
    scoreLabel.text = nil
  }
}

// MARK: - Private

private extension RockPaperScissorsScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
    scoreLabel.font = .systemFont(ofSize: appearance.systemFontScore)
    
    resultImageLeftLabel.textAlignment = .center
    resultImageLeftLabel.font = .systemFont(ofSize: appearance.systemFont)
    
    resultImageRightLabel.textAlignment = .center
    resultImageRightLabel.font = .systemFont(ofSize: appearance.systemFont)

    leftImageView.contentMode = .scaleAspectFill

    rightImageView.contentMode = .scaleAspectFill
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
  }
  
  @objc func generateButtonAction() {
    output?.generateButtonAction()
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [scoreLabel, leftImageView, rightImageView,
     resultImageLeftLabel, resultImageRightLabel, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor,
                                          constant: -appearance.maxInset),
      scoreLabel.heightAnchor.constraint(equalTo: heightAnchor,
                                         multiplier: appearance.scoreMultiplierHeight,
                                         constant: .zero),
      
      leftImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: -appearance.centerXInset),
      leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      leftImageView.heightAnchor.constraint(equalTo: heightAnchor,
                                                   multiplier: appearance.multiplierHeight,
                                                  constant: .zero),
      
      rightImageView.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                     constant: appearance.centerXInset),
      rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      rightImageView.heightAnchor.constraint(equalTo: heightAnchor,
                                                    multiplier: appearance.multiplierHeight,
                                                   constant: .zero),
      
      resultImageLeftLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: appearance.minInset),
      resultImageLeftLabel.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                constant: -appearance.centerXInset),
      resultImageLeftLabel.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                                   constant: -appearance.defaultInset),
      
      resultImageRightLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: appearance.minInset),
      resultImageRightLabel.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                constant: appearance.centerXInset),
      resultImageRightLabel.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                                    constant: -appearance.defaultInset),

      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.minInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.minInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.minInset)
    ])
  }
}

// MARK: - Appearance

private extension RockPaperScissorsScreenView {
  struct Appearance {
    let buttonTitle = NSLocalizedString("Cгенерировать", comment: "")
    let systemFont: CGFloat = 30
    let systemFontScore: CGFloat = 100
    let minInset: CGFloat = 16
    let maxInset: CGFloat = 200
    let defaultInset: CGFloat = 120
    let centerXInset: CGFloat = 96
    let multiplierHeight: Double = 0.1
    let scoreMultiplierHeight: Double = 0.5
  }
}

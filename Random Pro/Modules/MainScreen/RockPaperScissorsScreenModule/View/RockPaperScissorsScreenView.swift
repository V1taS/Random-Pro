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
  
  /// Сброс текущей генерации на начальную
  func resetGeneration()
}

/// События которые отправляем от Presenter ко View
protocol RockPaperScissorsScreenViewInput {
  
  ///  Обновить контент
  ///  - Parameters:
  ///   - model: модель с данными
  ///   - style: Светлая или Темная тема
  func updateContentWith(model: RockPaperScissorsScreenModel,
                         style: UIUserInterfaceStyle)
  
  /// Сброс текущей генерации на начальную
  func resetGeneration()
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
  private var interfaceStyle: UIUserInterfaceStyle?
  
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
  
  func updateContentWith(model: RockPaperScissorsScreenModel,
                         style: UIUserInterfaceStyle) {
    let appearance = Appearance()
    interfaceStyle = style
    scoreLabel.text = model.resultTitle
    resultImageLeftLabel.text = model.leftSide.handsType.title
    resultImageRightLabel.text = model.rightSide.handsType.title
    
    switch model.leftSide.handsType {
    case .rock:
      leftImageView.image = UIImage(named: appearance.rockLeftImageName)
    case .paper:
      leftImageView.image = UIImage(named: appearance.paperLeftImageName)
    case .scissors:
      leftImageView.image = UIImage(named: appearance.scissorsLeftImageName)
    }
    
    switch model.rightSide.handsType {
    case .rock:
      rightImageView.image = UIImage(named: appearance.rockRightImageName)
    case .paper:
      rightImageView.image = UIImage(named: appearance.paperRightImageName)
    case .scissors:
      rightImageView.image = UIImage(named: appearance.scissorsRightImageName)
    }
    
    if style == .dark {
      leftImageView.setImageColor(color: RandomColor.only.primaryWhite)
      rightImageView.setImageColor(color: RandomColor.only.primaryWhite)
    }
    
    if model.resultType == .initial {
      resultImageLeftLabel.text = nil
      resultImageRightLabel.text = nil
    }
  }
  
  func resetGeneration() {
    output?.resetGeneration()
  }
}

// MARK: - Private

private extension RockPaperScissorsScreenView {
  func startShakeHands() {
    let appearance = Appearance()
    generateButton.set(isEnabled: false)
    resultImageLeftLabel.text = nil
    resultImageRightLabel.text = nil
    leftImageView.image = UIImage(named: appearance.rockLeftImageName)
    rightImageView.image = UIImage(named: appearance.rockRightImageName)
    
    shakeHandsFor(view: leftImageView, completion: {})
    shakeHandsFor(view: rightImageView, completion: { [weak self] in
      self?.output?.generateButtonAction()
      self?.generateButton.set(isEnabled: true)
    })
    
    if let interfaceStyle, interfaceStyle == .dark {
      leftImageView.setImageColor(color: RandomColor.only.primaryWhite)
      rightImageView.setImageColor(color: RandomColor.only.primaryWhite)
    }
  }
  
  func shakeHandsFor(view: UIView, completion: @escaping (() -> Void)) {
    CATransaction.begin()
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.2
    animation.repeatCount = 2
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x,
                                                   y: view.center.y - 10))
    animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x,
                                                 y: view.center.y + 10))
    CATransaction.setCompletionBlock(completion)
    view.layer.add(animation, forKey: "position")
    CATransaction.commit()
  }
  
  func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    scoreLabel.font = .systemFont(ofSize: appearance.systemFontScore)
    
    resultImageLeftLabel.textAlignment = .center
    resultImageLeftLabel.font = .systemFont(ofSize: appearance.systemFontLabel)
    
    resultImageRightLabel.textAlignment = .center
    resultImageRightLabel.font = .systemFont(ofSize: appearance.systemFontLabel)
    
    leftImageView.contentMode = .scaleAspectFit
    rightImageView.contentMode = .scaleAspectFit
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
  }
  
  @objc func generateButtonAction() {
    startShakeHands()
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
      
      leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                             constant: 24),
      leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      leftImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.4),
      
      rightImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -24),
      rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      rightImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.4),
      
      resultImageLeftLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: appearance.defaultInset),
      resultImageLeftLabel.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                    constant: -appearance.centerXInset),
      resultImageLeftLabel.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                                   constant: -appearance.fromTopInset),
      
      resultImageRightLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                     constant: appearance.defaultInset),
      resultImageRightLabel.centerXAnchor.constraint(equalTo: centerXAnchor,
                                                     constant: appearance.centerXInset),
      resultImageRightLabel.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                                    constant: -appearance.fromTopInset),
      
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
    let systemFontLabel: CGFloat = 30
    let systemFontScore: CGFloat = 100
    let defaultInset: CGFloat = 16
    let maxInset: CGFloat = 200
    let fromTopInset: CGFloat = 120
    let centerXInset: CGFloat = 96
    let multiplierHeight: Double = 0.1
    let scoreMultiplierHeight: Double = 0.5
    
    let rockLeftImageName = "rock_left"
    let paperLeftImageName = "paper_left"
    let scissorsLeftImageName = "scissors_left"
    
    let rockRightImageName = "rock_right"
    let paperRightImageName = "paper_right"
    let scissorsRightImageName = "scissors_right"
  }
}

//
//  RockPaperScissorsScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit
import Lottie

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
  
  private let leftYouWinAnimationView = LottieAnimationView(name: Appearance().youWinImage)
  private let rightYouWinAnimationView = LottieAnimationView(name: Appearance().youWinImage)
  private let handShakeAnimationView = LottieAnimationView(name: Appearance().handShakeImage)
  
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
    
    switch model.resultType {
    case .winLeftSide:
      startLeftYouWinAnimation()
    case .winRightSide:
      startRightYouWinAnimation()
    case .draw:
      startHandShakeAnimation()
    case .initial:
      resultImageLeftLabel.text = nil
      resultImageRightLabel.text = nil
    }
    generateButton.set(isEnabled: true)
  }
  
  func resetGeneration() {
    output?.resetGeneration()
    stopHandShakeAnimation()
    stopLeftYouWinAnimation()
    stopRightYouWinAnimation()
  }
}

// MARK: - Private

private extension RockPaperScissorsScreenView {
  func startHandShakeAnimation() {
    // Выключаю часть функционала, что бы apple не считал это азартной игрой
//    handShakeAnimationView.isHidden = false
//    handShakeAnimationView.play()
  }
  
  func stopHandShakeAnimation() {
    // Выключаю часть функционала, что бы apple не считал это азартной игрой
//    handShakeAnimationView.isHidden = true
//    handShakeAnimationView.stop()
  }
  
  func startLeftYouWinAnimation() {
    // Выключаю часть функционала, что бы apple не считал это азартной игрой
//    leftYouWinAnimationView.isHidden = false
//    leftYouWinAnimationView.play()
  }
  
  func stopLeftYouWinAnimation() {
    // Выключаю часть функционала, что бы apple не считал это азартной игрой
//    leftYouWinAnimationView.isHidden = true
//    leftYouWinAnimationView.stop()
  }
  
  func startRightYouWinAnimation() {
    // Выключаю часть функционала, что бы apple не считал это азартной игрой
//    rightYouWinAnimationView.isHidden = false
//    rightYouWinAnimationView.play()
  }
  
  func stopRightYouWinAnimation() {
    // Выключаю часть функционала, что бы apple не считал это азартной игрой
//    rightYouWinAnimationView.isHidden = true
//    rightYouWinAnimationView.stop()
  }
  
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
    
    // Выключаю часть функционала, что бы apple не считал это азартной игрой
    scoreLabel.isHidden = true
    leftImageView.isHidden = true
    leftYouWinAnimationView.isHidden = true
    resultImageLeftLabel.isHidden = true
    rightYouWinAnimationView.isHidden = true
    
    resultImageLeftLabel.textAlignment = .center
    resultImageLeftLabel.font = .systemFont(ofSize: appearance.systemFontLabel)
    
    resultImageRightLabel.textAlignment = .center
    resultImageRightLabel.font = .systemFont(ofSize: appearance.systemFontLabel)
    
    leftImageView.contentMode = .scaleAspectFit
    leftImageView.scalesLargeContentImage = true
    leftImageView.clipsToBounds = true
    
    rightImageView.contentMode = .scaleAspectFit
    rightImageView.scalesLargeContentImage = true
    rightImageView.clipsToBounds = true

    leftYouWinAnimationView.contentMode = .scaleAspectFill
    leftYouWinAnimationView.loopMode = .playOnce
    leftYouWinAnimationView.animationSpeed = Appearance().animationSpeed
    
    rightYouWinAnimationView.contentMode = .scaleAspectFill
    rightYouWinAnimationView.loopMode = .playOnce
    rightYouWinAnimationView.animationSpeed = Appearance().animationSpeed
    
    handShakeAnimationView.isHidden = true
    handShakeAnimationView.contentMode = .scaleAspectFill
    handShakeAnimationView.loopMode = .playOnce
    handShakeAnimationView.animationSpeed = 1
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [scoreLabel, leftImageView, rightImageView, resultImageLeftLabel, resultImageRightLabel, generateButton,
     leftYouWinAnimationView, rightYouWinAnimationView, handShakeAnimationView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      scoreLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                      constant: UIScreen.main.bounds.height * 0.1),
      
      leftYouWinAnimationView.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor,
                                                        constant: 40),
      leftYouWinAnimationView.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor,
                                                      constant: 40),
      leftYouWinAnimationView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2),
      leftYouWinAnimationView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2),
      
      rightYouWinAnimationView.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor,
                                                        constant: -40),
      rightYouWinAnimationView.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor,
                                                       constant: 40),
      rightYouWinAnimationView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2),
      rightYouWinAnimationView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2),
      
      handShakeAnimationView.centerXAnchor.constraint(equalTo: scoreLabel.centerXAnchor),
      handShakeAnimationView.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor,
                                                     constant: 52),
      handShakeAnimationView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.3),
      handShakeAnimationView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.3),
      
      leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                             constant: 24),
      leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      leftImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.4),
      leftImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.4),
      
      rightImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
      rightImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.6),
      rightImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.6),
      
      resultImageLeftLabel.centerXAnchor.constraint(equalTo: leftImageView.centerXAnchor),
      resultImageLeftLabel.topAnchor.constraint(equalTo: leftImageView.bottomAnchor,
                                                constant: 16),
      
      resultImageRightLabel.centerXAnchor.constraint(equalTo: rightImageView.centerXAnchor),
      resultImageRightLabel.topAnchor.constraint(equalTo: rightImageView.bottomAnchor,
                                                     constant: 16),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset)
    ])
  }
  
  @objc func generateButtonAction() {
    startShakeHands()
    stopLeftYouWinAnimation()
    stopRightYouWinAnimation()
    stopHandShakeAnimation()
  }
}

// MARK: - Appearance

private extension RockPaperScissorsScreenView {
  struct Appearance {
    let buttonTitle = RandomStrings.Localizable.generate
    let systemFontLabel: CGFloat = 30
    let systemFontScore: CGFloat = 100
    let defaultInset: CGFloat = 16
    let maxInset: CGFloat = 200
    let fromTopInset: CGFloat = 120
    let centerXInset: CGFloat = 96
    
    let rockLeftImageName = RandomAsset.rockLeft.name
    let paperLeftImageName = RandomAsset.paperLeft.name
    let scissorsLeftImageName = RandomAsset.scissorsLeft.name
    
    let rockRightImageName = RandomAsset.rockRight.name
    let paperRightImageName = RandomAsset.paperRight.name
    let scissorsRightImageName = RandomAsset.scissorsRight.name
    let youWinImage = RandomAsset.rockPaperScissosCupWinner.name
    let handShakeImage = RandomAsset.rockPaperScissosHandShake.name
    let animationSpeed: CGFloat = 0.5
  }
}

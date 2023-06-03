//
//  RiddlesScreenView.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//

import UIKit
import RandomUIKit
import Lottie

/// События которые отправляем из View в Presenter
protocol RiddlesScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку генерации имени
  func generateButtonAction()
  
  /// Было нажатие на результат генерации
  func resultLabelAction()
  
  /// Тип сложности изменился
  /// - Parameter type: Тип
  func segmentedControlValueDidChange(type: RiddlesScreenModel.DifficultType)
}

/// События которые отправляем от Presenter ко View
protocol RiddlesScreenViewInput {
  
  /// Устанавливаем данные в result
  ///  - Parameters:
  ///   - riddles: результат генерации
  ///   - type: Тип поздравления
  func set(riddles: RiddlesScreenModel.Riddles,
           type: RiddlesScreenModel.DifficultType)
  
  /// Запустить доадер
  func startLoader()
  
  /// Остановить лоадер
  func stopLoader()
}

/// Псевдоним протокола UIView & RiddlesScreenViewInput
typealias RiddlesScreenViewProtocol = UIView & RiddlesScreenViewInput

/// View для экрана
final class RiddlesScreenView: RiddlesScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: RiddlesScreenViewOutput?
  
  // MARK: - Private properties
  
  private let resultLabel = UILabel()
  private let generateButton = ButtonView()
  private let lottieAnimationView = LottieAnimationView(name: Appearance().loaderImage)
  private let segmentedControl = UISegmentedControl()
  private var isResultAnimate = true
  private var listDifficultType = RiddlesScreenModel.DifficultType.allCases
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func set(riddles: RiddlesScreenModel.Riddles,
           type: RiddlesScreenModel.DifficultType) {
    let fontSize = Appearance().result == riddles.question ? RandomFont.primaryBold50 : RandomFont.primaryBold24
    resultLabel.font = fontSize
    resultLabel.text = riddles.question
    
    if isResultAnimate {
      resultLabel.zoomIn(duration: Appearance().resultDuration,
                         transformScale: CGAffineTransform(scaleX: .zero, y: .zero))
    }
    
    guard listDifficultType.indices.contains(segmentedControl.selectedSegmentIndex) else {
      return
    }
    let currentSegmentedControl = listDifficultType[segmentedControl.selectedSegmentIndex]
    guard currentSegmentedControl != type else {
      return
    }
    segmentedControl.selectedSegmentIndex = type.index
  }
  
  func startLoader() {
    lottieAnimationView.isHidden = false
    lottieAnimationView.play()
    generateButton.set(isEnabled: false)
  }
  
  func stopLoader() {
    lottieAnimationView.isHidden = true
    lottieAnimationView.stop()
    generateButton.set(isEnabled: true)
  }
}

// MARK: - Private

private extension RiddlesScreenView {
  func configureLayout() {
    let appearance = Appearance()
    
    [resultLabel, segmentedControl, generateButton, lottieAnimationView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.defaultInset),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.defaultInset),
      
      segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: appearance.defaultInset),
      segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -appearance.defaultInset),
      segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                            constant: appearance.defaultInset / 2),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset),
      
      lottieAnimationView.centerXAnchor.constraint(equalTo: centerXAnchor),
      lottieAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor),
      lottieAnimationView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    resultLabel.font = RandomFont.primaryBold24
    resultLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = .zero
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self,
                             action: #selector(generateButtonAction),
                             for: .touchUpInside)
    
    listDifficultType.forEach {
      segmentedControl.insertSegment(withTitle: $0.title,
                                     at: $0.index,
                                     animated: false)
    }
    
    segmentedControl.selectedSegmentIndex = .zero
    segmentedControl.addTarget(self,
                               action: #selector(segmentedControlValueDidChange),
                               for: .valueChanged)
    
    lottieAnimationView.isHidden = true
    lottieAnimationView.contentMode = .scaleAspectFit
    lottieAnimationView.loopMode = .loop
    lottieAnimationView.animationSpeed = Appearance().animationSpeed
    
    let resultLabelAction = UITapGestureRecognizer(target: self,
                                                   action: #selector(resultAction))
    resultLabelAction.cancelsTouchesInView = false
    resultLabel.addGestureRecognizer(resultLabelAction)
    resultLabel.isUserInteractionEnabled = true
  }
  
  @objc
  func segmentedControlValueDidChange() {
    isResultAnimate = false
    
    guard listDifficultType.indices.contains(segmentedControl.selectedSegmentIndex) else {
      return
    }
    let currentSegmentedControl = listDifficultType[segmentedControl.selectedSegmentIndex]
    output?.segmentedControlValueDidChange(type: currentSegmentedControl)
  }
  
  @objc
  func resultAction() {
    output?.resultLabelAction()
  }
  
  @objc
  func generateButtonAction() {
    isResultAnimate = true
    output?.generateButtonAction()
  }
}

// MARK: - Appearance

private extension RiddlesScreenView {
  struct Appearance {
    let buttonTitle = RandomStrings.Localizable.generate
    let loaderImage = RandomAsset.filmsLoader.name
    
    let animationSpeed: CGFloat = 0.5
    let defaultInset: CGFloat = 16
    let resultDuration: CGFloat = 0.2
    let result = "?"
  }
}

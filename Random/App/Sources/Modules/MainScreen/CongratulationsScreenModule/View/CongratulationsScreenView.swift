//
//  CongratulationsScreenView.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import UIKit
import FancyUIKit
import FancyStyle
import Lottie

/// События которые отправляем из View в Presenter
protocol CongratulationsScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку генерации поздравления
  func generateButtonAction()
  
  /// Было нажатие на результат генерации
  func resultLabelAction()
  
  /// Тип поздравления изменился
  /// - Parameter type: Тип поздравления
  func segmentedControlValueDidChange(type: CongratulationsScreenModel.CongratulationsType)
}

/// События которые отправляем от Presenter ко View
protocol CongratulationsScreenViewInput {
  
  /// Устанавливаем данные в result
  ///  - Parameters:
  ///   - result: результат генерации
  ///   - type: Тип поздравления
  func set(result: String?, type: CongratulationsScreenModel.CongratulationsType)
  
  /// Запустить лоадер
  func startLoader()
  
  /// Остановить лоадер
  func stopLoader()
}

/// Псевдоним протокола UIView & CongratulationsScreenViewInput
typealias CongratulationsScreenViewProtocol = UIView & CongratulationsScreenViewInput

/// View для экрана
final class CongratulationsScreenView: CongratulationsScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: CongratulationsScreenViewOutput?
  
  // MARK: - Private properties
  
  private let resultLabel = UILabel()
  private let segmentedControl = UISegmentedControl()
  private let generateButton = ButtonView()
  private let lottieAnimationView = LottieAnimationView(name: Appearance().loaderImage)
  private var isResultAnimate = true
  private var listCongratulations = CongratulationsScreenModel.CongratulationsType.allCases
  
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
  
  func set(result: String?, type: CongratulationsScreenModel.CongratulationsType) {
    let fontSize = Appearance().result == result ? RandomFont.primaryBold50 : RandomFont.primaryBold24
    resultLabel.font = fontSize
    resultLabel.text = result
    
    if isResultAnimate {
      resultLabel.zoomIn(duration: Appearance().resultDuration,
                         transformScale: CGAffineTransform(scaleX: .zero, y: .zero))
    }
    
    guard listCongratulations.indices.contains(segmentedControl.selectedSegmentIndex) else {
      return
    }
    let currentSegmentedControl = listCongratulations[segmentedControl.selectedSegmentIndex]
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

private extension CongratulationsScreenView {
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
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    
    resultLabel.font = RandomFont.primaryBold24
    resultLabel.textColor = fancyColor.darkAndLightTheme.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = .zero
    
    listCongratulations.forEach {
      segmentedControl.insertSegment(withTitle: $0.title,
                                     at: $0.index,
                                     animated: false)
    }
    
    segmentedControl.selectedSegmentIndex = .zero
    segmentedControl.addTarget(self,
                               action: #selector(segmentedControlValueDidChange),
                               for: .valueChanged)
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self,
                             action: #selector(generateButtonAction),
                             for: .touchUpInside)
    
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
    
    guard listCongratulations.indices.contains(segmentedControl.selectedSegmentIndex) else {
      return
    }
    let currentSegmentedControl = listCongratulations[segmentedControl.selectedSegmentIndex]
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

private extension CongratulationsScreenView {
  struct Appearance {
    let buttonTitle = RandomStrings.Localizable.generate
    let loaderImage = RandomAsset.filmsLoader.name
    
    let animationSpeed: CGFloat = 0.5
    let defaultInset: CGFloat = 16
    let resultDuration: CGFloat = 0.2
    let result = "?"
  }
}

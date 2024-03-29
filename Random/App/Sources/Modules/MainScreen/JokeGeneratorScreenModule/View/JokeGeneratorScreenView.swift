//
//  JokeGeneratorScreenView.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//

import UIKit
import FancyUIKit
import FancyStyle
import Lottie

/// События которые отправляем из View в Presenter
protocol JokeGeneratorScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку
  func generateButtonAction()
  
  /// Было нажатие на результат генерации
  func resultLabelAction()
}

/// События которые отправляем от Presenter ко View
protocol JokeGeneratorScreenViewInput {
  
  /// Устанавливаем данные в result
  ///  - Parameter result: результат генерации
  func set(result: String?)
  
  /// Запустить лоадер
  func startLoader()
  
  /// Остановить лоадер
  func stopLoader()
}

/// Псевдоним протокола UIView & JokeGeneratorScreenViewInput
typealias JokeGeneratorScreenViewProtocol = UIView & JokeGeneratorScreenViewInput

/// View для экрана
final class JokeGeneratorScreenView: JokeGeneratorScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: JokeGeneratorScreenViewOutput?
  
  // MARK: - Private properties
  
  private let resultLabel = UILabel()
  private let generateButton = ButtonView()
  private let lottieAnimationView = LottieAnimationView(name: Appearance().loaderImage)
  
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
  
  func set(result: String?) {
    let fontSize = Appearance().result == result ? fancyFont.primaryBold50 : fancyFont.primaryBold24
    resultLabel.font = fontSize
    resultLabel.text = result
    
    resultLabel.zoomIn(duration: Appearance().resultDuration,
                       transformScale: CGAffineTransform(scaleX: .zero, y: .zero))
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

private extension JokeGeneratorScreenView {
  func configureLayout() {
    let appearance = Appearance()
    
    [resultLabel, generateButton, lottieAnimationView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.defaultInset),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.defaultInset),
      
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
    
    resultLabel.font = fancyFont.primaryBold24
    resultLabel.textColor = fancyColor.darkAndLightTheme.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = .zero
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self,
                             action: #selector(generateButtonAction),
                             for: .touchUpInside)
    
    lottieAnimationView.isHidden = true
    lottieAnimationView.contentMode = .scaleAspectFit
    lottieAnimationView.loopMode = .loop
    lottieAnimationView.animationSpeed = Appearance().animationSpeed
    
    let resultLabelAction = UITapGestureRecognizer(target: self, action: #selector(resultAction))
    resultLabelAction.cancelsTouchesInView = false
    resultLabel.addGestureRecognizer(resultLabelAction)
    resultLabel.isUserInteractionEnabled = true
  }
  
  @objc
  func resultAction() {
    output?.resultLabelAction()
  }
  
  @objc
  func generateButtonAction() {
    output?.generateButtonAction()
  }
}

// MARK: - Appearance

private extension JokeGeneratorScreenView {
  struct Appearance {
    let buttonTitle = RandomStrings.Localizable.generate
    let loaderImage = RandomAsset.filmsLoader.name
    let animationSpeed: CGFloat = 0.5
    let defaultInset: CGFloat = 16
    let resultDuration: CGFloat = 0.2
    let result = "?"
  }
}

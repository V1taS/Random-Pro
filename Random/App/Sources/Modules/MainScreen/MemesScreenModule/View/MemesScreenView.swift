//
//  MemesScreenView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//

import UIKit
import RandomUIKit
import Lottie

/// События которые отправляем из View в Presenter
protocol MemesScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку
  func generateButtonAction()
  
  /// Что-то пошло не так
  func somethingWentWrong()
}

/// События которые отправляем от Presenter ко View
protocol MemesScreenViewInput {
  
  /// Устанавливаем данные в result
  ///  - Parameter result: результат генерации
  func set(result: Data?)
  
  /// Запустить доадер
  func startLoader()
  
  /// Остановить лоадер
  func stopLoader()
}

/// Псевдоним протокола UIView & MemesScreenViewInput
typealias MemesScreenViewProtocol = UIView & MemesScreenViewInput

/// View для экрана
final class MemesScreenView: MemesScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: MemesScreenViewOutput?
  
  // MARK: - Private properties
  
  private let resultMemes = UIImageView()
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
  
  func set(result: Data?) {
    UIView.animate(withDuration: Appearance().resultDuration) { [weak self] in
      guard let self, let result else {
        self?.output?.somethingWentWrong()
        return
      }
      
      let image = UIImage(data: result)
      self.resultMemes.image = image
      
      image?.getAverageColor { [weak self] averageColor in
        UIView.animate(withDuration: Appearance().resultDuration) { [weak self] in
          self?.backgroundColor = averageColor
        }
      }
    }
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

private extension MemesScreenView {
  func configureLayout() {
    let appearance = Appearance()
    
    [resultMemes, generateButton, lottieAnimationView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultMemes.centerYAnchor.constraint(equalTo: centerYAnchor),
      resultMemes.leadingAnchor.constraint(equalTo: leadingAnchor),
      resultMemes.trailingAnchor.constraint(equalTo: trailingAnchor),
      
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
    
    resultMemes.contentMode = .scaleAspectFit
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self,
                             action: #selector(generateButtonAction),
                             for: .touchUpInside)
    
    lottieAnimationView.isHidden = true
    lottieAnimationView.contentMode = .scaleAspectFit
    lottieAnimationView.loopMode = .loop
    lottieAnimationView.animationSpeed = Appearance().animationSpeed
  }
  
  @objc
  func generateButtonAction() {
    output?.generateButtonAction()
  }
}

// MARK: - Appearance

private extension MemesScreenView {
  struct Appearance {
    let buttonTitle = RandomStrings.Localizable.generate
    let loaderImage = RandomAsset.filmsLoader.name
    let animationSpeed: CGFloat = 0.5
    let defaultInset: CGFloat = 16
    let resultDuration: CGFloat = 0.2
  }
}

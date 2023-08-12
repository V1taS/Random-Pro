//
//  NickNameScreenView.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit
import FancyUIKit
import FancyStyle
import Lottie

/// События которые отправляем из View в Presenter
protocol NickNameScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку и происходит генерация 'Коротких никнеймов'
  func generateShortButtonAction()
  
  /// Пользователь нажал на кнопку и происходит генерация  'Популярных никнеймов'
  func generatePopularButtonAction()
  
  /// Было нажатие на результат генерации
  func resultLabelAction()
}

/// События которые отправляем от Presenter ко View
protocol NickNameScreenViewInput {
  
  /// Устанавливаем данные в result
  ///  - Parameter result: результат генерации
  func set(result: String?)
  
  /// Запустить доадер
  func startLoader()
  
  /// Остановить лоадер
  func stopLoader()
}

/// Псевдоним протокола UIView & NickNameScreenViewInput
typealias NickNameScreenViewProtocol = UIView & NickNameScreenViewInput

/// View для экрана
final class NickNameScreenView: NickNameScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: NickNameScreenViewOutput?
  
  // MARK: - Private properties
  
  private let resultLabel = UILabel()
  private let segmentedControl = UISegmentedControl()
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

private extension NickNameScreenView {
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
    
    resultLabel.font = RandomFont.primaryBold50
    resultLabel.textColor = fancyColor.darkAndLightTheme.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = appearance.numberOfLines
    
    segmentedControl.insertSegment(withTitle: appearance.shortTitle,
                                   at: appearance.shortTitleIndex, animated: false)
    segmentedControl.insertSegment(withTitle: appearance.popularTitle,
                                   at: appearance.popularTitleIndex, animated: false)
    segmentedControl.selectedSegmentIndex = appearance.shortTitleIndex
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    lottieAnimationView.isHidden = true
    lottieAnimationView.contentMode = .scaleAspectFit
    lottieAnimationView.loopMode = .loop
    lottieAnimationView.animationSpeed = Appearance().animationSpeed
    
    let resultLabelAction = UITapGestureRecognizer(target: self, action: #selector(resultAction))
    resultLabelAction.cancelsTouchesInView = false
    resultLabel.addGestureRecognizer(resultLabelAction)
    resultLabel.isUserInteractionEnabled = true
  }
  
  @objc func resultAction() {
    output?.resultLabelAction()
  }
  
  @objc func generateButtonAction() {
    let appearance = Appearance()
    
    if segmentedControl.selectedSegmentIndex == appearance.shortTitleIndex {
      output?.generateShortButtonAction()
      return
    }
    
    if segmentedControl.selectedSegmentIndex == appearance.popularTitleIndex {
      output?.generatePopularButtonAction()
      return
    }
  }
}

// MARK: - Appearance

private extension NickNameScreenView {
  struct Appearance {
    let shortTitle = RandomStrings.Localizable.short
    let shortTitleIndex = 0
    let popularTitle = RandomStrings.Localizable.popular
    let popularTitleIndex = 1
    let buttonTitle = RandomStrings.Localizable.generate
    let loaderImage = RandomAsset.filmsLoader.name
    let animationSpeed: CGFloat = 0.5
    let defaultInset: CGFloat = 16
    let resultDuration: CGFloat = 0.2
    let numberOfLines: Int = 2
  }
}

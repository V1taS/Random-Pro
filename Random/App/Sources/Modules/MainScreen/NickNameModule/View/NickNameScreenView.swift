//
//  NickNameScreenView.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit
import RandomUIKit
import Lottie

/// События которые отправляем из View в Presenter
protocol NickNameScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку и происходит генерация 'Коротких никнеймов'
  func generateShortButtonAction()
  
  /// Пользователь нажал на кнопку и происходит генерация  'Популярных никнеймов'
  func generatePopularButtonAction()
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
  private let inscriptionsSegmentedControl = UISegmentedControl()
  private let generateButton = ButtonView()
  private let activityIndicator = LottieAnimationView(name: Appearance().loaderImage)
  
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
  }
  
  func startLoader() {
    activityIndicator.isHidden = false
    activityIndicator.play()
  }
  
  func stopLoader() {
    activityIndicator.isHidden = true
    activityIndicator.stop()
  }
}

// MARK: - Private

private extension NickNameScreenView {
  func configureLayout() {
    let appearance = Appearance()
    
    [resultLabel, inscriptionsSegmentedControl, generateButton, activityIndicator].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.defaultInset),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.defaultInset),
      
      inscriptionsSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                            constant: appearance.defaultInset),
      inscriptionsSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                             constant: -appearance.defaultInset),
      inscriptionsSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset),
      
      activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
      activityIndicator.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    resultLabel.font = RandomFont.primaryBold50
    resultLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = 3
    
    inscriptionsSegmentedControl.insertSegment(withTitle: appearance.shortTitle,
                                         at: appearance.shortTitleIndex, animated: false)
    inscriptionsSegmentedControl.insertSegment(withTitle: appearance.popularTitle,
                                         at: appearance.popularTitleIndex, animated: false)
    inscriptionsSegmentedControl.selectedSegmentIndex = appearance.shortTitleIndex
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    activityIndicator.isHidden = true
    activityIndicator.contentMode = .scaleAspectFit
    activityIndicator.loopMode = .loop
    activityIndicator.animationSpeed = Appearance().animationSpeed
  }
  
  @objc func generateButtonAction() {
    let appearance = Appearance()
    
    if inscriptionsSegmentedControl.selectedSegmentIndex == appearance.shortTitleIndex {
      output?.generateShortButtonAction()
      return
    }
    
    if inscriptionsSegmentedControl.selectedSegmentIndex == appearance.popularTitleIndex {
      output?.generatePopularButtonAction()
      return
    }
  }
}

// MARK: - Appearance

private extension NickNameScreenView {
  struct Appearance {
    let shortTitle = "Короткий"
    let shortTitleIndex = 0
    let popularTitle = "Популярный"
    let popularTitleIndex = 1
    let buttonTitle = RandomStrings.Localizable.generate
    let loaderImage = RandomAsset.filmsLoader.name
    let animationSpeed: CGFloat = 0.5
    let defaultInset: CGFloat = 16
  }
}

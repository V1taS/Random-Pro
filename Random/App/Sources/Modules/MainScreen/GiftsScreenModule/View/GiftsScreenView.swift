//
//  GiftsScreenView.swift
//  Random
//
//  Created by Artem Pavlov on 05.06.2023.
//

import UIKit
import FancyUIKit
import FancyStyle
import Lottie

/// События которые отправляем из View в Presenter
protocol GiftsScreenViewOutput: AnyObject {

  /// Пользователь нажал на кнопку генерации подарка
  func generateButtonAction()

  /// Было нажатие на результат генерации
  func resultLabelAction()

  /// Тип пола для кого предназначен подарок изменился
  /// - Parameter type: Пол подарка
  func segmentedControlValueDidChange(type: GiftsScreenModel.Gender)
}

/// События которые отправляем от Presenter ко View
protocol GiftsScreenViewInput {

  /// Устанавливаем данные в result
  ///  - Parameters:
  ///   - result: результат генерации
  ///   - gender: пол подарка
  func set(result: String?, gender: GiftsScreenModel.Gender)

  /// Запустить лоадер
  func startLoader()

  /// Остановить лоадер
  func stopLoader()
}

/// Псевдоним протокола UIView & GiftsScreenViewInput
typealias GiftsScreenViewProtocol = UIView & GiftsScreenViewInput

/// View для экрана
final class GiftsScreenView: GiftsScreenViewProtocol {

  // MARK: - Internal properties
  
  weak var output: GiftsScreenViewOutput?
  
  // MARK: - Private properties

  private let resultLabel = UILabel()
  private let segmentedControl = UISegmentedControl()
  private let generateButton = ButtonView()
  private let lottieAnimationView = LottieAnimationView(name: Appearance().loaderImage)
  private var isResultAnimate = true
  
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

  func set(result: String?, gender: GiftsScreenModel.Gender) {
    resultLabel.text = result

    if isResultAnimate {
      resultLabel.zoomIn(duration: Appearance().resultDuration,
                         transformScale: CGAffineTransform(scaleX: .zero, y: .zero))
    }

    switch gender {
    case .male:
      guard segmentedControl.selectedSegmentIndex != Appearance().maleTitleIndex else {
        return
      }
      segmentedControl.selectedSegmentIndex = Appearance().maleTitleIndex
    case .female:
      guard segmentedControl.selectedSegmentIndex != Appearance().femaleTitleIndex else {
        return
      }
      segmentedControl.selectedSegmentIndex = Appearance().femaleTitleIndex
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

private extension GiftsScreenView {
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

    segmentedControl.insertSegment(withTitle: appearance.maleTitle,
                                   at: appearance.maleTitleIndex,
                                   animated: false)
    segmentedControl.insertSegment(withTitle: appearance.femaleTitle,
                                   at: appearance.femaleTitleIndex,
                                   animated: false)
    segmentedControl.selectedSegmentIndex = appearance.maleTitleIndex
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
    let appearance = Appearance()
    isResultAnimate = false

    if segmentedControl.selectedSegmentIndex == appearance.maleTitleIndex {
      output?.segmentedControlValueDidChange(type: .male)
      return
    }

    if segmentedControl.selectedSegmentIndex == appearance.femaleTitleIndex {
      output?.segmentedControlValueDidChange(type: .female)
      return
    }
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

private extension GiftsScreenView {
  struct Appearance {
    let maleTitle = RandomStrings.Localizable.male
    let maleTitleIndex = 0

    let femaleTitle = RandomStrings.Localizable.female
    let femaleTitleIndex = 1

    let buttonTitle = RandomStrings.Localizable.generate
    let loaderImage = RandomAsset.filmsLoader.name

    let animationSpeed: CGFloat = 0.5
    let defaultInset: CGFloat = 16
    let resultDuration: CGFloat = 0.2
    let result = "?"
  }
}

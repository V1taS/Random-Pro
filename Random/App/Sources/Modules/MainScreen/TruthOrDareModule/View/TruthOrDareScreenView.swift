//
//  TruthOrDareScreenView.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//

import UIKit
import RandomUIKit
import Lottie

/// События которые отправляем из View в Presenter
protocol TruthOrDareScreenViewOutput: AnyObject {

  /// Пользователь нажал на кнопку генерации правды или действия
  func generateButtonAction()

  /// Было нажатие на результат генерации
  func resultLabelAction()

  /// Тип генерации изменился
  /// - Parameter type: тип генерации (правда или действие)
  func segmentedControlValueDidChange(type: TruthOrDareScreenModel.TruthOrDareType)
}

/// События которые отправляем от Presenter ко View
protocol TruthOrDareScreenViewInput {

  /// Устанавливаем данные в result
  ///  - Parameters:
  ///   - result: результат генерации
  ///   - type: тип генерации (правда или действие)
  func set(result: String?, type: TruthOrDareScreenModel.TruthOrDareType)

  /// Запустить доадер
  func startLoader()

  /// Остановить лоадер
  func stopLoader()
}

/// Псевдоним протокола UIView & TruthOrDareScreenViewInput
typealias TruthOrDareScreenViewProtocol = UIView & TruthOrDareScreenViewInput

/// View для экрана
final class TruthOrDareScreenView: TruthOrDareScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: TruthOrDareScreenViewOutput?
  
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

  func set(result: String?, type: TruthOrDareScreenModel.TruthOrDareType) {
    resultLabel.text = result

    if isResultAnimate {
      resultLabel.zoomIn(duration: Appearance().resultDuration,
                         transformScale: CGAffineTransform(scaleX: .zero, y: .zero))
    }

    switch type {
    case .truth:
      guard segmentedControl.selectedSegmentIndex != Appearance().truthTitleIndex else {
        return
      }
      segmentedControl.selectedSegmentIndex = Appearance().truthTitleIndex
    case .dare:
      guard segmentedControl.selectedSegmentIndex != Appearance().dareTitleIndex else {
        return
      }
      segmentedControl.selectedSegmentIndex = Appearance().dareTitleIndex
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

private extension TruthOrDareScreenView {
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

    resultLabel.font = RandomFont.primaryBold50
    resultLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
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

    if segmentedControl.selectedSegmentIndex == appearance.truthTitleIndex {
      output?.segmentedControlValueDidChange(type: .truth)
      return
    }

    if segmentedControl.selectedSegmentIndex == appearance.dareTitleIndex {
      output?.segmentedControlValueDidChange(type: .dare)
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

private extension TruthOrDareScreenView {
  struct Appearance {
    let truthTitle = RandomStrings.Localizable.truth
    let truthTitleIndex = 0

    let dareTitle = RandomStrings.Localizable.dare
    let dareTitleIndex = 1

    let buttonTitle = RandomStrings.Localizable.generate
    let loaderImage = RandomAsset.filmsLoader.name

    let animationSpeed: CGFloat = 0.5
    let defaultInset: CGFloat = 16
    let resultDuration: CGFloat = 0.2
  }
}

//
//  ReferralProgramView.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 25.07.2023.
//

import UIKit
import Lottie
import FancyStyle

/// View для экрана
public final class ReferralProgramView: UIView {
  
  // MARK: - Private property
  
  private let titleLabel = UILabel()
  private let firstStepLabel = UILabel()
  private let linkCopyView = LinkCopyView()
  private let secondStepLabel = UILabel()
  private let circleStepsView = CircleStepsView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - lottieAnimationJSONName: Анимация лотти
  ///  - title: Заголовок
  ///  - firstStepTitle: Описание первого шага
  ///  - link: Ссылка
  ///  - secondStepTitle: Описание второго шага
  ///  - circleStepsTitle: Описание в кружках
  ///  - currentStep: Текущее количество регистраций
  ///  - maxSteps: Максимальное количество регистраций
  ///  - linkAction: Действие по нажатию на кнопку
  public func configureWith(
    lottieAnimationJSONName: String,
    title: String?,
    firstStepTitle: String?,
    link: String?,
    secondStepTitle: String?,
    circleStepsTitle: String,
    currentStep: Int,
    maxSteps: Int = 5,
    linkAction: ((_ link: String?) -> Void)?
  ) {
    let lottieAnimationView = LottieAnimationView(name: lottieAnimationJSONName, bundle: .main)
    lottieAnimationView.contentMode = .scaleAspectFit
    lottieAnimationView.loopMode = .loop
    lottieAnimationView.animationSpeed = Appearance().animationSpeed
    lottieAnimationView.play()
    
    titleLabel.text = title
    firstStepLabel.text = firstStepTitle
    linkCopyView.configureWith(link: link, action: linkAction)
    secondStepLabel.text = secondStepTitle
    circleStepsView.configureWith(title: circleStepsTitle, currentStep: currentStep, maxSteps: maxSteps)
    configureLayout(lottieAnimationView: lottieAnimationView)
    lottieAnimationView.play()
  }
}

// MARK: - Private

private extension ReferralProgramView {
  func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    
    titleLabel.font = fancyFont.primaryBold24
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    titleLabel.textAlignment = .center
    
    firstStepLabel.font = fancyFont.primaryMedium18
    firstStepLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    firstStepLabel.numberOfLines = .zero
    
    secondStepLabel.font = fancyFont.primaryMedium18
    secondStepLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    secondStepLabel.numberOfLines = .zero
  }
  
  func configureLayout(lottieAnimationView: UIView) {
    let appearance = Appearance()
    
    [lottieAnimationView, titleLabel, firstStepLabel, linkCopyView, secondStepLabel, circleStepsView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      lottieAnimationView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.25),
      lottieAnimationView.topAnchor.constraint(equalTo: topAnchor),
      lottieAnimationView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: appearance.inset),
      lottieAnimationView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: -appearance.inset),
      
      titleLabel.topAnchor.constraint(equalTo: lottieAnimationView.bottomAnchor,
                                      constant: appearance.largeInset),
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      firstStepLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.largeInset),
      firstStepLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                          constant: appearance.inset),
      firstStepLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.largeInset),
      
      linkCopyView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: appearance.largeInset),
      linkCopyView.topAnchor.constraint(equalTo: firstStepLabel.bottomAnchor,
                                        constant: appearance.minInset),
      linkCopyView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -appearance.largeInset),
      
      secondStepLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: appearance.largeInset),
      secondStepLabel.topAnchor.constraint(equalTo: linkCopyView.bottomAnchor,
                                           constant: appearance.maxInset),
      secondStepLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -appearance.largeInset),
      
      circleStepsView.centerXAnchor.constraint(equalTo: centerXAnchor),
      circleStepsView.topAnchor.constraint(equalTo: secondStepLabel.bottomAnchor,
                                           constant: appearance.maxInset),
      circleStepsView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -appearance.largeInset)
    ])
  }
}

// MARK: - Appearance

private extension ReferralProgramView {
  struct Appearance {
    let minInset: CGFloat = 8
    let inset: CGFloat = 16
    let largeInset: CGFloat = 24
    let maxInset: CGFloat = 24
    let animationSpeed: CGFloat = 0.5
  }
}

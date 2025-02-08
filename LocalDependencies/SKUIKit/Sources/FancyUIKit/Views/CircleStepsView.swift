//
//  CircleStepsView.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 30.07.2023.
//

import UIKit
import FancyStyle

/// View для экрана
final class CircleStepsView: UIView {
  
  // MARK: - Private properties
  
  private let titleLabel = UILabel()
  private let countLabel = UILabel()
  
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
  ///  - title: Заголовок
  ///  - currentStep: Текущее количество регистраций
  ///  - maxSteps: Максимальное количество регистраций
  public func configureWith(
    title: String,
    currentStep: Int,
    maxSteps: Int = 5
  ) {
    var registrationsCount = maxSteps
    if currentStep > maxSteps {
      registrationsCount = .zero
    } else {
      registrationsCount = maxSteps - currentStep
    }
    countLabel.text = "\(registrationsCount)"
    titleLabel.text = title
    configureLayout(currentStep: currentStep, maxSteps: maxSteps)
  }
}

// MARK: - Private

private extension CircleStepsView {
  func configureLayout(currentStep: Int, maxSteps: Int) {
    let appearance = Appearance()
    let circleSteps = createCircleSteps(currentStep: currentStep, maxSteps: maxSteps)
    
    [titleLabel, countLabel, circleSteps].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      circleSteps.leadingAnchor.constraint(equalTo: leadingAnchor),
      circleSteps.topAnchor.constraint(equalTo: topAnchor),
      circleSteps.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
      
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.topAnchor.constraint(equalTo: circleSteps.bottomAnchor, constant: Appearance().inset),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      countLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor,
                                          constant: appearance.minInset),
      countLabel.bottomAnchor.constraint(lessThanOrEqualTo: titleLabel.bottomAnchor),
      countLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    
    titleLabel.font = fancyFont.primaryMedium18
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    
    countLabel.font = fancyFont.primaryMedium18
    countLabel.textColor = .fancy.only.primaryBlue
  }
  
  func createCircleSteps(currentStep: Int, maxSteps: Int) -> UIView {
    let appearance = Appearance()
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = Appearance().stackViewSpacing
    
    (1...maxSteps).forEach { step in
      let gradientCircle = GradientView()
      gradientCircle.layer.cornerRadius = appearance.circleStepsSize / 2
      gradientCircle.clipsToBounds = true
      let stepText = UILabel()
      stepText.font = fancyFont.primaryBold18
      stepText.textColor = .fancy.only.primaryWhite
      stepText.text = "\(step)"
      
      if (0...currentStep).contains(step) {
        gradientCircle.applyGradient(colors: [.fancy.only.primaryGreen,
                                              .fancy.only.secondaryGreen])
      } else {
        gradientCircle.applyGradient(colors: [.fancy.only.primaryGray,
                                              .fancy.only.secondaryGray])
      }
      [stepText, gradientCircle].forEach {
        $0.translatesAutoresizingMaskIntoConstraints = false
      }
      
      gradientCircle.addSubview(stepText)
      stackView.addArrangedSubview(gradientCircle)
      
      NSLayoutConstraint.activate([
        gradientCircle.widthAnchor.constraint(equalToConstant: appearance.circleStepsSize),
        gradientCircle.heightAnchor.constraint(equalToConstant: appearance.circleStepsSize),
        
        stepText.centerXAnchor.constraint(equalTo: gradientCircle.centerXAnchor),
        stepText.centerYAnchor.constraint(equalTo: gradientCircle.centerYAnchor)
      ])
    }
    return stackView
  }
}

// MARK: - Appearance

private extension CircleStepsView {
  struct Appearance {
    let circleStepsSize: CGFloat = 30
    let inset: CGFloat = 8
    let minInset: CGFloat = 4
    let stackViewSpacing: CGFloat = 8
  }
}

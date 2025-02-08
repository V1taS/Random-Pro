//
//  OnboardingContainerView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import UIKit
import Lottie
import SKStyle

/// OnboardingContainerView
final class OnboardingContainerView: UIView {
  
  // MARK: - Private properties
  
  private let containerView = UIView()
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private var lottieAnimationView = LottieAnimationView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func configureWith(lottieAnimationJSONName: String, title: String?, description: String?) {
    lottieAnimationView = LottieAnimationView(name: lottieAnimationJSONName,
                                              bundle: .main)
    lottieAnimationView.contentMode = .scaleAspectFit
    lottieAnimationView.loopMode = .loop
    lottieAnimationView.animationSpeed = Appearance().animationSpeed
    lottieAnimationView.play()
    
    titleLabel.text = title
    descriptionLabel.text = description
    configureLayout()
  }
}

// MARK: - Private

private extension OnboardingContainerView {
  func configureLayout() {
    let appearance = Appearance()
    
    [lottieAnimationView, titleLabel, descriptionLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      containerView.addSubview($0)
    }
    
    [containerView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      lottieAnimationView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.25),
      containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      containerView.topAnchor.constraint(equalTo: topAnchor),
      containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      lottieAnimationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      lottieAnimationView.topAnchor.constraint(equalTo: containerView.topAnchor),
      lottieAnimationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      titleLabel.topAnchor.constraint(equalTo: lottieAnimationView.bottomAnchor,
                                      constant: appearance.minInset),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      
      descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                            constant: appearance.minInset),
      descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = SKStyleAsset.onyx.color
    
    lottieAnimationView.contentMode = .scaleAspectFit
    lottieAnimationView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    lottieAnimationView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 1
    titleLabel.font = .fancy.text.largeTitle
    titleLabel.textColor = SKStyleAsset.ghost.color
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.minimumScaleFactor = 0.9
    
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 2
    descriptionLabel.adjustsFontSizeToFitWidth = true
    descriptionLabel.minimumScaleFactor = 0.9
    descriptionLabel.font = .fancy.text.regular
    descriptionLabel.textColor = SKStyleAsset.ghost.color
  }
}

// MARK: - Appearance

private extension OnboardingContainerView {
  struct Appearance {
    let minInset: CGFloat = 4
    let defaultInset: CGFloat = 16
    let animationSpeed: CGFloat = 0.5
  }
}


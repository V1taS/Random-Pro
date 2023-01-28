//
//  OnboardingScreenContainerView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// View для экрана
final class OnboardingScreenContainerView: UIView {
  
  // MARK: - Private properties
  
  private let containerView = UIView()
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let imageView = UIImageView()
  
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
  
  func configureWith(image: Data, title: String?, description: String?) {
    imageView.image = UIImage(data: image)
    titleLabel.text = title
    descriptionLabel.text = description
  }
}

// MARK: - Private

private extension OnboardingScreenContainerView {
  func configureLayout() {
    let appearance = Appearance()
    
    [imageView, titleLabel, descriptionLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      containerView.addSubview($0)
    }
    
    [containerView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      containerView.topAnchor.constraint(equalTo: topAnchor),
      containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
      imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                          constant: appearance.insetLarge),
      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                      constant: appearance.insetLarge),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                           constant: -appearance.insetLarge),
      
      descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                constant: appearance.insetLarge),
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                            constant: appearance.insetMiddle),
      descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                 constant: -appearance.insetLarge),
      descriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    imageView.contentMode = .scaleAspectFit
    imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = .zero
    titleLabel.font = RandomFont.primaryMedium32
    titleLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = .zero
    descriptionLabel.font = RandomFont.primaryRegular24
    descriptionLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
  }
}

// MARK: - Appearance

private extension OnboardingScreenContainerView {
  struct Appearance {
    let insetMiddle: CGFloat = 16
    let insetLarge: CGFloat = 24
  }
}

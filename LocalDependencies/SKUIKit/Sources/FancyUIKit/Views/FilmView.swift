//
//  FilmView.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 29.01.2023.
//

import UIKit
import Lottie
import FancyStyle

/// View для экрана
public final class FilmView: UIView {
  
  // MARK: - Private property
  
  private let imageBackroundView = UIImageView()
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let generateButton = ButtonView()
  private let gradientView = GradientView()
  private var buttonAction: (() -> Void)?
  private var lottieAnimationView = LottieAnimationView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    applyDefaultBehavior()
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public func
  
  /// Включить кнопку
  /// - Parameters:
  ///  - isEnabled: Кнопка включена
  public func setButtonIsEnabled(_ isEnabled: Bool) {
    generateButton.isEnabled = isEnabled
    generateButton.set(isEnabled: isEnabled)
  }
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - backgroundImage: Фоновое изображение
  ///  - title: Заголовок
  ///  - description: Описание
  ///  - buttonTitle: Название кнопки
  ///  - buttonAction: Действие на кнопку
  public func configureWith(backgroundImage: UIImage?,
                            title: String?,
                            description: String?,
                            buttonTitle: String?,
                            buttonAction: (() -> Void)?) {
    self.buttonAction = buttonAction
    
    titleLabel.text = title
    descriptionLabel.text = description
    generateButton.setTitle(buttonTitle, for: .normal)
    
    if let backgroundImage {
      imageBackroundView.image = backgroundImage
      lottieAnimationView.stop()
      lottieAnimationView.isHidden = true
    } else {
      lottieAnimationView.isHidden = false
      lottieAnimationView.play()
    }
  }
}

// MARK: - Private

private extension FilmView {
  func applyDefaultBehavior() {
    titleLabel.textAlignment = .center
    titleLabel.font = fancyFont.primaryBold70
    titleLabel.textColor = .fancy.only.primaryWhite
    titleLabel.numberOfLines = 2
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.minimumScaleFactor = 0.5
    
    descriptionLabel.textAlignment = .center
    descriptionLabel.font = fancyFont.primaryMedium16
    descriptionLabel.textColor = .fancy.only.lightGray
    descriptionLabel.numberOfLines = 3
    
    imageBackroundView.contentMode = .scaleAspectFill
    
    
    generateButton.setTitleColor(.fancy.only.darkApple, for: .normal)
    
    gradientView.applyGradient(
      colors: [
        fancyColor.only.darkApple,
        .clear,
        .clear,
        fancyColor.only.darkApple,
        fancyColor.only.darkApple,
      ],
      alpha: 0.9
    )
    
    lottieAnimationView = LottieAnimationView(name: Appearance().mockFilmsEmptyName,
                                              bundle: .module)
    lottieAnimationView.contentMode = .scaleAspectFit
    lottieAnimationView.loopMode = .loop
    lottieAnimationView.animationSpeed = Appearance().animationSpeed
    lottieAnimationView.isHidden = true
    clipsToBounds = true
    
    generateButton.addTarget(self,
                             action: #selector(generateButtonAction),
                             for: .touchUpInside)
  }
  
  func configureLayout() {
    let appearance = Appearance()
    
    [imageBackroundView, lottieAnimationView, gradientView,
     titleLabel, descriptionLabel, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      imageBackroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageBackroundView.topAnchor.constraint(equalTo: topAnchor),
      imageBackroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageBackroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      lottieAnimationView.leadingAnchor.constraint(equalTo: leadingAnchor),
      lottieAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor,
                                                   constant: -appearance.lottieVerticalInset),
      lottieAnimationView.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
      gradientView.topAnchor.constraint(equalTo: topAnchor),
      gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
      gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      titleLabel.leadingAnchor.constraint(equalTo: imageBackroundView.leadingAnchor,
                                          constant: appearance.defaultInset),
      titleLabel.trailingAnchor.constraint(equalTo: imageBackroundView.trailingAnchor,
                                           constant: -appearance.defaultInset),
      titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor,
                                         constant: -appearance.defaultInset),
      
      descriptionLabel.leadingAnchor.constraint(equalTo: imageBackroundView.leadingAnchor,
                                                constant: appearance.defaultInset),
      descriptionLabel.trailingAnchor.constraint(equalTo: imageBackroundView.trailingAnchor,
                                                 constant: -appearance.defaultInset),
      descriptionLabel.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                               constant: -appearance.extraMaxInset),
      
      generateButton.leadingAnchor.constraint(equalTo: imageBackroundView.leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: imageBackroundView.trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: imageBackroundView.bottomAnchor,
                                             constant: -appearance.maxInset),
    ])
  }
  
  @objc
  func generateButtonAction() {
    buttonAction?()
  }
}

// MARK: - Appearance

private extension FilmView {
  struct Appearance {
    let lottieVerticalInset: CGFloat = 100
    let maxInset: CGFloat = 32
    let extraMaxInset: CGFloat = 32
    let defaultInset: CGFloat = 14
    let animationSpeed: CGFloat = 0.5
    let mockFilmsEmptyName = "mock_films_empty"
  }
}

//
//  ADVGoogleScreenView.swift
//  Random
//
//  Created by Vitalii Sosin on 29.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle
import Lottie
import GoogleMobileAds

/// События которые отправляем из View в Presenter
protocol ADVGoogleScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol ADVGoogleScreenViewInput {
  
  /// Запустить доадер
  func startLoader()
  
  /// Остановить лоадер
  func stopLoader()
  
  /// Установить рекламу
  /// - Parameter nativeAd: Реклама
  func setNativeAd(_ nativeAd: GADNativeAd)
  
  /// Установить oставшееся время
  /// - Parameter seconds: Оставшееся время
  func setEstimatedSeconds(_ seconds: Int)
}

/// Псевдоним протокола UIView & CustomMainSectionsViewInput
typealias ADVGoogleScreenViewProtocol = UIView & ADVGoogleScreenViewInput

/// View для экрана
final class ADVGoogleScreenView: ADVGoogleScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: ADVGoogleScreenViewOutput?
  
  // MARK: - Private properties
  
  private let nativeAdView = GADNativeAdView()
  private let adChoicesView = GADAdChoicesView()
  private let headlineView = UILabel()
  private let estimatedSecondsView = UILabel()
  private let descriptionView = UILabel()
  private let mediaView = GADMediaView()
  private let callToActionButton = UIButton()
  private let starRatingView = UILabel()
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
  
  func setNativeAd(_ nativeAd: GADNativeAd) {
    DispatchQueue.main.async { [weak self] in
      self?.nativeAdView.nativeAd = nativeAd
      self?.headlineView.text = nativeAd.headline
      self?.descriptionView.text = nativeAd.body
      self?.mediaView.mediaContent = nativeAd.mediaContent
      self?.nativeAdView.mediaView = self?.mediaView
      
      if let callToActionView = nativeAd.callToAction {
        self?.callToActionButton.setTitle(callToActionView, for: .normal)
      }
      
      if let starRating = nativeAd.starRating {
        self?.starRatingView.text = "\(starRating.doubleValue)/5"
      }
      
      self?.nativeAdView.adChoicesView = self?.adChoicesView
      self?.nativeAdView.headlineView = self?.headlineView
      self?.nativeAdView.bodyView = self?.descriptionView
      self?.nativeAdView.mediaView = self?.mediaView
      self?.nativeAdView.callToActionView = self?.callToActionButton
      self?.nativeAdView.starRatingView = self?.starRatingView
    }
  }
  
  func startLoader() {
    lottieAnimationView.isHidden = false
    lottieAnimationView.play()
  }
  
  func stopLoader() {
    lottieAnimationView.isHidden = true
    lottieAnimationView.stop()
  }
  
  func setEstimatedSeconds(_ seconds: Int) {
    estimatedSecondsView.isHidden = false
    estimatedSecondsView.text = "\(seconds) \(Appearance().secTitle)."
  }
}

// MARK: - Private

private extension ADVGoogleScreenView {
  func configureLayout() {
    let appearance = Appearance()
    let safeArea = nativeAdView.safeAreaLayoutGuide
    
    [mediaView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      nativeAdView.addSubview($0)
    }
    
    [nativeAdView, adChoicesView, headlineView, descriptionView,
     callToActionButton, starRatingView, estimatedSecondsView, lottieAnimationView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      nativeAdView.leadingAnchor.constraint(equalTo: leadingAnchor),
      nativeAdView.topAnchor.constraint(equalTo: topAnchor),
      nativeAdView.trailingAnchor.constraint(equalTo: trailingAnchor),
      nativeAdView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      mediaView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
      mediaView.topAnchor.constraint(equalTo: nativeAdView.topAnchor),
      mediaView.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
      mediaView.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor),
      mediaView.widthAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.width),
      mediaView.heightAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.height / 2),
      
      adChoicesView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -appearance.defaultInset),
      adChoicesView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                         constant: appearance.maxInset),
      
      headlineView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: appearance.defaultInset),
      headlineView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -appearance.defaultInset),
      headlineView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                        constant: appearance.maxInset),
      
      descriptionView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: appearance.defaultInset),
      descriptionView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -appearance.defaultInset),
      descriptionView.topAnchor.constraint(equalTo: headlineView.bottomAnchor,
                                           constant: appearance.defaultInset),
      
      starRatingView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      starRatingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset),
      
      estimatedSecondsView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -appearance.defaultInset),
      estimatedSecondsView.bottomAnchor.constraint(equalTo: callToActionButton.topAnchor,
                                                   constant: -appearance.defaultInset / 2),
      
      callToActionButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -appearance.defaultInset),
      callToActionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                 constant: -appearance.defaultInset),
      
      lottieAnimationView.centerXAnchor.constraint(equalTo: centerXAnchor),
      lottieAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor),
      lottieAnimationView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    
    headlineView.numberOfLines = .zero
    descriptionView.numberOfLines = .zero
    mediaView.contentMode = .scaleAspectFill
    
    headlineView.font = fancyFont.primaryMedium24
    headlineView.textColor = fancyColor.darkAndLightTheme.primaryGray
    
    descriptionView.font = fancyFont.primaryMedium18
    descriptionView.textColor = fancyColor.darkAndLightTheme.primaryGray
    
    starRatingView.font = fancyFont.primaryMedium18
    starRatingView.textColor = fancyColor.darkAndLightTheme.primaryGray
    
    estimatedSecondsView.font = fancyFont.primaryMedium16
    estimatedSecondsView.textColor = fancyColor.only.primaryBlue
    estimatedSecondsView.isHidden = true
    
    callToActionButton.titleLabel?.font = fancyFont.primaryMedium18
    callToActionButton.setTitleColor(fancyColor.only.primaryBlue, for: .normal)
    
    lottieAnimationView.isHidden = true
    lottieAnimationView.contentMode = .scaleAspectFit
    lottieAnimationView.loopMode = .loop
    lottieAnimationView.animationSpeed = Appearance().animationSpeed
  }
}

// MARK: - Appearance

private extension ADVGoogleScreenView {
  struct Appearance {
    let defaultInset: CGFloat = 16
    let maxInset: CGFloat = 32
    let animationSpeed: CGFloat = 0.5
    let loaderImage = RandomAsset.filmsLoader.name
    let secTitle = RandomStrings.Localizable.sec
  }
}

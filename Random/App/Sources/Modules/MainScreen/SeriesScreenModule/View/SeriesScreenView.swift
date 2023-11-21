//
//  SeriesScreenView.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//

import UIKit
import FancyUIKit
import FancyStyle
import Lottie

/// События которые отправляем из View в Presenter
protocol SeriesScreenViewOutput: AnyObject {

  /// Сгенерировать сериал
  func generateSeriesAction()
}

/// События которые отправляем от Presenter ко View
protocol SeriesScreenViewInput {

  /// Обновить контент
  /// - Parameter model: Модель
  func updateContentWith(model: SeriesScreenModel)

  /// Запустить лоадер
  func startLoader()

  /// Остановить лоадер
  func stopLoader()

  /// Получить название сериала
  func getSeriesName() -> String?

  /// Получить ссылку на трайлер сериала зарубежного
  func gerPreviewEngtUrl() -> String?
}

/// Псевдоним протокола UIView & SeriesScreenViewInput
typealias SeriesScreenViewProtocol = UIView & SeriesScreenViewInput

/// View для экрана
final class SeriesScreenView: SeriesScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: SeriesScreenViewOutput?
  
  // MARK: - Private properties

  private let seriesView = FilmView()
  private let activityIndicator = LottieAnimationView(name: Appearance().loaderImage)
  private var cacheSeriesName: String?
  private var cacheTrailerEngSeriesUrl: String?
  
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

  func updateContentWith(model: SeriesScreenModel) {
    cacheSeriesName = model.name
    cacheTrailerEngSeriesUrl = model.trailerUrl
    var backgroundImage: UIImage?
    if let imageData = model.image {
      backgroundImage = UIImage(data: imageData)
    }

    seriesView.configureWith(backgroundImage: backgroundImage,
                             title: model.name,
                             description: model.description,
                             buttonTitle: Appearance().buttonTitle,
                             buttonAction: { [weak self] in
      self?.output?.generateSeriesAction()
    })
  }

  func startLoader() {
    activityIndicator.isHidden = false
    activityIndicator.play()
    seriesView.setButtonIsEnabled(false)
  }

  func stopLoader() {
    activityIndicator.isHidden = true
    activityIndicator.stop()
    seriesView.setButtonIsEnabled(true)
  }

  func getSeriesName() -> String? {
    return cacheSeriesName
  }

  func gerPreviewEngtUrl() -> String? {
    return cacheTrailerEngSeriesUrl
  }
}

// MARK: - Private

private extension SeriesScreenView {
  func configureLayout() {
    [seriesView, activityIndicator].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }

    NSLayoutConstraint.activate([
      seriesView.leadingAnchor.constraint(equalTo: leadingAnchor),
      seriesView.topAnchor.constraint(equalTo: topAnchor),
      seriesView.trailingAnchor.constraint(equalTo: trailingAnchor),
      seriesView.bottomAnchor.constraint(equalTo: bottomAnchor),

      activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
      activityIndicator.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    seriesView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    
    activityIndicator.isHidden = true
    activityIndicator.contentMode = .scaleAspectFit
    activityIndicator.loopMode = .loop
    activityIndicator.animationSpeed = Appearance().animationSpeed

    seriesView.configureWith(backgroundImage: nil,
                             title: nil,
                             description: nil,
                             buttonTitle: Appearance().buttonTitle,
                             buttonAction: { [weak self] in
      self?.output?.generateSeriesAction()
    })
  }
}

// MARK: - Appearance

private extension SeriesScreenView {
  struct Appearance {
    let buttonTitle = RandomStrings.Localizable.generate
    let loaderImage = RandomAsset.filmsLoader.name
    let animationSpeed: CGFloat = 0.5
  }
}

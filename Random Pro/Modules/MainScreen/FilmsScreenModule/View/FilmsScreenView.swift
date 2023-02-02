//
//  FilmsScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol FilmsScreenViewOutput: AnyObject {
  
  /// Сгенерировать фильм
  func generateMovieAction()
}

/// События которые отправляем от Presenter ко View
protocol FilmsScreenViewInput {
  
  /// Обновить контент
  /// - Parameter model: Модель
  func updateContentWith(model: FilmsScreenModel)
  
  /// Запустить доадер
  func startLoader()
  
  /// Остановить лоадер
  func stopLoader()
  
  /// Получить название фильма
  func getFilmName() -> String?
  
  /// Получить ссылку на трайлер фильма зарубежного
  func gerPreviewEngtUrl() -> String?
}

/// Псевдоним протокола UIView & FilmsScreenViewInput
typealias FilmsScreenViewProtocol = UIView & FilmsScreenViewInput

/// View для экрана
final class FilmsScreenView: FilmsScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: FilmsScreenViewOutput?
  
  // MARK: - Private properties
  
  private let filmsView = FilmView()
  private let activityIndicator = UIActivityIndicatorView(style: .large)
  private var cacheFilmsName: String?
  private var cacheTrailerEngFilmsUrl: String?
  
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
  
  func updateContentWith(model: FilmsScreenModel) {
    cacheFilmsName = model.name
    cacheTrailerEngFilmsUrl = model.previewEngtUrl
    var backgroundImage: UIImage?
    if let imageData = model.image {
      backgroundImage = UIImage(data: imageData)
    }
    
    filmsView.configureWith(backgroundImage: backgroundImage,
                            title: model.name,
                            description: model.description,
                            buttonTitle: Appearance().buttonTitle,
                            buttonAction: { [weak self] in
      self?.output?.generateMovieAction()
    })
  }
  
  func startLoader() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    filmsView.setButtonIsEnabled(false)
  }
  
  func stopLoader() {
    activityIndicator.isHidden = true
    activityIndicator.stopAnimating()
    filmsView.setButtonIsEnabled(true)
  }
  
  func getFilmName() -> String? {
    return cacheFilmsName
  }
  
  func gerPreviewEngtUrl() -> String? {
    return cacheTrailerEngFilmsUrl
  }
}

// MARK: - Private

private extension FilmsScreenView {
  func configureLayout() {
    [filmsView, activityIndicator].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      filmsView.leadingAnchor.constraint(equalTo: leadingAnchor),
      filmsView.topAnchor.constraint(equalTo: topAnchor),
      filmsView.trailingAnchor.constraint(equalTo: trailingAnchor),
      filmsView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    filmsView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    activityIndicator.isHidden = true
    
    filmsView.configureWith(backgroundImage: nil,
                            title: nil,
                            description: nil,
                            buttonTitle: Appearance().buttonTitle,
                            buttonAction: { [weak self] in
      self?.output?.generateMovieAction()
    })
  }
}

// MARK: - Appearance

private extension FilmsScreenView {
  struct Appearance {
    let buttonTitle = NSLocalizedString("Сгенерировать", comment: "")
  }
}

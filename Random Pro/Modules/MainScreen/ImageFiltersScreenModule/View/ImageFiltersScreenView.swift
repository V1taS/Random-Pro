//
//  ImageFiltersScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.01.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol ImageFiltersScreenViewOutput: AnyObject {
  
  /// Сгенерировать новый фильтр
  /// - Parameter image: Изображение
  func generateImageFilterFor(image: Data?)
}

/// События которые отправляем от Presenter ко View
protocol ImageFiltersScreenViewInput {
  
  /// Вернуть изображение с фильтром
  func returnImageDataColor() -> Data?
  
  /// Загрузить изображение
  /// - Parameter data: Изображение
  func uploadContentImage(_ data: Data)
  
  /// Обновить изображение
  /// - Parameter data: Изображение
  func updateContentImage(_ data: Data)
  
  /// Запустить анимацию загрузки
  func startLoader()
  
  /// Остановить анимацию загрузки
  func stopLoader()
}

/// Псевдоним протокола UIView & ImageFiltersScreenViewInput
typealias ImageFiltersScreenViewProtocol = UIView & ImageFiltersScreenViewInput

/// View для экрана
final class ImageFiltersScreenView: ImageFiltersScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: ImageFiltersScreenViewOutput?
  
  // MARK: - Private properties
  
  private let generateButton = ButtonView()
  private let imageView = UIImageView()
  private let loaderView = UIActivityIndicatorView(style: .large)
  private var cacheData: Data?
  
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
  
  func returnImageDataColor() -> Data? {
    return imageView.image?.compress(maxKb: 10_194_304)
  }
  
  func uploadContentImage(_ data: Data) {
    cacheData = data
    updateContentWith(data)
  }
  
  func updateContentImage(_ data: Data) {
    updateContentWith(data)
  }
  
  func startLoader() {
    loaderView.isHidden = false
    loaderView.startAnimating()
  }
  
  func stopLoader() {
    loaderView.stopAnimating()
    loaderView.isHidden = true
  }
}

// MARK: - Private

private extension ImageFiltersScreenView {
  func updateContentWith(_ data: Data) {
    UIView.animate(withDuration: Appearance().resultDuration) { [weak self] in
      guard let self = self else {
        return
      }
      let image = UIImage(data: data)
      self.imageView.image = image
      
      image?.getAverageColor { [weak self] averageColor in
        UIView.animate(withDuration: Appearance().resultDuration) { [weak self] in
          self?.backgroundColor = averageColor
        }
      }
    }
  }
  
  func configureLayout() {
    let appearance = Appearance()
    
    [imageView, generateButton, loaderView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset),
      
      loaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
      loaderView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    imageView.image = appearance.plugImage
    imageView.contentMode = .scaleAspectFit
    cacheData = appearance.plugImage?.jpegData(compressionQuality: 1)
    loaderView.isHidden = true
    
    appearance.plugImage?.getAverageColor { [weak self] averageColor in
      UIView.animate(withDuration: appearance.resultDuration) { [weak self] in
        self?.backgroundColor = averageColor
      }
    }

    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
  }
  
  @objc
  func generateButtonAction() {
    output?.generateImageFilterFor(image: cacheData)
  }
}

// MARK: - Appearance

private extension ImageFiltersScreenView {
  struct Appearance {
    let resultDuration: CGFloat = 0.2
    let defaultInset: CGFloat = 16
    let buttonTitle = NSLocalizedString("Сгенерировать", comment: "")
    let plugImage = UIImage(named: "image_filters_plug")
  }
}

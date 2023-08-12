//
//  ImageFiltersScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.01.2023.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol ImageFiltersScreenModuleOutput: AnyObject {
  
  /// Доступ к галерее не получен
  func requestGalleryError()
  
  /// Кнопка поделиться была нажата
  ///  - Parameter imageData: Изображение Colors
  func shareButtonAction(imageData: Data?)
  
  /// Доступ к галерее получен
  func requestGalleryActionSheetSuccess()
  
  /// Получен доступ к галерее
  func requestCameraActionSheetSuccess()
  
  /// Выбрать изображение
  func chooseImageButtonAction()
  
  /// Получена ошибка
  func didReceiveError()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol ImageFiltersScreenModuleInput {
  
  /// Запрос доступа к Галерее через шторку
  func requestGalleryActionSheetStatus()
  
  /// Запрос доступа к Камере через шторку
  func requestCameraActionSheetStatus()
  
  /// Загрузить изображение
  /// - Parameter data: Изображение
  func uploadContentImage(_ data: Data)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: ImageFiltersScreenModuleOutput? { get set }
}

/// Готовый модуль `ImageFiltersScreenModule`
typealias ImageFiltersScreenModule = ViewController & ImageFiltersScreenModuleInput

/// Презентер
final class ImageFiltersScreenViewController: ImageFiltersScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: ImageFiltersScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ImageFiltersScreenInteractorInput
  private let moduleView: ImageFiltersScreenViewProtocol
  private let factory: ImageFiltersScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: ImageFiltersScreenViewProtocol,
       interactor: ImageFiltersScreenInteractorInput,
       factory: ImageFiltersScreenFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  
  override func loadView() {
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavigationBar()
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Internal func
  
  func requestGalleryActionSheetStatus() {
    interactor.requestGalleryActionSheetStatus()
  }
  
  func requestCameraActionSheetStatus() {
    interactor.requestCameraActionSheetStatus()
  }
  
  func uploadContentImage(_ data: Data) {
    moduleView.uploadContentImage(data)
  }
}

// MARK: - ImageFiltersScreenViewOutput

extension ImageFiltersScreenViewController: ImageFiltersScreenViewOutput {
  func generateImageFilterFor(image: Data?) {
    factory.generateFilterFor(image: image)
    interactor.generateImageFilterFor(image: image)
    moduleView.startLoader()
  }
}

// MARK: - ImageFiltersScreenInteractorOutput

extension ImageFiltersScreenViewController: ImageFiltersScreenInteractorOutput {
  func requestGalleryActionSheetSuccess() {
    moduleOutput?.requestGalleryActionSheetSuccess()
  }
  
  func requestCameraActionSheetSuccess() {
    moduleOutput?.requestCameraActionSheetSuccess()
  }
  
  func requestShareGallerySuccess() {
    moduleOutput?.shareButtonAction(imageData: moduleView.returnImageDataColor())
  }
  
  func requestGalleryError() {
    moduleOutput?.requestGalleryError()
  }
}

// MARK: - ImageFiltersScreenFactoryOutput

extension ImageFiltersScreenViewController: ImageFiltersScreenFactoryOutput {
  func didReceiveError() {
    moduleOutput?.didReceiveError()
    moduleView.stopLoader()
  }
  
  func didReceiveNewImage(_ image: Data) {
    moduleView.updateContentImage(image)
    moduleView.stopLoader()
  }
}

// MARK: - Private

private extension ImageFiltersScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    
    let shareButton = UIBarButtonItem(image: appearance.shareButtonIcon,
                                      style: .plain,
                                      target: self,
                                      action: #selector(shareButtonAction))
    let addImageButton = UIBarButtonItem(image: appearance.addImageButtonIcon,
                                         style: .plain,
                                         target: self,
                                         action: #selector(chooseImageButtonAction))
    
    navigationItem.rightBarButtonItems = [addImageButton, shareButton]
  }
  
  @objc
  func shareButtonAction() {
    interactor.requestShareGalleryStatus()
    impactFeedback.impactOccurred()
  }
  
  @objc
  func chooseImageButtonAction() {
    moduleOutput?.chooseImageButtonAction()
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension ImageFiltersScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.photoFilters
    let shareButtonIcon = UIImage(systemName: "square.and.arrow.up")
    let addImageButtonIcon = UIImage(systemName: "plus")
  }
}

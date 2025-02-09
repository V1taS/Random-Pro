//
//  ShareScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.08.2022.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol ShareScreenModuleOutput: AnyObject {
  
  /// Кнопка поделиться была нажата
  ///  - Parameter imageData: Изображение контента
  func shareButtonAction(imageData: Data?)
  
  /// Модуль был закрыт
  func closeButtonAction()
  
  /// Доступ к галерее не получен
  func requestPhotosError()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol ShareScreenModuleInput {
  
  /// Обновить контент
  ///  - Parameter imageData: Изображение контента
  func updateContentWith(imageData: Data?)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: ShareScreenModuleOutput? { get set }
}

/// Готовый модуль `ShareScreenModule`
typealias ShareScreenModule = ViewController & ShareScreenModuleInput

/// Презентер
final class ShareScreenViewController: ShareScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: ShareScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ShareScreenInteractorInput
  private let moduleView: ShareScreenViewProtocol
  private let factory: ShareScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private var imageDataCache: Data?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: ShareScreenViewProtocol,
       interactor: ShareScreenInteractorInput,
       factory: ShareScreenFactoryInput) {
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

    Metrics.shared.track(event: .shareScreenOpen)
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .shareScreenClose)
  }
  
  // MARK: - Internal func
  
  func updateContentWith(imageData: Data?) {
    imageDataCache = imageData
    moduleView.updateContentWith(imageData: imageData)
  }
}

// MARK: - ShareScreenViewOutput

extension ShareScreenViewController: ShareScreenViewOutput {}

// MARK: - ShareScreenInteractorOutput

extension ShareScreenViewController: ShareScreenInteractorOutput {
  func requestPhotosSuccess() {
    moduleOutput?.shareButtonAction(imageData: moduleView.returnImageData())
  }
  
  func requestPhotosError() {
    moduleOutput?.requestPhotosError()
  }
}

// MARK: - ShareScreenFactoryOutput

extension ShareScreenViewController: ShareScreenFactoryOutput {}

// MARK: - Private

private extension ShareScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    
    let shareButton = UIBarButtonItem(image: appearance.shareButtonIcon,
                                      style: .plain,
                                      target: self,
                                      action: #selector(shareButtonAction))
    let closeButton = UIBarButtonItem(image: appearance.closeButtonIcon,
                                      style: .plain,
                                      target: self,
                                      action: #selector(closeButtonAction))
    
    navigationItem.rightBarButtonItems = [
      closeButton,
      shareButton
    ]
  }
  
  @objc
  func closeButtonAction() {
    moduleOutput?.closeButtonAction()
    impactFeedback.impactOccurred()
  }
  
  @objc
  func shareButtonAction() {
    interactor.requestPhotosStatus()
    impactFeedback.impactOccurred()
    Metrics.shared.track(event: .shareScreenButtonShare)
  }
}

// MARK: - Appearance

private extension ShareScreenViewController {
  struct Appearance {
    let shareButtonIcon = UIImage(systemName: "square.and.arrow.up")
    let closeButtonIcon = UIImage(systemName: "xmark")
    let title = RandomStrings.Localizable.shareImage
  }
}

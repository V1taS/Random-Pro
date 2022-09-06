//
//  ShareScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.08.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol ShareScreenModuleOutput: AnyObject {
  
  /// Кнопка поделиться была нажата
  ///  - Parameter imageData: Изображение контента
  func shareButtonAction(imageData: Data?)
  
  /// Модуль был закрыт
  func closeButtonAction()
  
  /// Доступ  не получен к Галерее
  func requestPhotosError()
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol ShareScreenModuleInput {
  
  /// Обновить контент
  ///  - Parameter imageData: Изображение контента
  func updateContentWith(imageData: Data?)
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: ShareScreenModuleOutput? { get set }
}

/// Готовый модуль `ShareScreenModule`
typealias ShareScreenModule = UIViewController & ShareScreenModuleInput

/// Презентер
final class ShareScreenViewController: ShareScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: ShareScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ShareScreenInteractorInput
  private let moduleView: ShareScreenViewProtocol
  private let factory: ShareScreenFactoryInput
  private var imageDataCache: Data?
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(interactor: ShareScreenInteractorInput,
       moduleView: ShareScreenViewProtocol,
       factory: ShareScreenFactoryInput) {
    self.interactor = interactor
    self.moduleView = moduleView
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
    moduleOutput?.shareButtonAction(imageData: imageDataCache)
  }
  
  func requestPhotosError() {
    moduleOutput?.requestPhotosError()
  }
}

// MARK: - ShareScreenFactoryOutput

extension ShareScreenViewController: ShareScreenFactoryOutput {
  
}

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
  }
  
  @objc
  func shareButtonAction() {
    interactor.requestPhotosStatus()
  }
}

// MARK: - Appearance

private extension ShareScreenViewController {
  struct Appearance {
    let shareButtonIcon = UIImage(systemName: "square.and.arrow.up")
    let closeButtonIcon = UIImage(systemName: "xmark")
    let title = NSLocalizedString("Поделиться изображением", comment: "")
  }
}

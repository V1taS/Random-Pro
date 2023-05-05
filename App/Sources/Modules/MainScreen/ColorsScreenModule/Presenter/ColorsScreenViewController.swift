//
//  ColorsScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 11.09.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol ColorsScreenModuleOutput: AnyObject {
  
  /// Доступ к галерее не получен
  func requestGalleryError()
  
  /// Кнопка поделиться была нажата
  ///  - Parameter imageData: Изображение Colors
  func shareButtonAction(imageData: Data?)
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol ColorsScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: ColorsScreenModuleOutput? { get set }
}

/// Готовый модуль `ColorsScreenModule`
typealias ColorsScreenModule = UIViewController & ColorsScreenModuleInput

/// Презентер
final class ColorsScreenViewController: ColorsScreenModule {

  // MARK: - Internal properties
  
  weak var moduleOutput: ColorsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ColorsScreenInteractorInput
  private let moduleView: ColorsScreenViewProtocol
  private let factory: ColorsScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: ColorsScreenViewProtocol,
       interactor: ColorsScreenInteractorInput,
       factory: ColorsScreenFactoryInput) {
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
}

// MARK: - ColorsScreenViewOutput

extension ColorsScreenViewController: ColorsScreenViewOutput {}

// MARK: - ColorsScreenInteractorOutput

extension ColorsScreenViewController: ColorsScreenInteractorOutput {
  func requestGallerySuccess() {
    moduleOutput?.shareButtonAction(imageData: moduleView.returnImageDataColor())
  }
  
  func requestGalleryError() {
    moduleOutput?.requestGalleryError()
  }
}

// MARK: - ColorsScreenFactoryOutput

extension ColorsScreenViewController: ColorsScreenFactoryOutput {}

// MARK: - Private

private extension ColorsScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    
    let shareButton = UIBarButtonItem(image: appearance.shareButtonIcon,
                                      style: .plain,
                                      target: self,
                                      action: #selector(shareButtonAction))
    
    navigationItem.rightBarButtonItems = [shareButton]
  }
  
  @objc
  func shareButtonAction() {
    interactor.requestGalleryStatus()
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension ColorsScreenViewController {
  struct Appearance {
    let shareButtonIcon = UIImage(systemName: "square.and.arrow.up")
    let title = RandomStrings.Localizable.colors
  }
}

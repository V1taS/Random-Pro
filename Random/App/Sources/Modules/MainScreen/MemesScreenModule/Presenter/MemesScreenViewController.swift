//
//  MemesScreenViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol MemesScreenModuleOutput: AnyObject {
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка поделиться была нажата
  ///  - Parameter imageData: Изображение контента
  func shareButtonAction(imageData: Data?)
  
  /// Доступ к галерее не получен
  func requestPhotosError()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol MemesScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: MemesScreenModuleOutput? { get set }
}

/// Готовый модуль `MemesScreenModule`
typealias MemesScreenModule = UIViewController & MemesScreenModuleInput

/// Презентер
final class MemesScreenViewController: MemesScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MemesScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MemesScreenInteractorInput
  private let moduleView: MemesScreenViewProtocol
  private let factory: MemesScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private var cacheMemes: Data?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: MemesScreenViewProtocol,
       interactor: MemesScreenInteractorInput,
       factory: MemesScreenFactoryInput) {
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
    interactor.getContent()
  }
}

// MARK: - MemesScreenViewOutput

extension MemesScreenViewController: MemesScreenViewOutput {
  func generateButtonAction() {
    interactor.generateButtonAction()
  }
  
  func somethingWentWrong() {
    moduleOutput?.somethingWentWrong()
  }
}

// MARK: - MemesScreenInteractorOutput

extension MemesScreenViewController: MemesScreenInteractorOutput {
  func requestPhotosSuccess() {
    guard let cacheMemes else {
      return
    }
    moduleOutput?.shareButtonAction(imageData: cacheMemes)
  }
  
  func requestPhotosError() {
    moduleOutput?.requestPhotosError()
  }
  
  func didReceive(memes: Data?) {
    moduleView.set(result: memes)
    cacheMemes = memes
  }
  
  func startLoader() {
    moduleView.startLoader()
  }
  
  func stopLoader() {
    moduleView.stopLoader()
  }
}

// MARK: - MemesScreenFactoryOutput

extension MemesScreenViewController: MemesScreenFactoryOutput {}

// MARK: - Private

private extension MemesScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    let shareButton = UIBarButtonItem(image: appearance.shareButtonIcon,
                                      style: .plain,
                                      target: self,
                                      action: #selector(shareButtonAction))
    navigationItem.rightBarButtonItems = [
      shareButton
    ]
  }
  
  @objc
  func shareButtonAction() {
    interactor.requestPhotosStatus()
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension MemesScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.memes
    let shareButtonIcon = UIImage(systemName: "square.and.arrow.up")
  }
}

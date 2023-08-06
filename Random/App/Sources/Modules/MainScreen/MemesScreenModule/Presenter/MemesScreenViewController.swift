//
//  MemesScreenViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol MemesScreenModuleOutput: AnyObject {
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка поделиться была нажата
  ///  - Parameter imageData: Изображение контента
  func shareButtonAction(imageData: Data?)
  
  /// Доступ к галерее не получен
  func requestPhotosError()
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: MemesScreenModel)
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol MemesScreenModuleInput {
  
  /// Установить новый язык
  func setNewLanguage(language: MemesScreenModel.Language)
  
  /// Запросить текущую модель
  func returnCurrentModel() -> MemesScreenModel
  
  /// Обновить типы доступных мемов
  /// - Parameter type: тип доступных мемов
  func updateMemes(type: [MemesScreenModel.MemesType])
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: MemesScreenModuleOutput? { get set }
}

/// Готовый модуль `MemesScreenModule`
typealias MemesScreenModule = ViewController & MemesScreenModuleInput

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
    moduleView.startLoader()
    interactor.getContent()
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Internal func
  
  func setNewLanguage(language: MemesScreenModel.Language) {
    interactor.setNewLanguage(language: language)
  }
  
  func returnCurrentModel() -> MemesScreenModel {
    interactor.returnCurrentModel()
  }
  
  func updateMemes(type: [MemesScreenModel.MemesType]) {
    interactor.updateMemes(type: type)
  }
}

// MARK: - MemesScreenViewOutput

extension MemesScreenViewController: MemesScreenViewOutput {
  func generateButtonAction() {
    interactor.generateButtonAction()
    moduleView.startLoader()
  }
}

// MARK: - MemesScreenInteractorOutput

extension MemesScreenViewController: MemesScreenInteractorOutput {
  func somethingWentWrong() {
    moduleOutput?.somethingWentWrong()
    moduleView.stopLoader()
  }
  
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
      UIBarButtonItem(image: appearance.settingsButtonIcon,
                      style: .plain,
                      target: self,
                      action: #selector(settingButtonAction)),
      shareButton
    ]
  }
  
  @objc
  func shareButtonAction() {
    interactor.requestPhotosStatus()
    impactFeedback.impactOccurred()
  }
  
  @objc
  func settingButtonAction() {
    moduleOutput?.settingButtonAction(model: interactor.returnCurrentModel())
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension MemesScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.memes
    let shareButtonIcon = UIImage(systemName: "square.and.arrow.up")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}

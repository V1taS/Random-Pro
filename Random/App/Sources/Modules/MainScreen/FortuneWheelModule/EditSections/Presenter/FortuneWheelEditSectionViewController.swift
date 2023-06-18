//
//  FortuneWheelEditSectionViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol FortuneWheelEditSectionModuleOutput: AnyObject {
  
  /// Была полученна новая модель данных
  ///  - Parameter model: Модель данных
  func didReceiveNew(model: FortuneWheelModel)
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol FortuneWheelEditSectionModuleInput {
  
  /// Создаем новую секцию
  ///  - Parameters:
  ///   - model: Модель данных
  func newSectionWith(model: FortuneWheelModel)
  
  /// Редактируем текущую секцию
  ///  - Parameters:
  ///   - model: Модель данных
  ///   - section: Секция
  func editCurrentSectionWith(model: FortuneWheelModel, section: FortuneWheelModel.Section)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: FortuneWheelEditSectionModuleOutput? { get set }
}

/// Готовый модуль `FortuneWheelEditSectionModule`
typealias FortuneWheelEditSectionModule = UIViewController & FortuneWheelEditSectionModuleInput

/// Презентер
final class FortuneWheelEditSectionViewController: FortuneWheelEditSectionModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: FortuneWheelEditSectionModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: FortuneWheelEditSectionInteractorInput
  private let moduleView: FortuneWheelEditSectionViewProtocol
  private let factory: FortuneWheelEditSectionFactoryInput
  private var cacheModel: FortuneWheelModel?
  private var cacheSection: FortuneWheelModel.Section?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: FortuneWheelEditSectionViewProtocol,
       interactor: FortuneWheelEditSectionInteractorInput,
       factory: FortuneWheelEditSectionFactoryInput) {
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
  
  // MARK: - Internal func
  
  func editCurrentSectionWith(model: FortuneWheelModel, section: FortuneWheelModel.Section) {
    cacheModel = model
    cacheSection = section
    interactor.editCurrentSection(section, model)
  }
  
  func newSectionWith(model: FortuneWheelModel) {
    cacheModel = model
    moduleView.updateContentWith(models: factory.createListModel(model, nil))
  }
}

// MARK: - FortuneWheelEditSectionViewOutput

extension FortuneWheelEditSectionViewController: FortuneWheelEditSectionViewOutput {
  func deleteObject(_ object: String?) {
    guard let cacheModel else {
      return
    }
    
    interactor.deleteObject(object, cacheModel)
  }
  
  func createObject(_ emoticon: Character?, _ titleSection: String?, _ textObject: String?) {
    guard let cacheModel else {
      return
    }
    interactor.createObject(emoticon, titleSection, textObject, cacheModel)
  }
}

// MARK: - FortuneWheelEditSectionInteractorOutput

extension FortuneWheelEditSectionViewController: FortuneWheelEditSectionInteractorOutput {
  func didReceive(model: FortuneWheelModel) {
    cacheModel = model
    moduleOutput?.didReceiveNew(model: model)
    let models = factory.createListModel(model, cacheSection)
    moduleView.updateContentWith(models: models)
  }
  
  func didReceiveNew(model: FortuneWheelModel) {
    cacheModel = model
    moduleOutput?.didReceiveNew(model: model)
    let models = factory.createListModel(model, cacheSection)
    moduleView.updateWheelSectionWith(models: models)
  }
}

// MARK: - FortuneWheelEditSectionFactoryOutput

extension FortuneWheelEditSectionViewController: FortuneWheelEditSectionFactoryOutput {}

// MARK: - Private

private extension FortuneWheelEditSectionViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    title = appearance.title
    navigationItem.largeTitleDisplayMode = .never
  }
}

// MARK: - Appearance

private extension FortuneWheelEditSectionViewController {
  struct Appearance {
    let title = "Заголовок"
  }
}

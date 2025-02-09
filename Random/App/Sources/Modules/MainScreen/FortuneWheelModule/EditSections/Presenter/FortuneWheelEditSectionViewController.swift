//
//  FortuneWheelEditSectionViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol FortuneWheelEditSectionModuleOutput: AnyObject {
  
  /// Была полученна новая модель данных
  ///  - Parameter model: Модель данных
  func didReceiveNew(model: FortuneWheelModel)
  
  /// Была нажата кнопка удалить все объекты
  func removeTextsButtonAction()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol FortuneWheelEditSectionModuleInput {
  
  /// Удалить все объекты
  func removeAllObjects()
  
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
typealias FortuneWheelEditSectionModule = ViewController & FortuneWheelEditSectionModuleInput

/// Презентер
final class FortuneWheelEditSectionViewController: FortuneWheelEditSectionModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: FortuneWheelEditSectionModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: FortuneWheelEditSectionInteractorInput
  private let moduleView: FortuneWheelEditSectionViewProtocol
  private let factory: FortuneWheelEditSectionFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
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
    
    setupNavBar()
    Metrics.shared.track(event: .fortuneWheelEditSectionScreenOpen)
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .fortuneWheelEditSectionScreenClose)
  }
  
  // MARK: - Internal func
  
  func editCurrentSectionWith(model: FortuneWheelModel, section: FortuneWheelModel.Section) {
    interactor.update(model: model, section: section)
    interactor.editCurrentSection(section, model)
  }
  
  func newSectionWith(model: FortuneWheelModel) {
    interactor.update(model: model, section: nil)
    moduleView.updateContentWith(models: factory.createListModel(interactor.returnSection()))
  }
  
  /// Удалить все объекты
  func removeAllObjects() {
    interactor.removeAllObjects()
  }
}

// MARK: - FortuneWheelEditSectionViewOutput

extension FortuneWheelEditSectionViewController: FortuneWheelEditSectionViewOutput {
  func editSection(title: String?) {
    interactor.editSection(title: title)
    Metrics.shared.track(event: .fortuneWheelEditSectionScreenEditSection)
  }
  
  func editEmoticon(_ emoticon: Character?) {
    interactor.editEmoticon(emoticon)
    Metrics.shared.track(event: .fortuneWheelEditSectionScreenEditEmoticon)
  }
  
  func deleteObject(_ object: String?) {
    interactor.deleteObject(object)
    Metrics.shared.track(event: .fortuneWheelEditSectionScreenDeleteObject)
  }
  
  func createObject(_ emoticon: Character?, _ titleSection: String?, _ textObject: String?) {
    interactor.createObject(emoticon, titleSection, textObject)
    Metrics.shared.track(event: .fortuneWheelEditSectionScreenCreateObject)
  }
}

// MARK: - FortuneWheelEditSectionInteractorOutput

extension FortuneWheelEditSectionViewController: FortuneWheelEditSectionInteractorOutput {
  func didReceiveNew(model: FortuneWheelModel) {
    moduleOutput?.didReceiveNew(model: model)
  }
  
  func didReceive(model: FortuneWheelModel) {
    moduleOutput?.didReceiveNew(model: model)
    let models = factory.createListModel(interactor.returnSection())
    moduleView.updateContentWith(models: models)
  }
}

// MARK: - FortuneWheelEditSectionFactoryOutput

extension FortuneWheelEditSectionViewController: FortuneWheelEditSectionFactoryOutput {}

// MARK: - Private

private extension FortuneWheelEditSectionViewController {
  func setupNavBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.removePlayersButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(removePlayersButtonAction))
  }

  @objc
  func removePlayersButtonAction() {
    moduleOutput?.removeTextsButtonAction()
    impactFeedback.impactOccurred()
    Metrics.shared.track(event: .fortuneWheelEditSectionScreenButtonNavigationRemoveItem)
  }
}

// MARK: - Appearance

private extension FortuneWheelEditSectionViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.addItems
    let removePlayersButtonIcon = UIImage(systemName: "trash")
  }
}

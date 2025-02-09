//
//  FortuneWheelSelectedSectionViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol FortuneWheelSelectedSectionModuleOutput: AnyObject {
  
  /// Модуль был закрыт
  func closeButtonAction()
  
  /// Была полученна новая модель данных
  ///  - Parameter model: Модель данных
  func didReceiveNew(model: FortuneWheelModel)
  
  /// Редактируем текущую секцию
  ///  - Parameters:
  ///   - section: Секция
  func editCurrentSectionWith(section: FortuneWheelModel.Section)
  
  /// Создать новую секцию
  func createNewSection()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol FortuneWheelSelectedSectionModuleInput {
  
  /// Установить настройки по умолчанию
  ///  - Parameter model: Модель данных
  func setDefault(model: FortuneWheelModel)
  
  /// Запросить текущую модель
  func returnCurrentModel() -> FortuneWheelModel?
  
  /// Способ отерытия экрана
  var isPushViewController: Bool { get set }
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: FortuneWheelSelectedSectionModuleOutput? { get set }
}

/// Готовый модуль `FortuneWheelSelectedSectionModule`
typealias FortuneWheelSelectedSectionModule = ViewController & FortuneWheelSelectedSectionModuleInput

/// Презентер
final class FortuneWheelSelectedSectionViewController: FortuneWheelSelectedSectionModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: FortuneWheelSelectedSectionModuleOutput?
  var isPushViewController: Bool = false
  
  // MARK: - Private properties
  
  private let interactor: FortuneWheelSelectedSectionInteractorInput
  private let moduleView: FortuneWheelSelectedSectionViewProtocol
  private let factory: FortuneWheelSelectedSectionFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: FortuneWheelSelectedSectionViewProtocol,
       interactor: FortuneWheelSelectedSectionInteractorInput,
       factory: FortuneWheelSelectedSectionFactoryInput) {
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
    Metrics.shared.track(event: .fortuneWheelSelectedSectionScreenOpen)
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .fortuneWheelSelectedSectionScreenClose)
  }
  
  // MARK: - Internal func
  
  func returnCurrentModel() -> FortuneWheelModel? {
    return interactor.returnModel()
  }
  
  func setDefault(model: FortuneWheelModel) {
    var model = model
    if model.sections.count == 1, let firstSection = model.sections.first {
      let newFirstSection: FortuneWheelModel.Section = .init(
        isSelected: true,
        title: firstSection.title,
        icon: firstSection.icon,
        objects: firstSection.objects
      )
      model.sections = [newFirstSection]
    }
    
    interactor.update(model: model)
    let models = factory.createListModel(model)
    moduleView.updateContentWith(models: models)
  }
}

// MARK: - FortuneWheelSelectedSectionViewOutput

extension FortuneWheelSelectedSectionViewController: FortuneWheelSelectedSectionViewOutput {
  func deleteSection(_ section: FortuneWheelModel.Section) {
    interactor.deleteSection(section)
    Metrics.shared.track(event: .fortuneWheelSelectedSectionScreenDeleteSection)
  }
  
  func editCurrentSectionWith(section: FortuneWheelModel.Section) {
    moduleOutput?.editCurrentSectionWith(section: section)
    Metrics.shared.track(
      event: .fortuneWheelSelectedSectionScreenEditCurrentSection,
      properties: ["section": section.title]
    )
  }
  
  func sectionSelected(_ section: FortuneWheelModel.Section) {
    interactor.sectionSelected(section)
    Metrics.shared.track(
      event: .fortuneWheelSelectedSectionScreenSectionSelected,
      properties: ["section": section.title]
    )
  }
}

// MARK: - FortuneWheelSelectedSectionInteractorOutput

extension FortuneWheelSelectedSectionViewController: FortuneWheelSelectedSectionInteractorOutput {
  func didReceive(model: FortuneWheelModel) {
    moduleOutput?.didReceiveNew(model: model)
    let models = factory.createListModel(model)
    moduleView.updateContentWith(models: models)
  }
  
  func didReceiveNew(model: FortuneWheelModel) {
    moduleOutput?.didReceiveNew(model: model)
    let models = factory.createListModel(model)
    moduleView.updateWheelSectionWith(models: models)
  }
}

// MARK: - FortuneWheelSelectedSectionFactoryOutput

extension FortuneWheelSelectedSectionViewController: FortuneWheelSelectedSectionFactoryOutput {}

// MARK: - Private

private extension FortuneWheelSelectedSectionViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    title = appearance.title
    
    if !isPushViewController {
      navigationItem.leftBarButtonItem = UIBarButtonItem(image: appearance.closeButtonIcon,
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(closeButtonAction))
    }

    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.addButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(addButtonAction))
    
    navigationItem.largeTitleDisplayMode = .never
  }
  
  @objc
  func closeButtonAction() {
    moduleOutput?.closeButtonAction()
    impactFeedback.impactOccurred()
  }
  
  @objc
  func addButtonAction() {
    moduleOutput?.createNewSection()
    impactFeedback.impactOccurred()

    Metrics.shared.track(event: .fortuneWheelSelectedSectionScreenCreateNewSection)
  }
}

// MARK: - Appearance

private extension FortuneWheelSelectedSectionViewController {
  struct Appearance {
    let closeButtonIcon = UIImage(systemName: "xmark")
    let title = RandomStrings.Localizable.sections
    let addButtonIcon = UIImage(systemName: "plus.circle")
  }
}

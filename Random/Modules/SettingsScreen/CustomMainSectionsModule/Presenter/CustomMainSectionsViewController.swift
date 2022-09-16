//
//  CustomMainSectionsViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol CustomMainSectionsModuleOutput: AnyObject {
  
  /// Данные были изменены
  ///  - Parameter models: результат генерации
  func didChanged(models: [MainScreenModel.Section])
  
  /// Получена ошибка
  func didReciveError()
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol CustomMainSectionsModuleInput {
  
  /// Обновить контент
  /// - Parameter models: Моделька секций
  func updateContentWith(models: [MainScreenModel.Section])
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: CustomMainSectionsModuleOutput? { get set }
}

/// Готовый модуль `CustomMainSectionsModule`
typealias CustomMainSectionsModule = UIViewController & CustomMainSectionsModuleInput

/// Презентер
final class CustomMainSectionsViewController: CustomMainSectionsModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: CustomMainSectionsModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: CustomMainSectionsInteractorInput
  private let moduleView: CustomMainSectionsViewProtocol
  private let factory: CustomMainSectionsFactoryInput
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(interactor: CustomMainSectionsInteractorInput,
       moduleView: CustomMainSectionsViewProtocol,
       factory: CustomMainSectionsFactoryInput) {
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
    
    setupNavBar()
  }
  
  // MARK: - Internal func
  
  func updateContentWith(models: [MainScreenModel.Section]) {
    interactor.getContent(models: models)
  }
}

// MARK: - CustomMainSectionsViewOutput

extension CustomMainSectionsViewController: CustomMainSectionsViewOutput {
  func sectionChanged(_ index: Int, type: MainScreenModel.Section) {
    interactor.sectionChanged(index, type: type)
  }
  
  func sectionChanged(_ isEnabled: Bool, type: MainScreenModel.Section) {
    interactor.sectionChanged(isEnabled, type: type)
  }
}

// MARK: - CustomMainSectionsInteractorOutput

extension CustomMainSectionsViewController: CustomMainSectionsInteractorOutput {
  func didChanged(models: [MainScreenModel.Section]) {
    moduleOutput?.didChanged(models: models)
  }
  
  func didReciveError() {
    moduleOutput?.didReciveError()
  }
  
  func didRecive(models: [MainScreenModel.Section]) {
    moduleView.updateContentWith(models: models)
  }
}

// MARK: - CustomMainSectionsFactoryOutput

extension CustomMainSectionsViewController: CustomMainSectionsFactoryOutput {}

// MARK: - Private

private extension CustomMainSectionsViewController {
  func setupNavBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
  }
}

// MARK: - Appearance

private extension CustomMainSectionsViewController {
  struct Appearance {
    let title = NSLocalizedString("Настройка секций", comment: "")
  }
}

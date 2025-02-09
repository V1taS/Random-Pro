//
//  CustomMainSectionsViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit
import FancyUIKit
import FancyStyle
import SKAbstractions

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol CustomMainSectionsModuleOutput: AnyObject {
  
  /// Данные были изменены
  ///  - Parameter models: результат генерации
  func didChanged(models: [MainScreenModel.Section])
  
  /// Получена ошибка
  func didReceiveError()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol CustomMainSectionsModuleInput {
  
  /// Обновить контент
  /// - Parameter models: Моделька секций
  func updateContentWith(models: [MainScreenModel.Section])
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: CustomMainSectionsModuleOutput? { get set }
}

/// Готовый модуль `CustomMainSectionsModule`
typealias CustomMainSectionsModule = ViewController & CustomMainSectionsModuleInput

/// Презентер
final class CustomMainSectionsViewController: CustomMainSectionsModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: CustomMainSectionsModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: CustomMainSectionsInteractorInput
  private let moduleView: CustomMainSectionsViewProtocol
  private let factory: CustomMainSectionsFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: CustomMainSectionsViewProtocol,
       interactor: CustomMainSectionsInteractorInput,
       factory: CustomMainSectionsFactoryInput) {
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
    Metrics.shared.track(event: .customMainSectionsScreenOpen)
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .customMainSectionsScreenClose)
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
    Metrics.shared.track(
      event: .customMainSectionsScreenSectionChanged,
      properties: [
        "type": type.type.rawValue,
        "index": "\(index)"
      ]
    )
  }
  
  func sectionChanged(_ isEnabled: Bool, type: MainScreenModel.Section) {
    interactor.sectionChanged(isEnabled, type: type)
    Metrics.shared.track(
      event: .customMainSectionsScreenSectionChanged,
      properties: [
        "type": type.type.rawValue,
        "isEnabled": "\(isEnabled)"
      ]
    )
  }
}

// MARK: - CustomMainSectionsInteractorOutput

extension CustomMainSectionsViewController: CustomMainSectionsInteractorOutput {
  func didChanged(models: [MainScreenModel.Section]) {
    moduleOutput?.didChanged(models: models)
  }
  
  func didReceiveError() {
    moduleOutput?.didReceiveError()
  }
  
  func didReceive(models: [MainScreenModel.Section]) {
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
    let title = RandomStrings.Localizable.sectionSettings
  }
}

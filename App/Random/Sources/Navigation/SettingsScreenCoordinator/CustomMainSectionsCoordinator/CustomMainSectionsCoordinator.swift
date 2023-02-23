//
//  CustomMainSectionsCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import CustomMainSectionsModule
import ApplicationInterface

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol CustomMainSectionsCoordinatorOutput: AnyObject {
  
  /// Данные были изменены
  ///  - Parameter models: результат генерации
  func didChanged(models: [MainScreenSectionProtocol])
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol CustomMainSectionsCoordinatorInput {
  
  /// Обновить контент
  /// - Parameter models: Моделька секций
  func updateContentWith(models: [MainScreenSectionProtocol])
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: CustomMainSectionsCoordinatorOutput? { get set }
}

typealias CustomMainSectionsCoordinatorProtocol = CustomMainSectionsCoordinatorInput & Coordinator

final class CustomMainSectionsCoordinator: CustomMainSectionsCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: CustomMainSectionsCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var customMainSectionsModule: CustomMainSectionsModule?
  private let services: ApplicationServices
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  ///   - services: Сервисы приложения
  init(_ navigationController: UINavigationController,
       _ services: ApplicationServices) {
    self.navigationController = navigationController
    self.services = services
  }
  
  // MARK: - Internal func
  
  func start() {
    let customMainSectionsModule = CustomMainSectionsAssembly().createModule()
    self.customMainSectionsModule = customMainSectionsModule
    self.customMainSectionsModule?.moduleOutput = self
    
    navigationController.pushViewController(customMainSectionsModule, animated: true)
  }
  
  func updateContentWith(models: [MainScreenSectionProtocol]) {
    customMainSectionsModule?.updateContentWith(models: models)
  }
}

// MARK: - CustomMainSectionsModuleOutput

extension CustomMainSectionsCoordinator: CustomMainSectionsModuleOutput {
  func didReceiveError() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func didChanged(models: [MainScreenSectionProtocol]) {
    output?.didChanged(models: models)
  }
}

// MARK: - Appearance

private extension CustomMainSectionsCoordinator {
  struct Appearance {
    let somethingWentWrong = NSLocalizedString("Что-то пошло не так", comment: "")
  }
}

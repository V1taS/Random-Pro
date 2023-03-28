//
//  CustomMainSectionsCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import MainScreenModule
import NotificationService

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol CustomMainSectionsCoordinatorOutput: AnyObject {
  
  /// Данные были изменены
  ///  - Parameter models: результат генерации
  func didChanged(models: [MainScreenModel.Section])
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol CustomMainSectionsCoordinatorInput {
  
  /// Обновить контент
  /// - Parameter models: Моделька секций
  func updateContentWith(models: [MainScreenModel.Section])
  
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
  private let notificationService = NotificationServiceImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let customMainSectionsModule = CustomMainSectionsAssembly().createModule()
    self.customMainSectionsModule = customMainSectionsModule
    self.customMainSectionsModule?.moduleOutput = self
    
    navigationController.pushViewController(customMainSectionsModule, animated: true)
  }
  
  func updateContentWith(models: [MainScreenModel.Section]) {
    customMainSectionsModule?.updateContentWith(models: models)
  }
}

// MARK: - CustomMainSectionsModuleOutput

extension CustomMainSectionsCoordinator: CustomMainSectionsModuleOutput {
  func didReceiveError() {
    notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                              glyph: true,
                                              timeout: nil,
                                              active: {})
  }
  
  func didChanged(models: [MainScreenModel.Section]) {
    output?.didChanged(models: models)
  }
}

// MARK: - Appearance

private extension CustomMainSectionsCoordinator {
  struct Appearance {
    let somethingWentWrong = NSLocalizedString("Что-то пошло не так", comment: "")
  }
}

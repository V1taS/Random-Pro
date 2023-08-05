//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

import UIKit

/// Псевдоним протокола Coordinator & ___FILEBASENAMEASIDENTIFIER___Input
typealias ___FILEBASENAMEASIDENTIFIER___Protocol = Coordinator & ___FILEBASENAMEASIDENTIFIER___Input

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol ___FILEBASENAMEASIDENTIFIER___Output: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol ___FILEBASENAMEASIDENTIFIER___Input {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: ___FILEBASENAMEASIDENTIFIER___Output? { get set }
}

// MARK: - ___VARIABLE_productName:identifier___Coordinator

/// Координатор `___VARIABLE_productName:identifier___`
final class ___VARIABLE_productName:identifier___Coordinator: ___FILEBASENAMEASIDENTIFIER___Protocol {
  
  // MARK: - Internal variables
  
  weak var output: ___FILEBASENAMEASIDENTIFIER___Output?
  
  // MARK: - Private property
  
  private var module: ___VARIABLE_productName:identifier___Module?
  private var navigationController: UINavigationController
  private let services: ApplicationServices
  
  // MARK: - Initialisation
  
  /// Ининциализатор
  /// - Parameters:
  ///   - navigationController: Навигейшн контроллер
  ///   - services: Сервисы приложения
  init(navigationController: UINavigationController,
       services: ApplicationServices) {
    self.navigationController = navigationController
    self.services = services
  }
  
  // MARK: - Life cycle
  
  func start() {
    let module = ___VARIABLE_productName:identifier___Assembly().createModule()
    self.module = module
    self.module?.moduleOutput = self
    navigationController.pushViewController(module, animated: true)
  }
}

// MARK: - ___VARIABLE_productName:identifier___ModuleOutput

extension ___VARIABLE_productName:identifier___Coordinator: ___VARIABLE_productName:identifier___ModuleOutput {}

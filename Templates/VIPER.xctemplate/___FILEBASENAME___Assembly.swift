//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

import UIKit

/// Сборщик `___VARIABLE_productName___`
final class ___FILEBASENAMEASIDENTIFIER___ {
  
  /// Собирает модуль `___VARIABLE_productName___`
  /// - Returns: Cобранный модуль `___VARIABLE_productName___`
  func createModule() -> ___VARIABLE_productName___Module {
    let interactor = ___VARIABLE_productName___Interactor()
    let view = ___VARIABLE_productName___View()
    let factory = ___VARIABLE_productName___Factory()
    let presenter = ___VARIABLE_productName___ViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}

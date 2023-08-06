//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `___VARIABLE_productName___Module` в `Coordinator`
public protocol ___VARIABLE_productName___ModuleOutput: AnyObject {}

/// События которые отправляем из `Coordinator` в `___VARIABLE_productName___Module`
public protocol ___VARIABLE_productName___ModuleInput {

  /// События которые отправляем из `___VARIABLE_productName___Module` в `Coordinator`
  var moduleOutput: ___VARIABLE_productName___ModuleOutput? { get set }
}

/// Готовый модуль `___VARIABLE_productName___Module`
public typealias ___VARIABLE_productName___Module = ViewController & ___VARIABLE_productName___ModuleInput

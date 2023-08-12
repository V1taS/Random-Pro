//
//  ForceUpdateAppAbstractions.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `ForceUpdateAppModule` в `Coordinator`
public protocol ForceUpdateAppModuleOutput: AnyObject {
  
  /// Обновить приложение
  func updateButtonAction()
  
  /// Модуль был закрыт
  func closeModuleAction()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `Coordinator` в `ForceUpdateAppModule`
public protocol ForceUpdateAppModuleInput {

  /// События которые отправляем из `ForceUpdateAppModule` в `Coordinator`
  var moduleOutput: ForceUpdateAppModuleOutput? { get set }
}

/// Готовый модуль `ForceUpdateAppModule`
public typealias ForceUpdateAppModule = ViewController & ForceUpdateAppModuleInput

//
//  AppUnavailableAbstractions.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import UIKit

/// События которые отправляем из `AppUnavailableModule` в `Coordinator`
public protocol AppUnavailableModuleOutput: AnyObject {
  
  /// Кнопка обратной связи была нажата
  func feedBackButtonAction()
}

/// События которые отправляем из `Coordinator` в `AppUnavailableModule`
public protocol AppUnavailableModuleInput {

  /// События которые отправляем из `AppUnavailableModule` в `Coordinator`
  var moduleOutput: AppUnavailableModuleOutput? { get set }
}

/// Готовый модуль `AppUnavailableModule`
public typealias AppUnavailableModule = UIViewController & AppUnavailableModuleInput

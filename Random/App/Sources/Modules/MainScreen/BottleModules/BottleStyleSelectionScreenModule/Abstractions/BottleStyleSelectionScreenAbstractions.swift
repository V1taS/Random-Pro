//
//  BottleStyleSelectionScreenAbstractions.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import UIKit
import FancyUIKit

/// События которые отправляем из `BottleStyleSelectionScreenModule` в `Coordinator`
public protocol BottleStyleSelectionScreenModuleOutput: AnyObject {

  /// Нет премиум доступа
  func noPremiumAccessAction()

  /// Успешно выбран стиль бутылочки
  func didSelectStyleSuccessfully()

  /// Модуль закрыт
  func moduleClosed()
}

/// События которые отправляем из `Coordinator` в `BottleStyleSelectionScreenModule`
public protocol BottleStyleSelectionScreenModuleInput {

  /// События которые отправляем из `BottleStyleSelectionScreenModule` в `Coordinator`
  var moduleOutput: BottleStyleSelectionScreenModuleOutput? { get set }
}

/// Готовый модуль `BottleStyleSelectionScreenModule`
public typealias BottleStyleSelectionScreenModule = ViewController & BottleStyleSelectionScreenModuleInput

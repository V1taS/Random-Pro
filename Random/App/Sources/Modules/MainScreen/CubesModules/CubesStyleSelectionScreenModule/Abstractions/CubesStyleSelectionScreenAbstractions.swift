//
//  CubesStyleSelectionScreenAbstractions.swift
//  Random
//
//  Created by Сергей Юханов on 11.10.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit

/// События которые отправляем из `BottleStyleSelectionScreenModule` в `Coordinator`
public protocol CubesStyleSelectionScreenModuleOutput: AnyObject {

  /// Нет премиум доступа
  func noPremiumAccessAction()

  /// Успешно выбран стиль бутылочки
  func didSelectStyleSuccessfully()

  /// Модуль закрыт
  func moduleClosed()
}

/// События которые отправляем из `Coordinator` в `BottleStyleSelectionScreenModule`
public protocol CubesStyleSelectionScreenModuleInput {

  /// События которые отправляем из `BottleStyleSelectionScreenModule` в `Coordinator`
  var moduleOutput: CubesStyleSelectionScreenModuleOutput? { get set }
}

/// Готовый модуль `BottleStyleSelectionScreenModule`
public typealias CubesStyleSelectionScreenModule = ViewController & CubesStyleSelectionScreenModuleInput

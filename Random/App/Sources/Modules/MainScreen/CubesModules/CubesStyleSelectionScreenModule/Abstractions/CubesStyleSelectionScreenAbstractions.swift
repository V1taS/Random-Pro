//
//  CubesStyleSelectionScreenAbstractions.swift
//  Random
//
//  Created by Сергей Юханов on 11.10.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit

/// События которые отправляем из `CubesStyleSelectionScreenModule` в `Coordinator`
public protocol CubesStyleSelectionScreenModuleOutput: AnyObject {

  /// Нет премиум доступа
  func noPremiumAccessAction()

  /// Успешно выбран стиль бутылочки
  func didSelectStyleSuccessfully()

  /// Модуль закрыт
  func moduleClosed()
}

/// События которые отправляем из `Coordinator` в `CubesStyleSelectionScreenModule`
public protocol CubesStyleSelectionScreenModuleInput {

  /// События которые отправляем из `CubesStyleSelectionScreenModule` в `Coordinator`
  var moduleOutput: CubesStyleSelectionScreenModuleOutput? { get set }
}

/// Готовый модуль `CubesStyleSelectionScreenModule`
public typealias CubesStyleSelectionScreenModule = ViewController & CubesStyleSelectionScreenModuleInput

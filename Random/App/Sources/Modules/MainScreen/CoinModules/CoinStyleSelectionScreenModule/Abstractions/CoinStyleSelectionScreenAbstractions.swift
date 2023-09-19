//
//  CoinStyleSelectionScreenAbstractions.swift
//  Random
//
//  Created by Artem Pavlov on 19.09.2023.
//

import UIKit
import FancyUIKit

/// События которые отправляем из `CoinStyleSelectionScreenModule` в `Coordinator`
public protocol CoinStyleSelectionScreenModuleOutput: AnyObject {

  /// Модуль закрыт
  func moduleClosed()
}

/// События которые отправляем из `Coordinator` в `CoinStyleSelectionScreenModule`
public protocol CoinStyleSelectionScreenModuleInput {

  /// События которые отправляем из `CoinStyleSelectionScreenModule` в `Coordinator`
  var moduleOutput: CoinStyleSelectionScreenModuleOutput? { get set }
}

/// Готовый модуль `CoinStyleSelectionScreenModule`
public typealias CoinStyleSelectionScreenModule = ViewController & CoinStyleSelectionScreenModuleInput

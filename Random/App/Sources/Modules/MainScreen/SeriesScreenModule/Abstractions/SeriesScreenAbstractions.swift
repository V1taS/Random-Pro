//
//  SeriesScreenAbstractions.swift
//  Random
//
//  Created by Артем Павлов on 13.11.2023.
//

import UIKit
import FancyUIKit

/// События которые отправляем из `SeriesScreenModule` в `Coordinator`
public protocol SeriesScreenModuleOutput: AnyObject {}

/// События которые отправляем из `Coordinator` в `SeriesScreenModule`
public protocol SeriesScreenModuleInput {

  /// События которые отправляем из `SeriesScreenModule` в `Coordinator`
  var moduleOutput: SeriesScreenModuleOutput? { get set }
}

/// Готовый модуль `SeriesScreenModule`
public typealias SeriesScreenModule = ViewController & SeriesScreenModuleInput

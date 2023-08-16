//
//  BottleStyleSelectionAbstractions.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import UIKit
import FancyUIKit

/// События которые отправляем из `BottleStyleSelectionModule` в `Coordinator`
public protocol BottleStyleSelectionModuleOutput: AnyObject {}

/// События которые отправляем из `Coordinator` в `BottleStyleSelectionModule`
public protocol BottleStyleSelectionModuleInput {

  /// События которые отправляем из `BottleStyleSelectionModule` в `Coordinator`
  var moduleOutput: BottleStyleSelectionModuleOutput? { get set }
}

/// Готовый модуль `BottleStyleSelectionModule`
public typealias BottleStyleSelectionModule = ViewController & BottleStyleSelectionModuleInput

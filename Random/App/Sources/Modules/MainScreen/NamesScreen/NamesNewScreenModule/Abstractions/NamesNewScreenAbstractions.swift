//
//  NamesNewScreenAbstractions.swift
//  Random
//
//  Created by Vitalii Sosin on 8.02.2025.
//

import SwiftUI

/// События которые отправляем из `NamesNewScreenModule` в `Coordinator`
public protocol NamesNewScreenModuleOutput: AnyObject {}

/// События которые отправляем из `Coordinator` в `NamesNewScreenModule`
public protocol NamesNewScreenModuleInput {

  /// События которые отправляем из `NamesNewScreenModule` в `Coordinator`
  var moduleOutput: NamesNewScreenModuleOutput? { get set }
}

/// Готовый модуль `NamesNewScreenModule`
public typealias NamesNewScreenModule = (viewController: UIViewController, input: NamesNewScreenModuleInput)

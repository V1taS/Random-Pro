//
//  SeriesScreenAbstractions.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//

import FancyUIKit

/// События которые отправляем из `SeriesScreenModule` в `Coordinator`
public protocol SeriesScreenModuleOutput: AnyObject {

  /// Что-то пошло не так
  func somethingWentWrong()

  /// Проиграть трайлер по ссылке
  ///  - Parameter url: Ссылка на трейлер
  func playTrailerActionWith(url: String)

  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `Coordinator` в `SeriesScreenModule`
public protocol SeriesScreenModuleInput {

  /// События которые отправляем из `SeriesScreenModule` в `Coordinator`
  var moduleOutput: SeriesScreenModuleOutput? { get set }
}

/// Готовый модуль `SeriesScreenModule`
public typealias SeriesScreenModule = ViewController & SeriesScreenModuleInput

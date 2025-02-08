//
//  SceneViewModel.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 17.04.2024.
//

import SwiftUI

// MARK: - SceneViewModel

/// Протокол `SceneViewModel` определяет интерфейс для модели представления,
/// управляющей основными аспектами пользовательского интерфейса в сцене.
public protocol SceneViewModel {
  
  // MARK: - The lifecycle of a UIViewController
  
  /// Вызывается после загрузки представления.
  var viewDidLoad: (() -> Void)? { get set }
  
  /// Вызывается перед появлением представления на экране.
  var viewWillAppear: (() -> Void)? { get set }
  
  /// Вызывается в процессе появления представления на экране.
  var viewIsAppearing: (() -> Void)? { get set }
  
  /// Вызывается перед расстановкой подпредставлений.
  var viewWillLayoutSubviews: (() -> Void)? { get set }
  
  /// Вызывается после расстановки подпредставлений.
  var viewDidLayoutSubviews: (() -> Void)? { get set }
  
  /// Вызывается после того как представление появилось на экране.
  var viewDidAppear: (() -> Void)? { get set }
  
  /// Вызывается перед тем как представление будет скрыто с экрана.
  var viewWillDisappear: (() -> Void)? { get set }
  
  /// Вызывается после того как представление было скрыто с экрана.
  var viewDidDisappear: (() -> Void)? { get set }
  
  /// Вызывается перед удалением объекта из памяти.
  var deinitAction: (() -> Void)? { get set }
  
  // MARK: - General
  
  /// Заголовок сцены, отображаемый в навигационной панели.
  var sceneTitle: String? { get }
  
  /// Режим отображения большого заголовка в навигационной панели.
  var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode { get }
  
  /// Левая кнопка в навигационной панели.
  var leftBarButtonItems: [SKBarButtonItem] { get }
  
  /// Центральная кнопка в навигационной панели по умолчанию отсутствует.
  var centerBarButtonItem: SKBarButtonViewType? { get }
  
  /// Правая кнопка в навигационной панели.
  var rightBarButtonItems: [SKBarButtonItem] { get }
  
  /// Предпочитаемый стиль строки состояния.
  var preferredStatusBarStyle: UIStatusBarStyle { get }
  
  /// Определяет, является ли навигационная панель прозрачной.
  var isNavigationBarTranslucent: Bool { get }
  
  /// Определяет, отображается ли навигационная панель.
  var isNavigationBarHidden: Bool { get }
  
  /// Определяет, заканчивает ли редактирование приложение, отправляя действие resignFirstResponder.
  var isEndEditing: Bool { get }
  
  // MARK: - Appearance
  
  /// Цвет фона сцены.
  var backgroundColor: UIColor? { get }
}

// MARK: - Default value

/// Расширение `SceneViewModel`, предоставляющее значения по умолчанию для всех свойств протокола.
public extension SceneViewModel {
  
  // MARK: - The lifecycle of a UIViewController
  
  /// Вызывается перед появлением представления на экране.
  var viewWillAppear: (() -> Void)? {
    get { nil } set {}
  }
  
  /// Вызывается в процессе появления представления на экране.
  var viewIsAppearing: (() -> Void)? {
    get { nil } set {}
  }
  
  /// Вызывается перед расстановкой подпредставлений.
  var viewWillLayoutSubviews: (() -> Void)? {
    get { nil } set {}
  }
  
  /// Вызывается после расстановки подпредставлений.
  var viewDidLayoutSubviews: (() -> Void)? {
    get { nil } set {}
  }
  
  /// Вызывается после того как представление появилось на экране.
  var viewDidAppear: (() -> Void)? {
    get { nil } set {}
  }
  
  /// Вызывается перед тем как представление будет скрыто с экрана.
  var viewWillDisappear: (() -> Void)? {
    get { nil } set {}
  }
  
  /// Вызывается после того как представление было скрыто с экрана.
  var viewDidDisappear: (() -> Void)? {
    get { nil } set {}
  }
  
  /// Вызывается перед удалением объекта из памяти.
  var deinitAction: (() -> Void)? {
    get { nil } set {}
  }
  
  // MARK: - General
  
  /// Возвращает `nil`, так как заголовок сцены по умолчанию отсутствует.
  var sceneTitle: String? {
    nil
  }
  
  /// Режим отображения большого заголовка по умолчанию - никогда не отображается.
  var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode {
    .never
  }
  
  /// Кнопки слева в навигационной панели по умолчанию отсутствует.
  var leftBarButtonItems: [SKBarButtonItem] {
    []
  }
  
  /// Центральная кнопка в навигационной панели по умолчанию отсутствует.
  var centerBarButtonItem: SKBarButtonViewType? {
    .none
  }
  
  /// Кнопки справа в навигационной панели по умолчанию отсутствует.
  var rightBarButtonItems: [SKBarButtonItem] {
    []
  }
  
  /// Предпочитаемый стиль строки состояния по умолчанию - стандартный.
  var preferredStatusBarStyle: UIStatusBarStyle {
    .default
  }
  
  /// По умолчанию навигационная панель является прозрачной.
  var isNavigationBarTranslucent: Bool {
    true
  }
  
  /// По умолчанию навигационная панель отображается.
  var isNavigationBarHidden: Bool {
    false
  }
  
  /// По умолчанию приложение не завершает редактирование.
  var isEndEditing: Bool {
    false
  }
  
  // MARK: - Appearance
  
  /// Цвет фона сцены.
  var backgroundColor: UIColor? { nil }
}

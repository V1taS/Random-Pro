//
//  LaunchScreenManager.swift
//  Random
//
//  Created by Vitalii Sosin on 23.10.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyStyle

final class LaunchScreenManager {
  
  // MARK: - Singleton
  
  static let shared = LaunchScreenManager()
  
  // MARK: - Private Properties
  
  private var overlayWindow: UIWindow?
  private let launchImage: UIImage? = RandomAsset.launchMainScreenImageNew.image
  
  // MARK: - Initialization
  
  private init() {}
  
  // MARK: - Public Methods
  
  /// Запуск экрана запуска
  func startLaunchScreen() {
    print("LaunchScreenManager: startLaunchScreen вызван")
    
    // Проверяем, что окно наложения еще не создано
    guard overlayWindow == nil else {
      print("LaunchScreenManager: overlayWindow уже существует")
      return
    }
    
    // Проверяем наличие изображения
    guard let launchImage = launchImage else {
      print("LaunchScreenManager: launchImage не найдено")
      return
    }
    
    // Получаем активную сцену
    guard let windowScene = UIApplication.shared.connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
      print("LaunchScreenManager: активная UIWindowScene не найдена")
      return
    }
    
    // Создаем новое окно для наложения
    let window = UIWindow(windowScene: windowScene)
    window.frame = windowScene.coordinateSpace.bounds
    window.backgroundColor = .clear
    window.windowLevel = UIWindow.Level.alert + 1 // Устанавливаем высокий уровень окна
    
    // Создаем и настраиваем ImageView для наложения
    let imageView = UIImageView(image: launchImage)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    imageView.alpha = 1.0 // Показываем сразу
    
    // Создаем корневой контроллер для окна наложения
    let rootViewController = UIViewController()
    rootViewController.view.addSubview(imageView)
    
    // Устанавливаем ограничения, чтобы покрыть всё окно
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: rootViewController.view.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: rootViewController.view.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: rootViewController.view.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: rootViewController.view.trailingAnchor)
    ])
    
    window.rootViewController = rootViewController
    window.isHidden = false
    overlayWindow = window
    
    print("LaunchScreenManager: overlayWindow создан и отображается")
  }
  
  /// Остановка экрана запуска
  func stopLaunchScreen() {
    print("LaunchScreenManager: stopLaunchScreen вызван")
    
    guard let window = overlayWindow else {
      print("LaunchScreenManager: overlayWindow не существует")
      return
    }
    
    // Анимируем плавное исчезновение
    UIView.animate(withDuration: 0.3, animations: {
      window.alpha = 0.0
    }) { _ in
      window.isHidden = true
      self.overlayWindow = nil
      print("LaunchScreenManager: overlayWindow скрыт и удалён")
    }
  }
}

//
//  Coordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import Foundation

protocol Coordinator {
  
  ///  Запуск координатора
  func start()
  
  /// Завершение сценария
  var finishFlow: (() -> Void)? { get set }
}

//
//  ButtonCounterService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public protocol ButtonCounterService {

  /// Действие на нажатие кнопки
  var clickResponse: ((_ clickCount: Int) -> Void)? { get set }

  /// Сохраняем нажатие
  func onButtonClick()
}

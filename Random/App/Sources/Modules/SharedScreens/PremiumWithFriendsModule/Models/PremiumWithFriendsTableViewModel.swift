//
//  PremiumWithFriendsTableViewModel.swift
//  Random
//
//  Created by Vitalii Sosin on 30.07.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum PremiumWithFriendsTableViewModel {
  
  /// Реверальная ссылка
  case referal(_ lottieAnimationJSONName: String,
               title: String,
               firstStepTitle: String,
               link: String,
               secondStepTitle: String,
               circleStepsTitle: String,
               currentStep: Int,
               maxSteps: Int)
  
  /// Текст
  case text(String?)
  
  /// Секция отступа
  case insets(Double)
  
  /// Маленькая кнопка
  case smallButton(_ title: String)
  
  /// Разделитель
  case divider
}

//
//  CubesScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

struct CubesScreenModel: UserDefaultsCodable {
  
  /// Список результатов
  let listResult: [String]
  
  /// Показать список результатов
  let isShowlistGenerated: Bool

  /// Стиль кубиков
  let cubesStyle: CubesStyleSelectionScreenModel.CubesStyle
  
  /// Тип кубиков
  let cubesType: CubesType
  
  /// Тип кубиков
  enum CubesType: Int, UserDefaultsCodable {
    
    /// Один кубик
    case cubesOne
    
    /// Два кубика
    case cubesTwo
    
    /// Три кубика
    case cubesThree
    
    /// Четыре кубика
    case cubesFour
    
    /// Пять кубиков
    case cubesFive
    
    /// Шесть кубиков
    case cubesSix
  }
}

//
//  CubesScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

struct CubesScreenModel: UserDefaultsCodable {
  
  /// Список результатов
  let listResult: [String]
  
  /// Количество кубиков (1-6)
  let selectedCountCubes: Int
  
  /// Тип кубиков
  let cubesType: CubesType
  
  /// Тип кубиков
  enum CubesType: UserDefaultsCodable {
    
    /// Один кубик
    case cubesOne(Int)
    
    /// Два кубика
    case cubesTwo(cubesOne: Int, cubesTwo: Int)
    
    /// Три кубика
    case cubesThree(cubesOne: Int, cubesTwo: Int, cubesThree: Int)
    
    /// Четыре кубика
    case cubesFour(cubesOne: Int, cubesTwo: Int, cubesThree: Int,
                   cubesFour: Int)
    
    /// Пять кубиков
    case cubesFive(cubesOne: Int, cubesTwo: Int, cubesThree: Int,
                   cubesFour: Int, cubesFive: Int)
    
    /// Шесть кубиков
    case cubesSix(cubesOne: Int, cubesTwo: Int, cubesThree: Int,
                  cubesFour: Int, cubesFive: Int, cubesSix: Int)
  }
}

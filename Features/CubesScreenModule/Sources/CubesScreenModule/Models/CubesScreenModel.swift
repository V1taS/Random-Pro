//
//  CubesScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - CubesScreenModel

public struct CubesScreenModel: Codable {
  
  /// Список результатов
  public let listResult: [String]
  
  /// Показать список результатов
  public let isShowlistGenerated: Bool
  
  /// Тип кубиков
  public let cubesType: CubesType
  
  // MARK: - CubesType
  
  /// Тип кубиков
  public enum CubesType: Int, Codable {
    
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

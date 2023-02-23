//
//  CubesScreenModelProtocol.swift
//  ApplicationModels
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - CubesScreenModelProtocol

public protocol CubesScreenModelProtocol {
  
  /// Список результатов
  var listResult: [String] { get }
  
  /// Показать список результатов
  var isShowlistGenerated: Bool { get }
  
  /// Тип кубиков
  var cubesType: CubesScreenCubesTypeProtocol { get }
}

// MARK: - CubesScreenCubesTypeProtocol

public protocol CubesScreenCubesTypeProtocol {
  
  /// Один кубик
  static var cubesOne: Self { get }
  
  /// Два кубика
  static var cubesTwo: Self { get }
  
  /// Три кубика
  static var cubesThree: Self { get }
  
  /// Четыре кубика
  static var cubesFour: Self { get }
  
  /// Пять кубиков
  static var cubesFive: Self { get }
  
  /// Шесть кубиков
  static var cubesSix: Self { get }
}

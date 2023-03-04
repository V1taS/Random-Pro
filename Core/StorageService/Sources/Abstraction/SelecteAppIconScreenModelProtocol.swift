//
//  SelecteAppIconScreenModelProtocol.swift
//  StorageService
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - SelecteAppIconScreenModelProtocol

public protocol SelecteAppIconScreenModelProtocol {
  
  /// Выбранная иконка
  var selecteAppIconType: SelecteAppIconScreenTypeProtocol { get }
}

// MARK: - SelecteAppIconScreenModelProtocol

public protocol SelecteAppIconScreenTypeProtocol {
  
  /// Иконка цвета
  var imageName: String { get }
  
  /// Название цвета
  var title: String { get }
  
  /// Стандартная иконка
  static var defaultIcon: Self { get }
  
  /// Гелиотроп
  static var heliotrope: Self { get }
  
  /// Литий
  static var lithium: Self { get }
  
  /// Оранжевое удовольствие
  static var orangeFun: Self { get }
  
  /// Полуночный Город
  static var midnightCity: Self { get }
  
  /// Морская фуксия
  static var marineFuchsia: Self { get }
  
  /// Терминал
  static var terminal: Self { get }
  
  /// Морозное небо
  static var frostySky: Self { get }
  
  /// Харви
  static var harvey: Self { get }
  
  /// Красный город грехов
  static var sinCityRed: Self { get }
  
  /// Фиолотово-лимонный
  static var violetLemon: Self { get }
  
  /// Малиновый прилив
  static var crimsonTide: Self { get }
  
  /// Залитый лунным светом астероид
  static var moonlitAsteroid: Self { get }
  
  /// Серый
  static var gradeGrey: Self { get }
  
  /// Летняя собака
  static var summerDog: Self { get }
  
  /// Голубая малина
  static var blueRaspberry: Self { get }
  
  /// Вечерняя ночь
  static var eveningNight: Self { get }
  
  /// Красный лайм
  static var redLime: Self { get }
  
  /// Песчаная пустыня
  static var sandyDesert: Self { get }
  
  /// Чистая похоть
  static var pureLust: Self { get }
  
  /// Авокадо
  static var avocado: Self { get }
  
  /// Лунный фиолетовый
  static var moonPurple: Self { get }
  
  /// Селен
  static var selenium: Self { get }
  
  /// Ожерелье королевы
  static var queensNecklace: Self { get }
}


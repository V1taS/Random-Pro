//
//  SettingsScreenCell.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

// MARK: - SettingsScreenCell

enum SettingsScreenCell: CaseIterable {
  
  /// Массив всех кейсов
  static var allCases: [SettingsScreenCell] = [
    .withoutRepetition(nil),
    .numbersGenerated(nil),
    .lastNumber(nil),
    .listOfNumbers(nil),
    .cleanButton(nil)
  ]
  
  /// Без повторений
  case withoutRepetition(WithoutRepetitionModel?)
  
  /// Чисел сгенерировано
  case numbersGenerated(NumbersGeneratedModel?)
  
  /// Последнее число
  case lastNumber(LastNumberModel?)
  
  /// Список чисел
  case listOfNumbers(ListOfNumbersModel?)
  
  /// Кнопка очистить
  case cleanButton(String?)
  
  /// Отступ
  case padding(CGFloat)
  
  // MARK: - WithoutRepetitionModel
  
  /// Без повторений
  struct WithoutRepetitionModel {
    
    /// Заголовок
    let title: String
    
    /// Переключатель
    var isOn: Bool
  }
  
  // MARK: - NumbersGeneratedModel
  
  /// Чисел сгенерировано
  struct NumbersGeneratedModel {
    
    /// Заголовок  слева
    let primaryText: String
    
    /// Заголовок справа
    let secondaryText: String
  }
  
  // MARK: - LastNumberModel
  
  /// Последнее число
  struct LastNumberModel {
    
    /// Заголовок  слева
    let primaryText: String
    
    /// Заголовок справа
    let secondaryText: String
  }
  
  // MARK: - ListOfNumbersModel
  
  /// Список чисел
  struct ListOfNumbersModel {
    
    /// Заголовок
    let title: String
    
    /// Боковая картинка
    let asideImage: UIImage?
  }
}

//
//  SettingsScreenCellModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

extension SettingsScreenType {
  
  // MARK: - WithoutRepetitionSettingsModel
  
  /// Моделька - `Без повторений`
  struct WithoutRepetitionSettingsModel {
    
    /// Заголовок
    let title: String
    
    /// Без повторений - включено `true / false`
    let isEnabled: Bool
  }
  
  // MARK: - CountGeneratedSettingsModel
  
  /// Моделька - `Количество объектов сгенерировано`
  struct CountGeneratedSettingsModel {
    
    /// Заголовок
    let title: String
    
    /// Количество объектов сгенерировано
    let countGeneratedText: String
  }
  
  // MARK: - LastObjectSettingsModel
  
  /// Моделька - `Последний сгенерированный объект`
  struct LastObjectSettingsModel {
    
    /// Заголовок
    let title: String
    
    /// Последний сгенерированный объект
    let lastObjectText: String
  }
  
  // MARK: - ListOfObjectsSettingsModel
  
  /// Моделька - `Список объектов`
  struct ListOfObjectsSettingsModel {
    
    /// Заголовок
    let title: String
    
    /// Иконка справой стороны ячейки
    let asideImage: UIImage?
  }
  
  // MARK: - CleanButtonSettingsModel
  
  /// Моделька - `Кнопка очистеть`
  struct CleanButtonSettingsModel {
    
    /// Заголовок
    let title: String
  }
}

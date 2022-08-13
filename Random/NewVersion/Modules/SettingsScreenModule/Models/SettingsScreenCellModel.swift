//
//  SettingsScreenCellModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

extension SettingsScreenType {
  
  // MARK: - TitleAndSwitcherModel
  
  /// Моделька - `Без повторений`
  struct TitleAndSwitcherModel {
    
    /// Заголовок
    let title: String
    
    /// Без повторений - включено `true / false`
    let isEnabled: Bool
  }
  
  // MARK: - TitleAndDescriptionModel
  
  /// Моделька - `Количество объектов сгенерировано`
  struct TitleAndDescriptionModel {
    
    /// Заголовок
    let title: String
    
    /// Описание
    let description: String
  }
  
  // MARK: - TitleAndImageModel
  
  /// Моделька - `Список объектов`
  struct TitleAndImageModel {
    
    /// Заголовок
    let title: String
    
    /// Иконка справой стороны ячейки
    let asideImage: UIImage?
  }
  
  // MARK: - CleanButtonModel
  
  /// Моделька - `Кнопка очистеть`
  struct CleanButtonModel {
    
    /// Заголовок
    let title: String
  }
}

//
//  SectionsIsHiddenFTModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

struct SectionsIsHiddenFTModel {
  
  /// Раздел: `Команды`
  let teams: Bool
  
  /// Раздел: `Число`
  let number: Bool
  
  /// Раздел: `Да или Нет`
  let yesOrNo: Bool
  
  /// Раздел: `Буква`
  let letter: Bool
  
  /// Раздел: `Список`
  let list: Bool
  
  /// Раздел: `Монета`
  let coin: Bool
  
  /// Раздел: `Кубики`
  let cube: Bool
  
  /// Раздел: `Дата и Время`
  let dateAndTime: Bool
  
  /// Раздел: `Лотерея`
  let lottery: Bool
  
  /// Раздел: `Контакты`
  let contact: Bool
  
  /// Раздел: `Пароли`
  let password: Bool
  
  /// Раздел: `Цвета`
  let colors: Bool
  
  /// Раздел: `Бутылочка`
  let bottle: Bool
  
  /// Раздел `Камень, ножницы, бумага`
  let rockPaperScissors: Bool
  
  /// Раздел `Фильтры изображений`
  let imageFilters: Bool
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - dictionary: Словарь с фича тогглами
  init(dictionary: [String: Any]) {
    teams = (dictionary["teams"] as? Int ?? .zero).boolValue
    number = (dictionary["number"] as? Int ?? .zero).boolValue
    yesOrNo = (dictionary["yesOrNo"] as? Int ?? .zero).boolValue
    letter = (dictionary["letter"] as? Int ?? .zero).boolValue
    list = (dictionary["list"] as? Int ?? .zero).boolValue
    coin = (dictionary["coin"] as? Int ?? .zero).boolValue
    cube = (dictionary["cube"] as? Int ?? .zero).boolValue
    dateAndTime = (dictionary["dateAndTime"] as? Int ?? .zero).boolValue
    lottery = (dictionary["lottery"] as? Int ?? .zero).boolValue
    contact = (dictionary["contact"] as? Int ?? .zero).boolValue
    password = (dictionary["password"] as? Int ?? .zero).boolValue
    colors = (dictionary["colors"] as? Int ?? .zero).boolValue
    bottle = (dictionary["bottle"] as? Int ?? .zero).boolValue
    rockPaperScissors = (dictionary["rockPaperScissors"] as? Int ?? .zero).boolValue
    imageFilters = (dictionary["rockPaperScissors"] as? Int ?? .zero).boolValue
  }
}

// MARK: - Private func

private extension Int {
  var boolValue: Bool {
    return (self as NSNumber).boolValue
  }
}

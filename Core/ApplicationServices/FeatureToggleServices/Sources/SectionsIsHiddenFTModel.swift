//
//  SectionsIsHiddenFTModel.swift
//  FeatureToggleServices
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

public struct SectionsIsHiddenFTModel: SectionsIsHiddenFTModelProtocol {
  
  /// Раздел: `Команды`
  public let teams: Bool
  
  /// Раздел: `Число`
  public let number: Bool
  
  /// Раздел: `Да или Нет`
  public let yesOrNo: Bool
  
  /// Раздел: `Буква`
  public let letter: Bool
  
  /// Раздел: `Список`
  public let list: Bool
  
  /// Раздел: `Монета`
  public let coin: Bool
  
  /// Раздел: `Кубики`
  public let cube: Bool
  
  /// Раздел: `Дата и Время`
  public let dateAndTime: Bool
  
  /// Раздел: `Лотерея`
  public let lottery: Bool
  
  /// Раздел: `Контакты`
  public let contact: Bool
  
  /// Раздел: `Пароли`
  public let password: Bool
  
  /// Раздел: `Цвета`
  public let colors: Bool
  
  /// Раздел: `Бутылочка`
  public let bottle: Bool
  
  /// Раздел `Камень, ножницы, бумага`
  public let rockPaperScissors: Bool
  
  /// Раздел `Фильтры изображений`
  public let imageFilters: Bool
  
  /// Раздел `Фильмы`
  public let films: Bool
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - dictionary: Словарь с фича тогглами
  public init(dictionary: [String: Any]) {
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
    imageFilters = (dictionary["imageFilters"] as? Int ?? .zero).boolValue
    films = (dictionary["films"] as? Int ?? .zero).boolValue
  }
}

// MARK: - Private func

private extension Int {
  var boolValue: Bool {
    return (self as NSNumber).boolValue
  }
}

//
//  LabelsFeatureToggleModel.swift
//  FeatureToggleServices
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

public struct LabelsFeatureToggleModel: LabelsFeatureToggleModelProtocol {
  
  /// Раздел: `Команды`
  public let teams: String
  
  /// Раздел: `Число`
  public let number: String
  
  /// Раздел: `Да или Нет`
  public let yesOrNo: String
  
  /// Раздел: `Буква`
  public let letter: String
  
  /// Раздел: `Список`
  public let list: String
  
  /// Раздел: `Монета`
  public let coin: String
  
  /// Раздел: `Кубики`
  public let cube: String
  
  /// Раздел: `Дата и Время`
  public let dateAndTime: String
  
  /// Раздел: `Лотерея`
  public let lottery: String
  
  /// Раздел: `Контакты`
  public let contact: String
  
  /// Раздел: `Пароли`
  public let password: String
  
  /// Раздел: `Цвета`
  public let colors: String
  
  /// Раздел: `Бутылочка`
  public let bottle: String
  
  /// Раздел `Камень, ножницы, бумага`
  public let rockPaperScissors: String
  
  /// Раздел `Фильтры изображений`
  public let imageFilters: String
  
  /// Раздел `Фильмы`
  public let films: String
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - dictionary: Словарь с фича тогглами
  public init(dictionary: [String: Any]) {
    teams = (dictionary["teams"] as? String ?? "")
    number = (dictionary["number"] as? String ?? "")
    yesOrNo = (dictionary["yesOrNo"] as? String ?? "")
    letter = (dictionary["letter"] as? String ?? "")
    list = (dictionary["list"] as? String ?? "")
    coin = (dictionary["coin"] as? String ?? "")
    cube = (dictionary["cube"] as? String ?? "")
    dateAndTime = (dictionary["dateAndTime"] as? String ?? "")
    lottery = (dictionary["lottery"] as? String ?? "")
    contact = (dictionary["contact"] as? String ?? "")
    password = (dictionary["password"] as? String ?? "")
    colors = (dictionary["colors"] as? String ?? "")
    bottle = (dictionary["bottle"] as? String ?? "")
    rockPaperScissors = (dictionary["rockPaperScissors"] as? String ?? "")
    imageFilters = (dictionary["imageFilters"] as? String ?? "")
    films = (dictionary["films"] as? String ?? "")
  }
}

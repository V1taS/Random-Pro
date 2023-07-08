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

  /// Раздел `Фильмы`
  let films: Bool
  
  /// Раздел `Никнейм`
  let nickName: Bool
  
  /// Раздел `Имена`
  let names: Bool
  
  /// Раздел `Поздравления`
  let congratulations: Bool
  
  /// Раздел `Хорошие дела`
  let goodDeeds: Bool
  
  /// Раздел `Загадки`
  let riddles: Bool
  
  /// Раздел `Анекдотов`
  let joke: Bool

  /// Раздел `Подарки`
  let gifts: Bool

  /// Раздел `Слоганы`
  let slogans: Bool
  
  /// Раздел `Цитаты`
  let quotes: Bool
  
  /// Раздел `Колесо фортуны`
  let fortuneWheel: Bool
  
  /// Раздел `Правда или действие`
  let truthOrDare: Bool
  
  /// Раздел `Мемы`
  let memes: Bool
  
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
    imageFilters = (dictionary["imageFilters"] as? Int ?? .zero).boolValue
    films = (dictionary["films"] as? Int ?? .zero).boolValue
    nickName = (dictionary["nickName"] as? Int ?? .zero).boolValue
    names = (dictionary["names"] as? Int ?? .zero).boolValue
    congratulations = (dictionary["congratulations"] as? Int ?? .zero).boolValue
    goodDeeds = (dictionary["goodDeeds"] as? Int ?? .zero).boolValue
    riddles = (dictionary["riddles"] as? Int ?? .zero).boolValue
    joke = (dictionary["joke"] as? Int ?? .zero).boolValue
    gifts = (dictionary["gifts"] as? Int ?? .zero).boolValue
    slogans = (dictionary["slogans"] as? Int ?? .zero).boolValue
    quotes = (dictionary["quotes"] as? Int ?? .zero).boolValue
    fortuneWheel = (dictionary["fortuneWheel"] as? Int ?? .zero).boolValue
    truthOrDare = (dictionary["truthOrDare"] as? Int ?? .zero).boolValue
    memes = (dictionary["memes"] as? Int ?? .zero).boolValue
  }
}

// MARK: - Private func

private extension Int {
  var boolValue: Bool {
    return (self as NSNumber).boolValue
  }
}

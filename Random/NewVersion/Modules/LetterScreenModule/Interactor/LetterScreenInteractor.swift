//
//  LetterScreenInteractor.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 16.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol LetterScreenInteractorOutput: AnyObject {
  
  /// Данные были получены
  /// - Parameter result: результат генерации
  func didRecive(result: String?)
  
  /// Возвращает перевернутый список результатов
  /// - Parameter listResult: список генераций
  func didRecive(listResult: [String])
}

protocol LetterScreenInteractorInput: AnyObject {
  
  /// Получить данные
  func getContent()
  
  /// Сoздать новые данные русских букв
  func generateContentRusLetter()
  
  /// Создать новые данные английских букв
  func generateContentEngLetter()
}

final class LetterScreenInteractor: LetterScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: LetterScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var result = Appearance().result
  private var listResult: [String] = []
  
  // MARK: - Internal func
  
  func getContent() {
    output?.didRecive(result: result)
    output?.didRecive(listResult: listResult)
  }
  
  func generateContentRusLetter() {
    let russianLetter = Appearance().listRussionLetter.shuffled().first ?? ""
    listResult.append(russianLetter)
    result = russianLetter
    
    output?.didRecive(listResult: listResult)
    output?.didRecive(result: result)
  }
  
  func generateContentEngLetter() {
    let englishLetter = Appearance().listEnglishLetter.shuffled().first ?? ""
    listResult.append(englishLetter)
    result = englishLetter
    
    output?.didRecive(result: result)
    output?.didRecive(listResult: listResult)
  }
}

// MARK: - private LetterScreenInteractor

private extension LetterScreenInteractor {
  struct Appearance {
    let result = "?"
    let listRussionLetter = [
      "А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т",
      "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь", "Э", "Ю", "Я"
    ]
    let listEnglishLetter = [
      "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
      "U", "V", "W", "X", "Y", "Z"
    ]
  }
}

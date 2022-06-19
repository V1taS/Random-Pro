//
//  CoinScreenInteractor.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 17.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol CoinScreenInteractorOutput: AnyObject {
  
  /// Данные были получены
  /// - Parameter result: результат генерации
  func didReciveName(result: String)
  
  /// Данные были получены
  /// - Parameter result: результат генерации
  func didReciveImage(result: UIImage?)
  
  /// Возвращает список результатов
  /// - Parameter listResult: список генераций
  func didRecive(listResult: [String])
}

protocol CoinScreenInteractorInput: AnyObject {
  
  /// Получить данные
  func getContent()
  
  /// Создать новые данные генерации
  func generateContentCoin()
}

final class CoinScreenInteractor: CoinScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: CoinScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var resultName = Appearance().resultName
  private var resultImage: UIImage?
  private var listResult: [String] = []
  
  // MARK: - Internal func
  
  func getContent() {
    output?.didRecive(listResult: listResult)
    output?.didReciveName(result: resultName)
    output?.didReciveImage(result: resultImage)
  }
  
  func generateContentCoin() {
    let appearance = Appearance()
    
    let randonIndex = Int.random(in: 0...1)
    let randomImage = appearance.imagesCoin[randonIndex]
    let randomName = appearance.namesCoin[randonIndex]
    
    resultName = randomName
    resultImage = randomImage
    listResult.append(randomName)
    
    output?.didRecive(listResult: listResult)
    output?.didReciveName(result: resultName)
    output?.didReciveImage(result: resultImage)
  }
}

// MARK: - CoinScreenInteractor

private extension CoinScreenInteractor {
  struct Appearance {
    let resultName = "?"
    let imagesCoin = [
      UIImage(named: "eagleNew") ?? UIImage(),
      UIImage(named: "tailsNew") ?? UIImage()
    ]
    
    let namesCoin = [
      NSLocalizedString("Орел", comment: ""),
      NSLocalizedString("Решка", comment: "")
    ]
  }
}

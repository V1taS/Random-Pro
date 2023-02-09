//
//  CubesScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol CubesScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: CubesScreenModel)
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol CubesScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> CubesScreenModel
  
  /// Обновить количество кубиков
  ///  - Parameter count: Количество кубиков
  func updateSelectedCountCubes(_ cubesType: CubesScreenModel.CubesType)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Кубики были подкинуты
  /// - Parameter totalValue: Сумма всех кубиков
  func diceAction(totalValue: Int)
  
  /// Показать список генераций результатов
  /// - Parameter isShow: показать  список генераций результатов
  func listGenerated(isShow: Bool)
}

final class CubesScreenInteractor: CubesScreenInteractorInput {
  
  // MARK: Internal property
  
  weak var output: CubesScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func listGenerated(isShow: Bool) {
    guard let model = storageService.cubesScreenModel else {
      return
    }
    
    let newModel = CubesScreenModel(
      listResult: model.listResult,
      isShowlistGenerated: isShow,
      cubesType: model.cubesType
    )
    self.storageService.cubesScreenModel = newModel
  }
  
  func updateSelectedCountCubes(_ cubesType: CubesScreenModel.CubesType) {
    guard let model = storageService.cubesScreenModel else {
      return
    }
    
    let newModel = CubesScreenModel(
      listResult: model.listResult,
      isShowlistGenerated: model.isShowlistGenerated,
      cubesType: cubesType
    )
    self.storageService.cubesScreenModel = newModel
  }
  
  func diceAction(totalValue: Int) {
    guard let model = storageService.cubesScreenModel else {
      return
    }
    
    var listResultNew = model.listResult
    listResultNew.append("\(totalValue)")
    
    let newModel = CubesScreenModel(
      listResult: listResultNew,
      isShowlistGenerated: model.isShowlistGenerated,
      cubesType: model.cubesType
    )
    self.storageService.cubesScreenModel = newModel
  }
  
  func getContent() {
    if let model = storageService.cubesScreenModel {
      output?.didReceive(model: model)
    } else {
      let newModel = Appearance().cubesModelDefault
      self.storageService.cubesScreenModel = newModel
      output?.didReceive(model: newModel)
    }
  }
  
  func returnCurrentModel() -> CubesScreenModel {
    if let model = storageService.cubesScreenModel {
      return model
    } else {
      return Appearance().cubesModelDefault
    }
  }
  
  func cleanButtonAction() {
    storageService.cubesScreenModel = nil
    getContent()
    output?.cleanButtonWasSelected()
  }
}

// MARK: - Appearance

private extension CubesScreenInteractor {
  struct Appearance {
    let cubesModelDefault = CubesScreenModel(
      listResult: [],
      isShowlistGenerated: true,
      cubesType: .cubesTwo
    )
  }
}

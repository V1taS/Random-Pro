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
  
  @ObjectCustomUserDefaultsWrapper<CubesScreenModel>(key: Appearance().keyUserDefaults)
  private var model: CubesScreenModel?
  
  // MARK: - Internal func
  
  func listGenerated(isShow: Bool) {
    guard let model = model else {
      return
    }
    
    let newModel = CubesScreenModel(
      listResult: model.listResult,
      isShowlistGenerated: isShow,
      cubesType: model.cubesType
    )
    self.model = newModel
  }
  
  func updateSelectedCountCubes(_ cubesType: CubesScreenModel.CubesType) {
    guard let model = model else {
      return
    }
    
    let newModel = CubesScreenModel(
      listResult: model.listResult,
      isShowlistGenerated: model.isShowlistGenerated,
      cubesType: cubesType
    )
    self.model = newModel
  }
  
  func diceAction(totalValue: Int) {
    guard let model = model else {
      return
    }
    
    var listResultNew = model.listResult
    listResultNew.append("\(totalValue)")
    
    let newModel = CubesScreenModel(
      listResult: listResultNew,
      isShowlistGenerated: model.isShowlistGenerated,
      cubesType: model.cubesType
    )
    self.model = newModel
  }
  
  func getContent() {
    cleanOldModelFirstStart()
    if let model = model {
      output?.didReceive(model: model)
    } else {
      let newModel = Appearance().cubesModelDefault
      self.model = newModel
      output?.didReceive(model: newModel)
    }
  }
  
  func returnCurrentModel() -> CubesScreenModel {
    if let model = model {
      return model
    } else {
      return Appearance().cubesModelDefault
    }
  }
  
  func cleanButtonAction() {
    model = nil
    getContent()
    output?.cleanButtonWasSelected()
  }
}

// MARK: - Private

private extension CubesScreenInteractor {
  func cleanOldModelFirstStart() {
    if !UserDefaults.standard.bool(forKey: Appearance().keyFirstStartUserDefaults) {
      model = nil
      UserDefaults.standard.set(true, forKey: Appearance().keyFirstStartUserDefaults)
    }
  }
}

// MARK: - Appearance

private extension CubesScreenInteractor {
  struct Appearance {
    let keyUserDefaults = "cubes_screen_user_defaults_key"
    let keyFirstStartUserDefaults = "cubes_screen_first_start_user_defaults_key"
    let cubesModelDefault = CubesScreenModel(
      listResult: [],
      isShowlistGenerated: true,
      cubesType: .cubesTwo
    )
  }
}

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
  func didRecive(model: CubesScreenModel)
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol CubesScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> CubesScreenModel
  
  /// Пользователь нажал на кнопку генерации
  func generateButtonAction()
  
  /// Обновить количество кубиков
  ///  - Parameter count: Количество кубиков
  func updateSelectedCountCubes(_ count: Int)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
}

final class CubesScreenInteractor: CubesScreenInteractorInput {
  
  // MARK: Internal property
  
  weak var output: CubesScreenInteractorOutput?
  
  // MARK: - Private property
  
  @ObjectCustomUserDefaultsWrapper<CubesScreenModel>(key: Appearance().keyUserDefaults)
  private var model: CubesScreenModel?
  
  // MARK: - Internal func
  
  func getContent() {
    if let model = model {
      output?.didRecive(model: model)
    } else {
      let newModel = Appearance().cubesModelDefault
      self.model = newModel
      output?.didRecive(model: newModel)
    }
  }
  
  func updateSelectedCountCubes(_ count: Int) {
    guard let model = model else {
      return
    }
    
    let newModel = CubesScreenModel(
      listResult: model.listResult,
      selectedCountCubes: count,
      cubesType: model.cubesType
    )
    self.model = newModel
  }

  func generateButtonAction() {
    guard let model = model else {
      return
    }
    if model.selectedCountCubes == 1 {
      var listResult: [String] = model.listResult
      let oneCube = Int.random(in: 1...6)
      listResult.append("\(oneCube)")
      
      let newModel = CubesScreenModel(
        listResult: listResult,
        selectedCountCubes: model.selectedCountCubes,
        cubesType: .cubesOne(oneCube)
      )
      self.model = newModel
      output?.didRecive(model: newModel)
      return
    }
    
    if model.selectedCountCubes == 2 {
      var listResult: [String] = model.listResult
      let oneCube = Int.random(in: 1...6)
      let twoCube = Int.random(in: 1...6)
      listResult.append("\(oneCube + twoCube)")
      
      let newModel = CubesScreenModel(
        listResult: listResult,
        selectedCountCubes: model.selectedCountCubes,
        cubesType: .cubesTwo(cubesOne: oneCube, cubesTwo: twoCube)
      )
      self.model = newModel
      output?.didRecive(model: newModel)
      return
    }
    
    if model.selectedCountCubes == 3 {
      var listResult: [String] = model.listResult
      let oneCube = Int.random(in: 1...6)
      let twoCube = Int.random(in: 1...6)
      let threeCube = Int.random(in: 1...6)
      listResult.append("\(oneCube + twoCube + threeCube)")
      
      let newModel = CubesScreenModel(
        listResult: listResult,
        selectedCountCubes: model.selectedCountCubes,
        cubesType: .cubesThree(cubesOne: oneCube,
                               cubesTwo: twoCube,
                               cubesThree: threeCube)
      )
      self.model = newModel
      output?.didRecive(model: newModel)
      return
    }
    
    if model.selectedCountCubes == 4 {
      var listResult: [String] = model.listResult
      let oneCube = Int.random(in: 1...6)
      let twoCube = Int.random(in: 1...6)
      let threeCube = Int.random(in: 1...6)
      let fourCube = Int.random(in: 1...6)
      listResult.append("\(oneCube + twoCube + threeCube + fourCube)")
      
      let newModel = CubesScreenModel(
        listResult: listResult,
        selectedCountCubes: model.selectedCountCubes,
        cubesType: .cubesFour(cubesOne: oneCube,
                              cubesTwo: twoCube,
                              cubesThree: threeCube,
                              cubesFour: fourCube)
      )
      self.model = newModel
      output?.didRecive(model: newModel)
      return
    }
    
    if model.selectedCountCubes == 5 {
      var listResult: [String] = model.listResult
      let oneCube = Int.random(in: 1...6)
      let twoCube = Int.random(in: 1...6)
      let threeCube = Int.random(in: 1...6)
      let fourCube = Int.random(in: 1...6)
      let fiveCube = Int.random(in: 1...6)
      listResult.append("\(oneCube + twoCube + threeCube + fourCube + fiveCube)")
      
      let newModel = CubesScreenModel(
        listResult: listResult,
        selectedCountCubes: model.selectedCountCubes,
        cubesType: .cubesFive(cubesOne: oneCube,
                              cubesTwo: twoCube,
                              cubesThree: threeCube,
                              cubesFour: fourCube,
                              cubesFive: fiveCube)
      )
      self.model = newModel
      output?.didRecive(model: newModel)
      return
    }
    
    if model.selectedCountCubes == 6 {
      var listResult: [String] = model.listResult
      let oneCube = Int.random(in: 1...6)
      let twoCube = Int.random(in: 1...6)
      let threeCube = Int.random(in: 1...6)
      let fourCube = Int.random(in: 1...6)
      let fiveCube = Int.random(in: 1...6)
      let sixCube = Int.random(in: 1...6)
      listResult.append("\(oneCube + twoCube + threeCube + fourCube + fiveCube + sixCube)")
      
      let newModel = CubesScreenModel(
        listResult: listResult,
        selectedCountCubes: model.selectedCountCubes,
        cubesType: .cubesSix(cubesOne: oneCube,
                             cubesTwo: twoCube,
                             cubesThree: threeCube,
                             cubesFour: fourCube,
                             cubesFive: fiveCube,
                             cubesSix: sixCube)
      )
      self.model = newModel
      output?.didRecive(model: newModel)
      return
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

// MARK: - Appearance

private extension CubesScreenInteractor {
  struct Appearance {
    let keyUserDefaults = "cubes_screen_user_defaults_key"
    let cubesModelDefault = CubesScreenModel(
      listResult: [],
      selectedCountCubes: 2,
      cubesType: .cubesTwo(cubesOne: 2, cubesTwo: 5)
    )
  }
}

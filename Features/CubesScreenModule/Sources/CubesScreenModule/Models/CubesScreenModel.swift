//
//  CubesScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

// MARK: - CubesScreenModel

struct CubesScreenModel: Codable, CubesScreenModelProtocol {
  
  /// Список результатов
  let listResult: [String]
  
  /// Показать список результатов
  let isShowlistGenerated: Bool
  
  /// Тип кубиков
  let cubesType: CubesScreenCubesTypeProtocol
  
  // MARK: - Initialization
  
  init(listResult: [String],
       isShowlistGenerated: Bool,
       cubesType: CubesType) {
    self.listResult = listResult
    self.isShowlistGenerated = isShowlistGenerated
    self.cubesType = cubesType
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    listResult = try container.decode([String].self, forKey: .listResult)
    isShowlistGenerated = try container.decode(Bool.self, forKey: .isShowlistGenerated)
    cubesType = try container.decode(CubesType.self, forKey: .cubesType)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(listResult, forKey: .listResult)
    try container.encode(isShowlistGenerated, forKey: .isShowlistGenerated)
    try container.encode(cubesType as? CubesType, forKey: .cubesType)
  }
  
  // MARK: - CodingKeys
  
  enum CodingKeys: CodingKey {
    case listResult
    case isShowlistGenerated
    case cubesType
  }
  
  // MARK: - CubesType
  
  /// Тип кубиков
  enum CubesType: Int, Codable, CubesScreenCubesTypeProtocol {
    
    /// Один кубик
    case cubesOne
    
    /// Два кубика
    case cubesTwo
    
    /// Три кубика
    case cubesThree
    
    /// Четыре кубика
    case cubesFour
    
    /// Пять кубиков
    case cubesFive
    
    /// Шесть кубиков
    case cubesSix
  }
}

// MARK: - toCodable

extension CubesScreenModelProtocol {
  func toCodable() -> CubesScreenModel? {
    guard let cubesType = cubesType as? CubesScreenModel.CubesType else {
      return nil
    }
    return CubesScreenModel(listResult: listResult,
                            isShowlistGenerated: isShowlistGenerated,
                            cubesType: cubesType)
  }
}

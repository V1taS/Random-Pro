//
//  SelecteAppIconScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct SelecteAppIconScreenModel: Codable, SelecteAppIconScreenModelProtocol {
  
  /// Выбранная иконка
  let selecteAppIconType: SelecteAppIconScreenTypeProtocol
  
  // MARK: - Initialization
  
  init(selecteAppIconType: SelecteAppIconType) {
    self.selecteAppIconType = selecteAppIconType
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    selecteAppIconType = try container.decode(SelecteAppIconType.self, forKey: .selecteAppIconType)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(selecteAppIconType as? SelecteAppIconType, forKey: .selecteAppIconType)
  }
  
  // MARK: - CodingKeys
  
  enum CodingKeys: CodingKey {
    case selecteAppIconType
  }
}

// MARK: - toCodable

extension SelecteAppIconScreenModelProtocol {
  func toCodable() -> SelecteAppIconScreenModel? {
    guard let selecteAppIconType = selecteAppIconType as? SelecteAppIconType else {
      return nil
    }
    return SelecteAppIconScreenModel(selecteAppIconType: selecteAppIconType)
  }
}

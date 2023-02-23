//
//  ContactScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

// MARK: - ContactScreenModel

struct ContactScreenModel: Codable, ContactScreenModelProtocol {
  
  /// Все контакты
  let allContacts: [ContactScreenContactModelProtocol]
  
  /// Список результатов
  let listResult: [String]
  
  /// Текущий результат
  let result: String
  
  // MARK: - Initialization
  
  init(allContacts: [Contact],
       listResult: [String],
       result: String) {
    self.allContacts = allContacts
    self.listResult = listResult
    self.result = result
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    allContacts = try container.decode([Contact].self, forKey: .allContacts)
    listResult = try container.decode([String].self, forKey: .listResult)
    result = try container.decode(String.self, forKey: .result)
  }
  
  // MARK: - Func `Encode`
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(allContacts as? [Contact], forKey: .allContacts)
    try container.encode(listResult, forKey: .listResult)
    try container.encode(result, forKey: .result)
  }
  
  // MARK: - CodingKeys
  
  enum CodingKeys: CodingKey {
    case allContacts
    case listResult
    case result
  }
  
  // MARK: - Contact
  
  /// Контакт
  struct Contact: Codable, ContactScreenContactModelProtocol {
    
    /// Имя
    let firstName: String
    
    /// Фамилия
    let lastName: String
    
    /// Телефон
    let telephone: String
  }
}

// MARK: - toCodable

extension ContactScreenModelProtocol {
  func toCodable() -> ContactScreenModel {
    let newAllContacts: [ContactScreenModel.Contact] = allContacts.map {
      return ContactScreenModel.Contact(firstName: $0.firstName,
                                        lastName: $0.lastName,
                                        telephone: $0.telephone)
    }
    
    return ContactScreenModel(allContacts: newAllContacts,
                              listResult: listResult,
                              result: result)
  }
}

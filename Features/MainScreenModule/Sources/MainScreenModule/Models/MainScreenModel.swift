//
//  MainScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - MainScreenModel

struct MainScreenModel: Codable, MainScreenModelProtocol, Equatable {
  
  var isDarkMode: Bool?
  var isPremium: Bool
  var allSections: [MainScreenSectionProtocol]
  
  // MARK: - Initialization
  
  init(isDarkMode: Bool?, isPremium: Bool, allSections: [Section]) {
    self.isDarkMode = isDarkMode
    self.isPremium = isPremium
    self.allSections = allSections
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    isDarkMode = try container.decode(Bool.self, forKey: .isDarkMode)
    isPremium = try container.decode(Bool.self, forKey: .isPremium)
    allSections = try container.decode([Section].self, forKey: .allSections)
  }
  
  // MARK: - Func `Encode`
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(isDarkMode, forKey: .isDarkMode)
    try container.encode(isPremium, forKey: .isPremium)
    let allSections = allSections.compactMap { $0 as? Section }
    try container.encode(allSections, forKey: .allSections)
  }
  
  // MARK: - CodingKeys
  
  enum CodingKeys: CodingKey {
    case isDarkMode
    case isPremium
    case allSections
  }
  
  // MARK: - Equatable
  
  static func == (lhs: MainScreenModel, rhs: MainScreenModel) -> Bool {
    return lhs.isDarkMode == rhs.isDarkMode &&
    lhs.isPremium == rhs.isPremium &&
    lhs.allSections as? [MainScreenModel.Section] == rhs.allSections as? [MainScreenModel.Section]
  }
}

// MARK: - toCodable

extension MainScreenModelProtocol {
  func toCodable() -> MainScreenModel? {
    let newAllSections: [MainScreenModel.Section] = allSections.map { section in
      MainScreenModel.Section(type: (section.type as? MainScreenModel.SectionType) ?? .bottle,
                              imageSectionSystemName: section.imageSectionSystemName,
                              titleSection: section.titleSection,
                              isEnabled: section.isEnabled,
                              isHidden: section.isHidden,
                              advLabel: (section.advLabel as? MainScreenModel.ADVLabel) ?? .none)
    }
    return MainScreenModel(isDarkMode: isDarkMode,
                           isPremium: isPremium,
                           allSections: newAllSections)
  }
}

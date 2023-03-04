//
//  MainScreenModel+Section.swift
//  MainScreenModule
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

extension MainScreenModel {
  
  // MARK: - Section
  
  struct Section: Codable, MainScreenSectionProtocol, Equatable {
    var type: MainScreenSectionTypeProtocol
    var imageSectionSystemName: String
    var titleSection: String
    var isEnabled: Bool
    var isHidden: Bool
    var advLabel: MainScreenADVLabelProtocol
    
    // MARK: - Initialization
    
    init(type: SectionType,
         imageSectionSystemName: String,
         titleSection: String,
         isEnabled: Bool,
         isHidden: Bool,
         advLabel: ADVLabel) {
      self.type = type
      self.imageSectionSystemName = imageSectionSystemName
      self.titleSection = titleSection
      self.isEnabled = isEnabled
      self.isHidden = isHidden
      self.advLabel = advLabel
    }
    
    // MARK: - Initialization `Decode`
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      type = try container.decode(SectionType.self, forKey: .type)
      imageSectionSystemName = try container.decode(String.self, forKey: .imageSectionSystemName)
      titleSection = try container.decode(String.self, forKey: .titleSection)
      isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
      isHidden = try container.decode(Bool.self, forKey: .isHidden)
      advLabel = try container.decode(ADVLabel.self, forKey: .advLabel)
    }
    
    // MARK: - Func `Encode`
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(type as? SectionType, forKey: .type)
      try container.encode(imageSectionSystemName, forKey: .imageSectionSystemName)
      try container.encode(titleSection, forKey: .titleSection)
      try container.encode(isEnabled, forKey: .isEnabled)
      try container.encode(isHidden, forKey: .isHidden)
      try container.encode(advLabel as? ADVLabel, forKey: .advLabel)
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: CodingKey {
      case type
      case imageSectionSystemName
      case titleSection
      case isEnabled
      case isHidden
      case advLabel
    }
    
    // MARK: - Equatable
    
    static func == (lhs: MainScreenModel.Section, rhs: MainScreenModel.Section) -> Bool {
      return lhs.type as? SectionType == rhs.type as? SectionType &&
      lhs.imageSectionSystemName == rhs.imageSectionSystemName &&
      lhs.titleSection == rhs.titleSection &&
      lhs.isEnabled == rhs.isEnabled &&
      lhs.isHidden == rhs.isHidden &&
      lhs.advLabel as? ADVLabel == rhs.advLabel as? ADVLabel
    }
  }
  
}

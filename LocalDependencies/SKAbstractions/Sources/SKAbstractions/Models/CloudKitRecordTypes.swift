//
//  CloudKitRecordTypes.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public enum CloudKitRecordTypes: String, Codable {
  case config = "Config"

  case congratulationsAnniversaries
  case congratulationsBirthday
  case congratulationsNewYear
  case congratulationsWedding

  case namesFemale
  case namesMale

  case giftIdeas
  case goodDeeds
  case jokes
  case memes
  case nicknames
  case quotes
  case riddles
  case slogans
  case truthOrDare
}

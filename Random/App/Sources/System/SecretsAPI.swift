//
//  Secrets.swift
//  Random
//
//  Created by Vitalii Sosin on 16.04.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct SecretsAPI {
  static let apiKeyYandexMetrica = "b4921e71-faf2-4bd3-8bea-e033a76457ae"
  static let apiKeyApphud = "API_KEY_HERE"
  static let apiKeyKinopoisk = "f835989c-b489-4624-9209-6d93bfead535"
  static let apiKeyTMDB = apiKeyTMDB1Part + apiKeyTMDB2Part + apiKeyTMDB3Part
  static let apiKeyMostPopularMovies = "f7321a82d8msh8cd3d6fb5db3824p1bef63jsn40adb1a66d30"
  static let fancyBackend = "API_KEY_HERE"
}

/// Parts of ApiKey TMDB
private extension SecretsAPI {
  static let apiKeyTMDB1Part = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2OGZjY2ZiZDc2NDQ0ZDYxZTE0MjA0OWNiMTZlMjE3YiIs"
  static let apiKeyTMDB2Part = "InN1YiI6IjY1NWFlNmIyN2YwNTQwMThkNDIwYTRlMSIsInNjb3BlcyI6WyJ"
  static let apiKeyTMDB3Part = "hcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.w9e8r57xPGNQXIVWYpr-HwXCUr2X6yO1sn63jjI-BVk"
}

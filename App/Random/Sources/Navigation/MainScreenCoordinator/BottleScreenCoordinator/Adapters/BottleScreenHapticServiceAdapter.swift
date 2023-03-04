//
//  BottleScreenHapticServiceAdapter.swift
//  Random
//
//  Created by Vitalii Sosin on 11.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import BottleScreenModule
import HapticService

final class BottleScreenHapticServiceAdapter: BottleScreenHapticServiceProtocol {
  
  // MARK: - Private property
  
  private let hapticService: HapticServiceProtocol
  
  // MARK: - Initialization
  
  init(_ hapticService: HapticServiceProtocol) {
    self.hapticService = hapticService
  }
  
  // MARK: - Internal func
  
  func play(isRepeat: Bool,
            patternType: BottleScreenPatternHapticTypeProtocol,
            completion: (Result<Void, Error>) -> Void) {
    guard let patternType = patternType as? HapticServicePatternTypeProtocol else {
      return
    }
    hapticService.play(isRepeat: isRepeat,
                       patternType: patternType,
                       completion: completion)
  }
  
  func stop() {
    hapticService.stop()
  }
}

extension HapticServiceImpl.PatternType: BottleScreenPatternHapticTypeProtocol {}

//
//  OnboardingServiceMock.swift
//  Random
//
//  Created by Artem Pavlov on 14.07.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
import WelcomeSheet
import RandomNetwork
@testable import Random

final class OnboardingServiceMock: OnboardingService {
  func saveWatchedStatus(to storage: StorageService, for models: [WelcomeSheet.WelcomeSheetPage]) {
  }

  func getOnboardingPagesForPresent(
    network: NetworkService,
    storage: StorageService,
    completion: (([WelcomeSheet.WelcomeSheetPage]) -> Void)?
  ) {
  }
}

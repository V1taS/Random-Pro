//
//  TimerServiceMock.swift
//  Random Pro Tests
//
//  Created by Tatyana Sosina on 08.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

final class TimerServiceMock: TimerService {
  func startTimerWith(seconds: Double,
                      timerTickAction: ((Double) -> Void)?,
                      timerFinishedAction: (() -> Void)?) {
    sleep(1)
    timerTickAction?(.zero)
    timerFinishedAction?()
  }
  
  func stopTimer() {}
}

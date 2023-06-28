//
//  NotificationServiceMock.swift
//  RandomTests
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

final class NotificationServiceMock: NotificationService {
  
  // Spy variables
  var showPositiveAlertCalled = false
  var showNeutralAlertCalled = false
  var showNegativeAlertCalled = false
  var showCustomAlertCalled = false
  
  // Stub variables
  var positiveAlertTitle: String?
  var positiveAlertGlyph: Bool?
  var positiveAlertTimeout: Double?
  var positiveAlertActive: (() -> Void)?
  
  var neutralAlertTitle: String?
  var neutralAlertGlyph: Bool?
  var neutralAlertTimeout: Double?
  var neutralAlertActive: (() -> Void)?
  
  var negativeAlertTitle: String?
  var negativeAlertGlyph: Bool?
  var negativeAlertTimeout: Double?
  var negativeAlertActive: (() -> Void)?
  
  var customAlertTitle: String?
  var customAlertTextColor: UIColor?
  var customAlertGlyph: Bool?
  var customAlertTimeout: Double?
  var customAlertBackgroundColor: UIColor?
  var customAlertImageGlyph: UIImage?
  var customAlertColorGlyph: UIColor?
  var customAlertActive: (() -> Void)?
  
  func showPositiveAlertWith(title: String, glyph: Bool, timeout: Double?, active: (() -> Void)?) {
    showPositiveAlertCalled = true
    positiveAlertTitle = title
    positiveAlertGlyph = glyph
    positiveAlertTimeout = timeout
    positiveAlertActive = active
  }
  
  func showNeutralAlertWith(title: String, glyph: Bool, timeout: Double?, active: (() -> Void)?) {
    showNeutralAlertCalled = true
    neutralAlertTitle = title
    neutralAlertGlyph = glyph
    neutralAlertTimeout = timeout
    neutralAlertActive = active
  }
  
  func showNegativeAlertWith(title: String, glyph: Bool, timeout: Double?, active: (() -> Void)?) {
    showNegativeAlertCalled = true
    negativeAlertTitle = title
    negativeAlertGlyph = glyph
    negativeAlertTimeout = timeout
    negativeAlertActive = active
  }
  
  func showCustomAlertWith(title: String,
                           textColor: UIColor?,
                           glyph: Bool,
                           timeout: Double?,
                           backgroundColor: UIColor?,
                           imageGlyph: UIImage?,
                           colorGlyph: UIColor?,
                           active: (() -> Void)?) {
    showCustomAlertCalled = true
    customAlertTitle = title
    customAlertTextColor = textColor
    customAlertGlyph = glyph
    customAlertTimeout = timeout
    customAlertBackgroundColor = backgroundColor
    customAlertImageGlyph = imageGlyph
    customAlertColorGlyph = colorGlyph
    customAlertActive = active
  }
}

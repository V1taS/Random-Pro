//
//  ReviewUtility.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation
import StoreKit

class ReviewUtility {

  static let sharedInstance = ReviewUtility()

  private init() {}

  func recordLaunch() {
    let defaults = UserDefaults.standard

    guard defaults.value(forKey: "requestReview") != nil else { defaults.set(1, forKey: "requestReview"); return }
    var totalLaunches: Int = defaults.value(forKey: "requestReview") as! Int
    totalLaunches += 1
    UserDefaults.standard.set(totalLaunches, forKey: "requestReview")
    if totalLaunches % 5 == 0 {
      if #available(iOS 10.3, *) {
        SKStoreReviewController.requestReview()
      }
    }
  }
}

//
//  AppPurchasesServiceMock.swift
//  RandomTests
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import ApphudSDK
import XCTest
@testable import Random

final class AppPurchasesServiceMock: AppPurchasesService {
  
  // Spy variables to check if the methods were called
  var getProductsCalled = false
  var purchaseWithCalled = false
  var restorePurchaseCalled = false
  var isValidatePurchaseCalled = false
  
  // Stub variables to mimic the returned values
  var products: [ApphudProduct]?
  var purchaseState: AppPurchasesServiceState?
  var restoreValidate: Bool?
  var isValidate: Bool?
  
  func getProducts(completion: @escaping ([ApphudSDK.ApphudProduct]?) -> Void) {
    getProductsCalled = true
    completion(products)
  }
  
  func purchaseWith(_ product: ApphudSDK.ApphudProduct,
                    completion: @escaping (Random.AppPurchasesServiceState) -> Void) {
    purchaseWithCalled = true
    completion(purchaseState ?? .somethingWentWrong)
  }
  
  func restorePurchase(completion: @escaping (Bool) -> Void) {
    restorePurchaseCalled = true
    completion(restoreValidate ?? false)
  }
  
  func isValidatePurchase(completion: @escaping (Bool) -> Void) {
    isValidatePurchaseCalled = true
    completion(isValidate ?? false)
  }
}

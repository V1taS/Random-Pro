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
  var getProductsStub: (() -> Void)?
  var purchaseWithStub: (() -> Void)?
  var restorePurchaseStub: (() -> Void)?
  var isValidatePurchaseStub: (() -> Void)?
  
  func getProducts(completion: @escaping ([ApphudSDK.ApphudProduct]?) -> Void) {
    getProductsCalled = true
    getProductsStub?()
    completion(nil)
  }
  
  func purchaseWith(_ product: ApphudSDK.ApphudProduct,
                    completion: @escaping (Random.AppPurchasesServiceState) -> Void) {
    purchaseWithCalled = true
    purchaseWithStub?()
    completion(.somethingWentWrong)
  }
  
  func restorePurchase(completion: @escaping (Bool) -> Void) {
    restorePurchaseCalled = true
    restorePurchaseStub?()
    completion(false)
  }
  
  func isValidatePurchase(completion: @escaping (Bool) -> Void) {
    isValidatePurchaseCalled = true
    isValidatePurchaseStub?()
    completion(false)
  }
}

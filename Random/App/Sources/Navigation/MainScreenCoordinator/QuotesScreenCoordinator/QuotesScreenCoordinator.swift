//
//  QuotesScreenCoordinator.swift
//  Random
//
//  Created by Mikhail Kolkov on 6/8/23.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

final class QuotesScreenCoordinator: Coordinator {
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var qoutesScreenModule: QuotesScreenModule?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let quotesScreenModule = QuotesScreenAssembly().createModule()
    self.qoutesScreenModule = quotesScreenModule
    navigationController.pushViewController(quotesScreenModule, animated: true)
  }
}

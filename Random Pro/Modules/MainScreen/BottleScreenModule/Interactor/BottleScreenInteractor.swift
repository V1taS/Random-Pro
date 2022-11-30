//
//  BottleScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol BottleScreenInteractorOutput: AnyObject {
  
}

/// События которые отправляем от Presenter к Interactor
protocol BottleScreenInteractorInput {
  
}

final class BottleScreenInteractor: BottleScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: BottleScreenInteractorOutput?
  
  func startAnimating() {
    
  }
  
  func stopAnimating() {
    
  }
}

//
//  BottleScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol BottleScreenInteractorOutput: AnyObject {
  
}

protocol BottleScreenInteractorInput {
  
}

final class BottleScreenInteractor: BottleScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: BottleScreenInteractorOutput?
}

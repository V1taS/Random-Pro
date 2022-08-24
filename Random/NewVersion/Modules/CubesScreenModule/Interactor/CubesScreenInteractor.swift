//
//  CubesScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol CubesScreenInteractorOutput: AnyObject {}

protocol CubesScreenInteractorInput {
  
  /// Получить данные
  func getContent()
}

final class CubesScreenInteractor: CubesScreenInteractorInput {
  
  weak var output: CubesScreenInteractorOutput?
  
  func getContent() {}
}

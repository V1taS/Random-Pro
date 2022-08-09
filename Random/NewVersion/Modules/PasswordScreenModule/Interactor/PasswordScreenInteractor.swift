//
//  PasswordScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol PasswordScreenInteractorOutput: AnyObject {}

protocol PasswordScreenInteractorInput {
  
  /// Получить данные
  func getContent()
}

final class PasswordScreenInteractor: PasswordScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: PasswordScreenInteractorOutput?
  
  // MARK: - Internal func
  
  func getContent() {}
}

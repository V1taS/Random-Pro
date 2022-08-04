//
//  PasswordScreenInteractor.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol PasswordScreenInteractorOutput: AnyObject {
  
}

protocol PasswordScreenInteractorInput: AnyObject {
  
  /// Получить данные
  func getContent()
}

final class PasswordScreenInteractor: PasswordScreenInteractorInput {
  
  weak var output: PasswordScreenInteractorOutput?
  
  private let rangeStartTextField = UITextField()
  private let rangeEndTextField = UITextField()
  private let resultLabel = UILabel()
  
  func getContent() {
    
  }
}

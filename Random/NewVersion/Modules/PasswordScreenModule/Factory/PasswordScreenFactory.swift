//
//  PasswordScreenFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol PasswordScreenFactoryOutput: AnyObject {}

protocol PasswordScreenFactoryInput {}

final class PasswordScreenFactory: PasswordScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: PasswordScreenFactoryOutput?
}

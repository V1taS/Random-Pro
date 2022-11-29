//
//  BottleScreenFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol BottleScreenFactoryOutput: AnyObject {
  
}

protocol BottleScreenFactoryInput {
  
}

final class BottleScreenFactory: BottleScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: BottleScreenFactoryOutput?
}

//
//  CubesScreenFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol CubesScreenFactoryOutput: AnyObject {}

protocol CubesScreenFactoryInput {}

final class CubesScreenFactory: CubesScreenFactoryInput {
  
  weak var output: CubesScreenFactoryOutput?
}

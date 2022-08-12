//
//  MoviesScreenFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol MoviesScreenFactoryOutput: AnyObject {}

protocol MoviesScreenFactoryInput {}

final class MoviesScreenFactory: MoviesScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: MoviesScreenFactoryOutput?
}

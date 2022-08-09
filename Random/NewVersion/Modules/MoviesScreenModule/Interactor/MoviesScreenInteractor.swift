//
//  MoviesScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol MoviesScreenInteractorOutput: AnyObject {}

protocol MoviesScreenInteractorInput {}

final class MoviesScreenInteractor: MoviesScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: MoviesScreenInteractorOutput?
}

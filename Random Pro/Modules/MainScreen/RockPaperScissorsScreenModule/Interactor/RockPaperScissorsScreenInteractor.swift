//
//  RockPaperScissorsScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol RockPaperScissorsScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol RockPaperScissorsScreenInteractorInput {}

final class RockPaperScissorsScreenInteractor: RockPaperScissorsScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: RockPaperScissorsScreenInteractorOutput?
}

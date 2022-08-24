//
//  ListScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ListScreenInteractorOutput: AnyObject {}

/// События которые отправляем из Presenter к Interactor
protocol ListScreenInteractorInput {}

final class ListScreenInteractor: ListScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: ListScreenInteractorOutput?
}

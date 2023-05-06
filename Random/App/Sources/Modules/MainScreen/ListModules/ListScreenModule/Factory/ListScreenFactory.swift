//
//  ListScreenFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из Factory в Presenter
protocol ListScreenFactoryOutput: AnyObject {}

/// События которые отправляем из Presenter к Factory
protocol ListScreenFactoryInput {}

final class ListScreenFactory: ListScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: ListScreenFactoryOutput?
}

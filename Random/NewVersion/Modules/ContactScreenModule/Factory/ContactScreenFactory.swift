//
//  ContactScreenFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из Factory в Presenter
protocol ContactScreenFactoryOutput: AnyObject {}

/// События которые отправляем от Presenter ко Factory
protocol ContactScreenFactoryInput {}

final class ContactScreenFactory: ContactScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: ContactScreenFactoryOutput?
}

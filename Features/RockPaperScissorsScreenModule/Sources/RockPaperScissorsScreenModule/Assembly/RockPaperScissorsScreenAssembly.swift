//
//  RockPaperScissorsScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

public final class RockPaperScissorsScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `RockPaperScissorsScreen`
  /// - Parameters:
  /// - Returns: Cобранный модуль `RockPaperScissorsScreen`
  public func createModule() -> RockPaperScissorsScreenModule {
    let view = RockPaperScissorsScreenView()
    let interactor = RockPaperScissorsScreenInteractor()
    let factory = RockPaperScissorsScreenFactory()
    let presenter = RockPaperScissorsScreenViewController(moduleView: view,
                                                          interactor: interactor,
                                                          factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}